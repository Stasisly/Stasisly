-- FOUNDATION-013B: server-managed idempotency and atomic Conversation writes.
-- Canonical Conversation is stored physically in transitional chat_sessions.
BEGIN;

CREATE TABLE public.conversation_idempotency (
  subject_id UUID NOT NULL,
  operation_id TEXT NOT NULL,
  idempotency_key TEXT NOT NULL,
  payload_fingerprint TEXT NOT NULL,
  state TEXT NOT NULL DEFAULT 'started',
  result_reference UUID,
  result_metadata JSONB NOT NULL DEFAULT '{}'::JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  PRIMARY KEY (subject_id, operation_id, idempotency_key),
  CONSTRAINT conversation_idempotency_operation_valid
    CHECK (operation_id IN ('create_conversation', 'send_user_message')),
  CONSTRAINT conversation_idempotency_key_valid
    CHECK (
      char_length(idempotency_key) BETWEEN 16 AND 128
      AND idempotency_key ~ '^[A-Za-z0-9._~-]+$'
    ),
  CONSTRAINT conversation_idempotency_fingerprint_valid
    CHECK (payload_fingerprint ~ '^[0-9a-f]{64}$'),
  CONSTRAINT conversation_idempotency_state_valid
    CHECK (state IN ('started', 'completed', 'failed_retryable', 'failed_final')),
  CONSTRAINT conversation_idempotency_result_metadata_valid
    CHECK (jsonb_typeof(result_metadata) = 'object'),
  CONSTRAINT conversation_idempotency_completion_valid
    CHECK (
      (state = 'completed' AND result_reference IS NOT NULL AND completed_at IS NOT NULL)
      OR (state <> 'completed' AND completed_at IS NULL)
    )
);

COMMENT ON TABLE public.conversation_idempotency IS
  'Backend-only operation ledger. Stores fingerprints and result references, never tokens or request payloads.';
COMMENT ON COLUMN public.conversation_idempotency.result_metadata IS
  'Non-sensitive result metadata required to reproduce the original logical response.';

ALTER TABLE public.conversation_idempotency ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversation_idempotency NO FORCE ROW LEVEL SECURITY;
REVOKE ALL PRIVILEGES ON TABLE public.conversation_idempotency
  FROM PUBLIC, anon, authenticated;
GRANT SELECT, INSERT, UPDATE ON TABLE public.conversation_idempotency
  TO service_role;

CREATE INDEX idx_conversation_idempotency_created_at
ON public.conversation_idempotency(created_at);

CREATE OR REPLACE FUNCTION public.create_own_chat_session_core(
  p_owner_user_id UUID,
  p_selectable_specialist_id UUID,
  p_idempotency_key TEXT
)
RETURNS TABLE (
  session_id UUID,
  started_at TIMESTAMP WITHOUT TIME ZONE,
  last_message_at TIMESTAMP WITHOUT TIME ZONE,
  status TEXT,
  message_count INTEGER,
  selectable_specialist_id UUID,
  specialist_display_name TEXT,
  product_area TEXT,
  idempotent_replay BOOLEAN
)
LANGUAGE plpgsql
SET search_path = public, extensions, pg_temp
AS $$
DECLARE
  v_fingerprint TEXT;
  v_operation public.conversation_idempotency%ROWTYPE;
  v_catalog public.specialist_catalog%ROWTYPE;
  v_session public.chat_sessions%ROWTYPE;
BEGIN
  IF p_owner_user_id IS NULL OR p_selectable_specialist_id IS NULL THEN
    RAISE EXCEPTION 'invalid_request' USING ERRCODE = 'P0001';
  END IF;
  IF p_idempotency_key IS NULL
    OR char_length(p_idempotency_key) NOT BETWEEN 16 AND 128
    OR p_idempotency_key !~ '^[A-Za-z0-9._~-]+$'
  THEN
    RAISE EXCEPTION 'invalid_idempotency_key' USING ERRCODE = 'P0001';
  END IF;

  v_fingerprint := encode(
    extensions.digest(convert_to(p_selectable_specialist_id::TEXT, 'UTF8'), 'sha256'),
    'hex'
  );

  INSERT INTO public.conversation_idempotency (
    subject_id, operation_id, idempotency_key, payload_fingerprint
  ) VALUES (
    p_owner_user_id, 'create_conversation', p_idempotency_key, v_fingerprint
  ) ON CONFLICT DO NOTHING;

  SELECT * INTO STRICT v_operation
  FROM public.conversation_idempotency
  WHERE subject_id = p_owner_user_id
    AND operation_id = 'create_conversation'
    AND idempotency_key = p_idempotency_key
  FOR UPDATE;

  IF v_operation.payload_fingerprint <> v_fingerprint THEN
    RAISE EXCEPTION 'idempotency_conflict' USING ERRCODE = 'P0001';
  END IF;
  IF v_operation.state = 'completed' THEN
    SELECT * INTO v_session
    FROM public.chat_sessions
    WHERE id = v_operation.result_reference
      AND user_id = p_owner_user_id;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'transaction_failed' USING ERRCODE = 'P0001';
    END IF;
    RETURN QUERY SELECT
      v_session.id,
      v_session.started_at,
      v_session.last_message_at,
      v_session.status,
      v_session.message_count,
      (v_operation.result_metadata->>'selectableSpecialistId')::UUID,
      v_operation.result_metadata->>'displayName',
      v_operation.result_metadata->>'productArea',
      TRUE;
    RETURN;
  END IF;
  IF v_operation.state <> 'started' THEN
    RAISE EXCEPTION 'operation_in_progress' USING ERRCODE = 'P0001';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM public.users WHERE id = p_owner_user_id) THEN
    RAISE EXCEPTION 'permission_denied' USING ERRCODE = 'P0001';
  END IF;

  SELECT * INTO v_catalog
  FROM public.specialist_catalog
  WHERE id = p_selectable_specialist_id
  FOR SHARE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'invalid_selectable_specialist' USING ERRCODE = 'P0001';
  END IF;
  IF v_catalog.product_area NOT IN ('stasis', 'health', 'nutrition', 'training', 'wellness')
    OR v_catalog.publication_status <> 'published'
    OR NOT v_catalog.is_published
    OR v_catalog.supported_surfaces <> ARRAY['product']::TEXT[]
    OR NOT v_catalog.is_conversable
  THEN
    RAISE EXCEPTION 'invalid_selectable_specialist' USING ERRCODE = 'P0001';
  END IF;
  IF v_catalog.availability_status <> 'available' THEN
    RAISE EXCEPTION 'specialist_unavailable' USING ERRCODE = 'P0001';
  END IF;
  IF v_catalog.access_tier IN ('pro', 'vip') THEN
    RAISE EXCEPTION 'pro_locked' USING ERRCODE = 'P0001';
  END IF;
  IF v_catalog.access_tier <> 'free' THEN
    RAISE EXCEPTION 'invalid_selectable_specialist' USING ERRCODE = 'P0001';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM public.specialists WHERE id = v_catalog.specialist_id
  ) THEN
    RAISE EXCEPTION 'backend_misconfigured' USING ERRCODE = 'P0001';
  END IF;

  INSERT INTO public.chat_sessions (user_id, specialist_id, status, message_count)
  VALUES (p_owner_user_id, v_catalog.specialist_id, 'active', 0)
  RETURNING * INTO v_session;

  UPDATE public.conversation_idempotency
  SET state = 'completed',
      result_reference = v_session.id,
      result_metadata = jsonb_build_object(
        'selectableSpecialistId', v_catalog.id,
        'displayName', v_catalog.display_name,
        'productArea', v_catalog.product_area
      ),
      completed_at = now()
  WHERE subject_id = p_owner_user_id
    AND operation_id = 'create_conversation'
    AND idempotency_key = p_idempotency_key;

  RETURN QUERY SELECT
    v_session.id,
    v_session.started_at,
    v_session.last_message_at,
    v_session.status,
    v_session.message_count,
    v_catalog.id,
    v_catalog.display_name,
    v_catalog.product_area,
    FALSE;
END;
$$;

DROP FUNCTION public.send_user_message_core(UUID, UUID, TEXT);

CREATE FUNCTION public.send_user_message_core(
  p_session_id UUID,
  p_owner_user_id UUID,
  p_content TEXT,
  p_idempotency_key TEXT
)
RETURNS TABLE (
  message_id UUID,
  session_id UUID,
  role TEXT,
  content TEXT,
  created_at TIMESTAMP WITHOUT TIME ZONE,
  session_message_count INTEGER,
  session_last_message_at TIMESTAMP WITHOUT TIME ZONE,
  idempotent_replay BOOLEAN
)
LANGUAGE plpgsql
SET search_path = public, extensions, pg_temp
AS $$
DECLARE
  v_content TEXT;
  v_fingerprint TEXT;
  v_operation public.conversation_idempotency%ROWTYPE;
  v_message public.messages%ROWTYPE;
  v_session public.chat_sessions%ROWTYPE;
BEGIN
  IF p_session_id IS NULL OR p_owner_user_id IS NULL THEN
    RAISE EXCEPTION 'invalid_request' USING ERRCODE = 'P0001';
  END IF;
  IF p_content IS NULL THEN
    RAISE EXCEPTION 'content_invalid' USING ERRCODE = 'P0001';
  END IF;
  v_content := btrim(p_content);
  IF v_content = '' THEN
    RAISE EXCEPTION 'content_invalid' USING ERRCODE = 'P0001';
  END IF;
  IF char_length(v_content) > 4000 THEN
    RAISE EXCEPTION 'content_too_long' USING ERRCODE = 'P0001';
  END IF;
  IF p_idempotency_key IS NULL
    OR char_length(p_idempotency_key) NOT BETWEEN 16 AND 128
    OR p_idempotency_key !~ '^[A-Za-z0-9._~-]+$'
  THEN
    RAISE EXCEPTION 'invalid_idempotency_key' USING ERRCODE = 'P0001';
  END IF;

  v_fingerprint := encode(
    extensions.digest(
      convert_to(p_session_id::TEXT || E'\n' || v_content, 'UTF8'),
      'sha256'
    ),
    'hex'
  );

  INSERT INTO public.conversation_idempotency (
    subject_id, operation_id, idempotency_key, payload_fingerprint
  ) VALUES (
    p_owner_user_id, 'send_user_message', p_idempotency_key, v_fingerprint
  ) ON CONFLICT DO NOTHING;

  SELECT * INTO STRICT v_operation
  FROM public.conversation_idempotency
  WHERE subject_id = p_owner_user_id
    AND operation_id = 'send_user_message'
    AND idempotency_key = p_idempotency_key
  FOR UPDATE;

  IF v_operation.payload_fingerprint <> v_fingerprint THEN
    RAISE EXCEPTION 'idempotency_conflict' USING ERRCODE = 'P0001';
  END IF;
  IF v_operation.state = 'completed' THEN
    SELECT m.* INTO v_message
    FROM public.messages AS m
    WHERE m.id = v_operation.result_reference
      AND m.session_id = p_session_id;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'transaction_failed' USING ERRCODE = 'P0001';
    END IF;
    RETURN QUERY SELECT
      v_message.id,
      v_message.session_id,
      v_message.role,
      v_message.content,
      v_message.created_at,
      (v_operation.result_metadata->>'messageCount')::INTEGER,
      (v_operation.result_metadata->>'lastMessageAt')::TIMESTAMP WITHOUT TIME ZONE,
      TRUE;
    RETURN;
  END IF;
  IF v_operation.state <> 'started' THEN
    RAISE EXCEPTION 'operation_in_progress' USING ERRCODE = 'P0001';
  END IF;

  SELECT * INTO v_session
  FROM public.chat_sessions
  WHERE id = p_session_id
    AND user_id = p_owner_user_id
  FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'session_not_found' USING ERRCODE = 'P0001';
  END IF;
  IF v_session.status = 'archived' THEN
    RAISE EXCEPTION 'session_archived' USING ERRCODE = 'P0001';
  END IF;
  IF v_session.status <> 'active' THEN
    RAISE EXCEPTION 'session_not_active' USING ERRCODE = 'P0001';
  END IF;

  INSERT INTO public.messages (session_id, role, content, attachments)
  VALUES (p_session_id, 'user', v_content, NULL)
  RETURNING * INTO v_message;

  UPDATE public.chat_sessions
  SET message_count = message_count + 1,
      last_message_at = v_message.created_at
  WHERE id = p_session_id
    AND user_id = p_owner_user_id
    AND status = 'active'
  RETURNING * INTO v_session;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'write_unconfirmed' USING ERRCODE = 'P0001';
  END IF;

  UPDATE public.conversation_idempotency
  SET state = 'completed',
      result_reference = v_message.id,
      result_metadata = jsonb_build_object(
        'messageCount', v_session.message_count,
        'lastMessageAt', v_session.last_message_at
      ),
      completed_at = now()
  WHERE subject_id = p_owner_user_id
    AND operation_id = 'send_user_message'
    AND idempotency_key = p_idempotency_key;

  RETURN QUERY SELECT
    v_message.id,
    v_message.session_id,
    v_message.role,
    v_message.content,
    v_message.created_at,
    v_session.message_count,
    v_session.last_message_at,
    FALSE;
END;
$$;

REVOKE ALL ON FUNCTION public.create_own_chat_session_core(UUID, UUID, TEXT)
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.send_user_message_core(UUID, UUID, TEXT, TEXT)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.create_own_chat_session_core(UUID, UUID, TEXT)
  TO service_role;
GRANT EXECUTE ON FUNCTION public.send_user_message_core(UUID, UUID, TEXT, TEXT)
  TO service_role;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_catalog.pg_policies
    WHERE schemaname = 'public' AND tablename = 'conversation_idempotency'
  ) THEN
    RAISE EXCEPTION 'FOUNDATION-013B requires zero idempotency policies';
  END IF;
  IF has_table_privilege('anon', 'public.conversation_idempotency', 'SELECT,INSERT,UPDATE,DELETE')
    OR has_table_privilege('authenticated', 'public.conversation_idempotency', 'SELECT,INSERT,UPDATE,DELETE')
    OR has_function_privilege('anon', 'public.create_own_chat_session_core(uuid,uuid,text)', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.create_own_chat_session_core(uuid,uuid,text)', 'EXECUTE')
    OR has_function_privilege('anon', 'public.send_user_message_core(uuid,uuid,text,text)', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.send_user_message_core(uuid,uuid,text,text)', 'EXECUTE')
  THEN
    RAISE EXCEPTION 'FOUNDATION-013B client access must remain denied';
  END IF;
END
$$;

COMMIT;

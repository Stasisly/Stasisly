BEGIN;

ALTER TABLE public.messages
  ADD COLUMN author_type TEXT NOT NULL DEFAULT 'unknown',
  ADD COLUMN provenance_type TEXT NOT NULL DEFAULT 'unknown',
  ADD COLUMN visibility_type TEXT NOT NULL DEFAULT 'unknown';

-- Only completed send-user-message ledger entries prove historical authorship.
UPDATE public.messages AS message
SET author_type = 'user',
    provenance_type = 'userProvided',
    visibility_type = 'productVisible'
FROM public.conversation_idempotency AS operation
WHERE operation.operation_id = 'send_user_message'
  AND operation.state = 'completed'
  AND operation.result_reference = message.id
  AND message.role = 'user';

UPDATE public.messages
SET visibility_type = 'internal'
WHERE role = 'tool';

ALTER TABLE public.messages
  ADD CONSTRAINT messages_author_type_valid CHECK (
    author_type IN ('user', 'stasis', 'specialist', 'systemNotice', 'unknown')
  ),
  ADD CONSTRAINT messages_provenance_type_valid CHECK (
    provenance_type IN (
      'userProvided', 'stasisConsolidated', 'specialistProvided',
      'systemGenerated', 'imported', 'unknown'
    )
  ),
  ADD CONSTRAINT messages_visibility_type_valid CHECK (
    visibility_type IN (
      'productVisible', 'ownerOnly', 'systemVisible', 'internal',
      'redacted', 'unknown'
    )
  ),
  ADD CONSTRAINT messages_author_provenance_visibility_coherent CHECK (
    (author_type = 'user'
      AND provenance_type = 'userProvided'
      AND visibility_type IN ('productVisible', 'ownerOnly', 'redacted'))
    OR (author_type = 'stasis'
      AND provenance_type = 'stasisConsolidated'
      AND visibility_type IN ('productVisible', 'ownerOnly', 'redacted'))
    OR (author_type = 'specialist'
      AND provenance_type = 'specialistProvided'
      AND visibility_type IN ('productVisible', 'ownerOnly', 'redacted'))
    OR (author_type = 'systemNotice'
      AND provenance_type = 'systemGenerated'
      AND visibility_type IN ('systemVisible', 'ownerOnly', 'redacted'))
    OR (author_type = 'unknown'
      AND provenance_type IN ('imported', 'unknown')
      AND visibility_type IN ('internal', 'redacted', 'unknown'))
  );

COMMENT ON COLUMN public.messages.author_type IS
  'Backend-controlled Product author category; unknown preserves unproven legacy authorship.';
COMMENT ON COLUMN public.messages.provenance_type IS
  'Backend-controlled evidence category; never derived from message text or client input.';
COMMENT ON COLUMN public.messages.visibility_type IS
  'Backend-controlled Product visibility; internal and unknown fail closed.';

CREATE INDEX idx_messages_product_read
ON public.messages(session_id, visibility_type, created_at ASC, id ASC);

DROP FUNCTION public.send_user_message_core(UUID, UUID, TEXT, TEXT);

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
  author_type TEXT,
  provenance_type TEXT,
  visibility_type TEXT,
  message_status TEXT,
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
  IF p_content IS NULL OR btrim(p_content) = '' THEN
    RAISE EXCEPTION 'content_invalid' USING ERRCODE = 'P0001';
  END IF;
  v_content := btrim(p_content);
  IF char_length(v_content) > 4000 THEN
    RAISE EXCEPTION 'content_too_long' USING ERRCODE = 'P0001';
  END IF;
  IF p_idempotency_key IS NULL
    OR char_length(p_idempotency_key) NOT BETWEEN 16 AND 128
    OR p_idempotency_key !~ '^[A-Za-z0-9._~-]+$'
  THEN
    RAISE EXCEPTION 'invalid_idempotency_key' USING ERRCODE = 'P0001';
  END IF;

  v_fingerprint := encode(extensions.digest(
    convert_to(p_session_id::TEXT || E'\n' || v_content, 'UTF8'), 'sha256'
  ), 'hex');

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
    SELECT message.* INTO v_message FROM public.messages AS message
    WHERE message.id = v_operation.result_reference
      AND message.session_id = p_session_id;
    IF NOT FOUND THEN
      RAISE EXCEPTION 'transaction_failed' USING ERRCODE = 'P0001';
    END IF;
    RETURN QUERY SELECT v_message.id, v_message.session_id, v_message.role,
      v_message.content, v_message.created_at, v_message.author_type,
      v_message.provenance_type, v_message.visibility_type, 'accepted'::TEXT,
      (v_operation.result_metadata->>'messageCount')::INTEGER,
      (v_operation.result_metadata->>'lastMessageAt')::TIMESTAMP WITHOUT TIME ZONE,
      TRUE;
    RETURN;
  END IF;
  IF v_operation.state <> 'started' THEN
    RAISE EXCEPTION 'operation_in_progress' USING ERRCODE = 'P0001';
  END IF;

  SELECT * INTO v_session FROM public.chat_sessions
  WHERE id = p_session_id AND user_id = p_owner_user_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'session_not_found' USING ERRCODE = 'P0001';
  END IF;
  IF v_session.status = 'archived' THEN
    RAISE EXCEPTION 'session_archived' USING ERRCODE = 'P0001';
  END IF;
  IF v_session.status <> 'active' THEN
    RAISE EXCEPTION 'session_not_active' USING ERRCODE = 'P0001';
  END IF;

  INSERT INTO public.messages (
    session_id, role, content, attachments,
    author_type, provenance_type, visibility_type
  ) VALUES (
    p_session_id, 'user', v_content, NULL,
    'user', 'userProvided', 'productVisible'
  ) RETURNING * INTO v_message;

  UPDATE public.chat_sessions
  SET message_count = message_count + 1,
      last_message_at = v_message.created_at
  WHERE id = p_session_id AND user_id = p_owner_user_id AND status = 'active'
  RETURNING * INTO v_session;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'write_unconfirmed' USING ERRCODE = 'P0001';
  END IF;

  UPDATE public.conversation_idempotency
  SET state = 'completed', result_reference = v_message.id,
      result_metadata = jsonb_build_object(
        'messageCount', v_session.message_count,
        'lastMessageAt', v_session.last_message_at
      ), completed_at = now()
  WHERE subject_id = p_owner_user_id
    AND operation_id = 'send_user_message'
    AND idempotency_key = p_idempotency_key;

  RETURN QUERY SELECT v_message.id, v_message.session_id, v_message.role,
    v_message.content, v_message.created_at, v_message.author_type,
    v_message.provenance_type, v_message.visibility_type, 'accepted'::TEXT,
    v_session.message_count, v_session.last_message_at, FALSE;
END;
$$;

CREATE FUNCTION public.list_own_conversation_messages_core(
  p_owner_user_id UUID,
  p_session_id UUID,
  p_limit INTEGER,
  p_after_created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
  p_after_message_id UUID DEFAULT NULL
)
RETURNS TABLE (
  message_id UUID,
  session_id UUID,
  role TEXT,
  content TEXT,
  created_at TIMESTAMP WITHOUT TIME ZONE,
  author_type TEXT,
  provenance_type TEXT,
  visibility_type TEXT,
  message_status TEXT
)
LANGUAGE plpgsql
STABLE
SET search_path = public, pg_temp
AS $$
BEGIN
  IF p_owner_user_id IS NULL OR p_session_id IS NULL
    OR p_limit IS NULL OR p_limit NOT BETWEEN 1 AND 101
    OR ((p_after_created_at IS NULL) <> (p_after_message_id IS NULL))
  THEN
    RAISE EXCEPTION 'invalid_request' USING ERRCODE = 'P0001';
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM public.chat_sessions
    WHERE id = p_session_id
      AND user_id = p_owner_user_id
      AND status IN ('active', 'archived')
  ) THEN
    RAISE EXCEPTION 'session_not_found' USING ERRCODE = 'P0001';
  END IF;

  RETURN QUERY
  SELECT message.id, message.session_id, message.role,
    CASE WHEN message.visibility_type = 'redacted' THEN NULL ELSE message.content END,
    message.created_at, message.author_type, message.provenance_type,
    message.visibility_type,
    CASE WHEN message.visibility_type = 'redacted' THEN 'redacted' ELSE 'accepted' END
  FROM public.messages AS message
  WHERE message.session_id = p_session_id
    AND message.visibility_type IN (
      'productVisible', 'ownerOnly', 'systemVisible', 'redacted'
    )
    AND (
      p_after_created_at IS NULL
      OR (message.created_at, message.id) > (p_after_created_at, p_after_message_id)
    )
  ORDER BY message.created_at ASC, message.id ASC
  LIMIT p_limit;
END;
$$;

REVOKE ALL ON FUNCTION public.send_user_message_core(UUID, UUID, TEXT, TEXT)
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.list_own_conversation_messages_core(
  UUID, UUID, INTEGER, TIMESTAMP WITHOUT TIME ZONE, UUID
) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.send_user_message_core(UUID, UUID, TEXT, TEXT)
  TO service_role;
GRANT EXECUTE ON FUNCTION public.list_own_conversation_messages_core(
  UUID, UUID, INTEGER, TIMESTAMP WITHOUT TIME ZONE, UUID
) TO service_role;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM pg_catalog.pg_policies
    WHERE schemaname = 'public' AND tablename = 'messages'
  ) OR has_table_privilege('anon', 'public.messages', 'SELECT,INSERT,UPDATE,DELETE')
    OR has_table_privilege('authenticated', 'public.messages', 'SELECT,INSERT,UPDATE,DELETE')
    OR has_function_privilege('anon', 'public.send_user_message_core(uuid,uuid,text,text)', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.send_user_message_core(uuid,uuid,text,text)', 'EXECUTE')
    OR has_function_privilege('anon', 'public.list_own_conversation_messages_core(uuid,uuid,integer,timestamp without time zone,uuid)', 'EXECUTE')
    OR has_function_privilege('authenticated', 'public.list_own_conversation_messages_core(uuid,uuid,integer,timestamp without time zone,uuid)', 'EXECUTE')
  THEN
    RAISE EXCEPTION 'FOUNDATION-013D client message access must remain denied';
  END IF;
END
$$;

COMMIT;

-- 2B-V-C1: transactional core for local user message sends.
-- This function is intentionally not SECURITY DEFINER.
BEGIN;

DO $$
BEGIN
  IF to_regclass('public.messages') IS NULL THEN
    RAISE EXCEPTION '2B-V-C1 requires public.messages';
  END IF;

  IF to_regclass('public.chat_sessions') IS NULL THEN
    RAISE EXCEPTION '2B-V-C1 requires public.chat_sessions';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_catalog.pg_policies
    WHERE schemaname = 'public'
      AND tablename IN ('messages', 'chat_sessions')
  ) THEN
    RAISE EXCEPTION 'Unexpected policies exist before 2B-V-C1';
  END IF;
END
$$;

CREATE OR REPLACE FUNCTION public.send_user_message_core(
  p_session_id uuid,
  p_owner_user_id uuid,
  p_content text
)
RETURNS TABLE (
  message_id uuid,
  session_id uuid,
  role text,
  content text,
  created_at timestamp without time zone,
  session_message_count integer,
  session_last_message_at timestamp without time zone
)
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
DECLARE
  v_content text;
  v_created_at timestamp without time zone := now();
  v_message_id uuid;
  v_session_status text;
  v_session_message_count integer;
  v_session_last_message_at timestamp without time zone;
BEGIN
  IF p_session_id IS NULL THEN
    RAISE EXCEPTION 'invalid_request' USING ERRCODE = 'P0001';
  END IF;

  IF p_owner_user_id IS NULL THEN
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

  SELECT cs.status
  INTO v_session_status
  FROM public.chat_sessions AS cs
  WHERE cs.id = p_session_id
    AND cs.user_id = p_owner_user_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'session_not_found' USING ERRCODE = 'P0001';
  END IF;

  IF v_session_status = 'archived' THEN
    RAISE EXCEPTION 'session_archived' USING ERRCODE = 'P0001';
  END IF;

  IF v_session_status <> 'active' THEN
    RAISE EXCEPTION 'session_not_active' USING ERRCODE = 'P0001';
  END IF;

  INSERT INTO public.messages (
    session_id, role, content, attachments, created_at
  ) VALUES (
    p_session_id, 'user', v_content, NULL, v_created_at
  )
  RETURNING id INTO v_message_id;

  UPDATE public.chat_sessions AS cs
  SET
    message_count = cs.message_count + 1,
    last_message_at = v_created_at
  WHERE cs.id = p_session_id
    AND cs.user_id = p_owner_user_id
    AND cs.status = 'active'
  RETURNING cs.message_count, cs.last_message_at
  INTO v_session_message_count, v_session_last_message_at;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'write_unconfirmed' USING ERRCODE = 'P0001';
  END IF;

  RETURN QUERY
  SELECT
    v_message_id,
    p_session_id,
    'user'::text,
    v_content,
    v_created_at,
    v_session_message_count,
    v_session_last_message_at;
END;
$$;

REVOKE ALL ON FUNCTION public.send_user_message_core(uuid, uuid, text)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.send_user_message_core(uuid, uuid, text)
  TO service_role;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_catalog.pg_proc p
    JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
    WHERE n.nspname = 'public'
      AND p.proname = 'send_user_message_core'
      AND p.prosecdef
  ) THEN
    RAISE EXCEPTION '2B-V-C1 must not use SECURITY DEFINER';
  END IF;

  IF has_function_privilege(
    'anon',
    'public.send_user_message_core(uuid, uuid, text)',
    'EXECUTE'
  ) OR has_function_privilege(
    'authenticated',
    'public.send_user_message_core(uuid, uuid, text)',
    'EXECUTE'
  ) THEN
    RAISE EXCEPTION '2B-V-C1 must deny client EXECUTE grants';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_catalog.pg_policies
    WHERE schemaname = 'public'
      AND tablename IN ('messages', 'chat_sessions')
  ) THEN
    RAISE EXCEPTION '2B-V-C1 must not create permissive policies';
  END IF;
END
$$;

COMMIT;

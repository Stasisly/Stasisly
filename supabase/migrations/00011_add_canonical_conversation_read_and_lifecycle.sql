-- FOUNDATION-013C: canonical owner-scoped Conversation reads and lifecycle.
BEGIN;

ALTER TABLE public.chat_sessions
  ADD COLUMN archived_at TIMESTAMP WITHOUT TIME ZONE;

UPDATE public.chat_sessions
SET archived_at = last_message_at
WHERE status = 'archived';

ALTER TABLE public.chat_sessions
  ADD CONSTRAINT chat_sessions_lifecycle_consistent
    CHECK (
      (status = 'active' AND archived_at IS NULL)
      OR (status = 'archived' AND archived_at IS NOT NULL)
    );

DROP INDEX IF EXISTS public.idx_chat_sessions_owner_listing;
CREATE INDEX idx_chat_sessions_owner_status_listing
ON public.chat_sessions(user_id, status, last_message_at DESC, id DESC);

CREATE OR REPLACE FUNCTION public.read_own_conversation_core(
  p_owner_user_id UUID,
  p_conversation_id UUID
)
RETURNS TABLE (
  conversation_id UUID,
  status TEXT,
  created_at TIMESTAMP WITHOUT TIME ZONE,
  updated_at TIMESTAMP WITHOUT TIME ZONE,
  archived_at TIMESTAMP WITHOUT TIME ZONE,
  selectable_specialist_id UUID,
  specialist_display_name TEXT,
  product_area TEXT
)
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
DECLARE
  v_session public.chat_sessions%ROWTYPE;
  v_catalog public.specialist_catalog%ROWTYPE;
BEGIN
  IF p_owner_user_id IS NULL OR p_conversation_id IS NULL THEN
    RAISE EXCEPTION 'invalid_request' USING ERRCODE = 'P0001';
  END IF;
  SELECT * INTO v_session FROM public.chat_sessions
  WHERE id = p_conversation_id AND user_id = p_owner_user_id;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'conversation_not_found' USING ERRCODE = 'P0001';
  END IF;
  IF NOT (
    (v_session.status = 'active' AND v_session.archived_at IS NULL)
    OR (v_session.status = 'archived' AND v_session.archived_at IS NOT NULL)
  ) THEN
    RAISE EXCEPTION 'invalid_lifecycle' USING ERRCODE = 'P0001';
  END IF;
  SELECT * INTO v_catalog FROM public.specialist_catalog
  WHERE specialist_id = v_session.specialist_id AND is_published
  ORDER BY id LIMIT 1;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'backend_misconfigured' USING ERRCODE = 'P0001';
  END IF;
  RETURN QUERY SELECT v_session.id, v_session.status, v_session.started_at,
    v_session.last_message_at, v_session.archived_at, v_catalog.id,
    v_catalog.display_name, v_catalog.product_area;
END;
$$;

CREATE OR REPLACE FUNCTION public.list_own_conversations_core(
  p_owner_user_id UUID,
  p_status TEXT DEFAULT 'active',
  p_limit INTEGER DEFAULT 20,
  p_cursor_updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
  p_cursor_id UUID DEFAULT NULL
)
RETURNS TABLE (
  conversation_id UUID,
  status TEXT,
  created_at TIMESTAMP WITHOUT TIME ZONE,
  updated_at TIMESTAMP WITHOUT TIME ZONE,
  archived_at TIMESTAMP WITHOUT TIME ZONE,
  message_count INTEGER,
  selectable_specialist_id UUID,
  specialist_display_name TEXT,
  product_area TEXT
)
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
BEGIN
  IF p_owner_user_id IS NULL OR p_status NOT IN ('active', 'archived', 'all')
    OR p_limit NOT BETWEEN 1 AND 51
    OR ((p_cursor_updated_at IS NULL) <> (p_cursor_id IS NULL))
  THEN
    RAISE EXCEPTION 'invalid_request' USING ERRCODE = 'P0001';
  END IF;
  IF EXISTS (
    SELECT 1 FROM (
      SELECT s.specialist_id FROM public.chat_sessions s
      WHERE s.user_id = p_owner_user_id
        AND (p_status = 'all' OR s.status = p_status)
        AND (p_cursor_updated_at IS NULL OR
          (s.last_message_at, s.id) < (p_cursor_updated_at, p_cursor_id))
      ORDER BY s.last_message_at DESC, s.id DESC LIMIT p_limit
    ) page
    WHERE NOT EXISTS (
      SELECT 1 FROM public.specialist_catalog c
      WHERE c.specialist_id = page.specialist_id AND c.is_published
    )
  ) THEN
    RAISE EXCEPTION 'backend_misconfigured' USING ERRCODE = 'P0001';
  END IF;
  RETURN QUERY
  SELECT s.id, s.status, s.started_at, s.last_message_at, s.archived_at,
    s.message_count, c.id, c.display_name, c.product_area
  FROM public.chat_sessions s
  JOIN LATERAL (
    SELECT sc.id, sc.display_name, sc.product_area
    FROM public.specialist_catalog sc
    WHERE sc.specialist_id = s.specialist_id AND sc.is_published
    ORDER BY sc.id LIMIT 1
  ) c ON TRUE
  WHERE s.user_id = p_owner_user_id
    AND (p_status = 'all' OR s.status = p_status)
    AND ((s.status = 'active' AND s.archived_at IS NULL)
      OR (s.status = 'archived' AND s.archived_at IS NOT NULL))
    AND (p_cursor_updated_at IS NULL OR
      (s.last_message_at, s.id) < (p_cursor_updated_at, p_cursor_id))
  ORDER BY s.last_message_at DESC, s.id DESC LIMIT p_limit;
END;
$$;

CREATE OR REPLACE FUNCTION public.archive_own_conversation_core(
  p_owner_user_id UUID,
  p_conversation_id UUID
)
RETURNS TABLE (conversation_id UUID, status TEXT)
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
DECLARE v_session public.chat_sessions%ROWTYPE;
BEGIN
  SELECT * INTO v_session FROM public.chat_sessions
  WHERE id = p_conversation_id AND user_id = p_owner_user_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'conversation_not_found' USING ERRCODE = 'P0001';
  END IF;
  IF v_session.status = 'active' AND v_session.archived_at IS NULL THEN
    UPDATE public.chat_sessions SET status = 'archived', archived_at = now()
    WHERE id = v_session.id RETURNING * INTO v_session;
  ELSIF NOT (v_session.status = 'archived' AND v_session.archived_at IS NOT NULL) THEN
    RAISE EXCEPTION 'invalid_lifecycle' USING ERRCODE = 'P0001';
  END IF;
  RETURN QUERY SELECT v_session.id, v_session.status;
END;
$$;

CREATE OR REPLACE FUNCTION public.restore_own_conversation_core(
  p_owner_user_id UUID,
  p_conversation_id UUID
)
RETURNS TABLE (conversation_id UUID, status TEXT)
LANGUAGE plpgsql
SET search_path = public, pg_temp
AS $$
DECLARE v_session public.chat_sessions%ROWTYPE;
BEGIN
  SELECT * INTO v_session FROM public.chat_sessions
  WHERE id = p_conversation_id AND user_id = p_owner_user_id FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'conversation_not_found' USING ERRCODE = 'P0001';
  END IF;
  IF v_session.status = 'archived' AND v_session.archived_at IS NOT NULL THEN
    UPDATE public.chat_sessions SET status = 'active', archived_at = NULL
    WHERE id = v_session.id RETURNING * INTO v_session;
  ELSIF NOT (v_session.status = 'active' AND v_session.archived_at IS NULL) THEN
    RAISE EXCEPTION 'invalid_lifecycle' USING ERRCODE = 'P0001';
  END IF;
  RETURN QUERY SELECT v_session.id, v_session.status;
END;
$$;

REVOKE ALL ON FUNCTION public.read_own_conversation_core(UUID, UUID)
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.list_own_conversations_core(UUID, TEXT, INTEGER, TIMESTAMP WITHOUT TIME ZONE, UUID)
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.archive_own_conversation_core(UUID, UUID)
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.restore_own_conversation_core(UUID, UUID)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.read_own_conversation_core(UUID, UUID) TO service_role;
GRANT EXECUTE ON FUNCTION public.list_own_conversations_core(UUID, TEXT, INTEGER, TIMESTAMP WITHOUT TIME ZONE, UUID) TO service_role;
GRANT EXECUTE ON FUNCTION public.archive_own_conversation_core(UUID, UUID) TO service_role;
GRANT EXECUTE ON FUNCTION public.restore_own_conversation_core(UUID, UUID) TO service_role;

COMMIT;

-- 2B-V-A: harden messages locally without exposing client access.
BEGIN;

DO $$
DECLARE
  incompatible_rows BIGINT;
BEGIN
  IF to_regclass('public.messages') IS NULL THEN
    RAISE EXCEPTION '2B-V-A requires public.messages';
  END IF;

  IF (
    SELECT array_agg(a.attname ORDER BY a.attnum)::text
    FROM pg_catalog.pg_attribute a
    WHERE a.attrelid = 'public.messages'::regclass
      AND a.attnum > 0
      AND NOT a.attisdropped
  ) <> '{id,session_id,role,content,attachments,created_at}'
  THEN
    RAISE EXCEPTION 'Unexpected public.messages columns before 2B-V-A';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_catalog.pg_policies
    WHERE schemaname = 'public' AND tablename = 'messages'
  ) THEN
    RAISE EXCEPTION 'Unexpected policies exist on messages before 2B-V-A';
  END IF;

  SELECT count(*)
  INTO incompatible_rows
  FROM public.messages
  WHERE session_id IS NULL
    OR created_at IS NULL
    OR content IS NULL
    OR btrim(content) = ''
    OR char_length(content) > 4000
    OR role IS NULL
    OR role NOT IN ('user', 'assistant', 'system', 'tool')
    OR attachments IS NOT NULL;

  IF incompatible_rows > 0 THEN
    RAISE EXCEPTION
      '2B-V-A preflight rejected % incompatible messages rows',
      incompatible_rows;
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_catalog.pg_constraint
    WHERE conrelid = 'public.messages'::regclass
      AND contype = 'f'
      AND confrelid = 'public.chat_sessions'::regclass
  ) THEN
    RAISE EXCEPTION 'Unexpected messages foreign key before 2B-V-A';
  END IF;
END
$$;

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.messages NO FORCE ROW LEVEL SECURITY;

REVOKE ALL PRIVILEGES ON TABLE public.messages
  FROM PUBLIC, anon, authenticated;

ALTER TABLE public.messages
  DROP CONSTRAINT IF EXISTS messages_role_check,
  DROP CONSTRAINT IF EXISTS messages_role_valid,
  DROP CONSTRAINT IF EXISTS messages_content_not_blank,
  DROP CONSTRAINT IF EXISTS messages_content_max_length,
  DROP CONSTRAINT IF EXISTS messages_attachments_null_mvp,
  ALTER COLUMN session_id SET NOT NULL,
  ALTER COLUMN created_at SET DEFAULT now(),
  ALTER COLUMN created_at SET NOT NULL,
  ADD CONSTRAINT messages_role_valid
    CHECK (role IN ('user', 'assistant', 'system', 'tool')),
  ADD CONSTRAINT messages_content_not_blank
    CHECK (btrim(content) <> ''),
  ADD CONSTRAINT messages_content_max_length
    CHECK (char_length(content) <= 4000),
  ADD CONSTRAINT messages_attachments_null_mvp
    CHECK (attachments IS NULL);

DROP INDEX IF EXISTS public.idx_messages_session;

CREATE INDEX idx_messages_session_created_id
ON public.messages(session_id, created_at ASC, id ASC);

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_catalog.pg_policies
    WHERE schemaname = 'public' AND tablename = 'messages'
  ) THEN
    RAISE EXCEPTION '2B-V-A requires zero messages policies';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_catalog.pg_class c
    WHERE c.oid = 'public.messages'::regclass
      AND (NOT c.relrowsecurity OR c.relforcerowsecurity)
  ) THEN
    RAISE EXCEPTION '2B-V-A requires RLS enabled without FORCE RLS';
  END IF;

  IF has_table_privilege('anon', 'public.messages', 'SELECT')
    OR has_table_privilege('anon', 'public.messages', 'INSERT')
    OR has_table_privilege('anon', 'public.messages', 'UPDATE')
    OR has_table_privilege('anon', 'public.messages', 'DELETE')
    OR has_table_privilege('authenticated', 'public.messages', 'SELECT')
    OR has_table_privilege('authenticated', 'public.messages', 'INSERT')
    OR has_table_privilege('authenticated', 'public.messages', 'UPDATE')
    OR has_table_privilege('authenticated', 'public.messages', 'DELETE')
  THEN
    RAISE EXCEPTION '2B-V-A requires zero client table privileges';
  END IF;
END
$$;

COMMIT;

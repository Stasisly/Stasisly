-- 2B-IV-A: harden chat_sessions locally without exposing client access.
BEGIN;

DO $$
DECLARE
  incompatible_rows BIGINT;
BEGIN
  IF to_regclass('public.chat_sessions') IS NULL THEN
    RAISE EXCEPTION '2B-IV-A requires public.chat_sessions';
  END IF;

  IF (
    SELECT array_agg(a.attname ORDER BY a.attnum)::text
    FROM pg_catalog.pg_attribute a
    WHERE a.attrelid = 'public.chat_sessions'::regclass
      AND a.attnum > 0
      AND NOT a.attisdropped
  ) <> '{id,user_id,specialist_id,started_at,last_message_at,status,message_count}'
  THEN
    RAISE EXCEPTION 'Unexpected public.chat_sessions columns before 2B-IV-A';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_catalog.pg_policies
    WHERE schemaname = 'public' AND tablename = 'chat_sessions'
  ) THEN
    RAISE EXCEPTION 'Unexpected policies exist on chat_sessions before 2B-IV-A';
  END IF;

  SELECT count(*)
  INTO incompatible_rows
  FROM public.chat_sessions
  WHERE user_id IS NULL
    OR specialist_id IS NULL
    OR started_at IS NULL
    OR last_message_at IS NULL
    OR status IS NULL
    OR message_count IS NULL
    OR status NOT IN ('active', 'archived')
    OR message_count < 0
    OR last_message_at < started_at;

  IF incompatible_rows > 0 THEN
    RAISE EXCEPTION
      '2B-IV-A preflight rejected % incompatible chat_sessions rows',
      incompatible_rows;
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_catalog.pg_constraint
    WHERE conrelid = 'public.chat_sessions'::regclass
      AND contype = 'f'
      AND confrelid = 'public.users'::regclass
  ) OR NOT EXISTS (
    SELECT 1
    FROM pg_catalog.pg_constraint
    WHERE conrelid = 'public.chat_sessions'::regclass
      AND contype = 'f'
      AND confrelid = 'public.specialists'::regclass
  ) THEN
    RAISE EXCEPTION 'Unexpected chat_sessions foreign keys before 2B-IV-A';
  END IF;
END
$$;

ALTER TABLE public.chat_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_sessions NO FORCE ROW LEVEL SECURITY;

REVOKE ALL PRIVILEGES ON TABLE public.chat_sessions
  FROM PUBLIC, anon, authenticated;

ALTER TABLE public.chat_sessions
  DROP CONSTRAINT IF EXISTS chat_sessions_status_check,
  ALTER COLUMN user_id SET NOT NULL,
  ALTER COLUMN specialist_id SET NOT NULL,
  ALTER COLUMN started_at SET DEFAULT now(),
  ALTER COLUMN started_at SET NOT NULL,
  ALTER COLUMN last_message_at SET DEFAULT now(),
  ALTER COLUMN last_message_at SET NOT NULL,
  ALTER COLUMN status SET DEFAULT 'active',
  ALTER COLUMN status SET NOT NULL,
  ALTER COLUMN message_count SET DEFAULT 0,
  ALTER COLUMN message_count SET NOT NULL,
  ADD CONSTRAINT chat_sessions_status_valid
    CHECK (status IN ('active', 'archived')),
  ADD CONSTRAINT chat_sessions_message_count_nonnegative
    CHECK (message_count >= 0),
  ADD CONSTRAINT chat_sessions_chronology_valid
    CHECK (last_message_at >= started_at);

DROP INDEX IF EXISTS public.idx_chat_sessions_user;

CREATE INDEX idx_chat_sessions_owner_listing
ON public.chat_sessions(user_id, last_message_at DESC, id DESC);

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_catalog.pg_policies
    WHERE schemaname = 'public' AND tablename = 'chat_sessions'
  ) THEN
    RAISE EXCEPTION '2B-IV-A requires zero chat_sessions policies';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_catalog.pg_class c
    WHERE c.oid = 'public.chat_sessions'::regclass
      AND (NOT c.relrowsecurity OR c.relforcerowsecurity)
  ) THEN
    RAISE EXCEPTION '2B-IV-A requires RLS enabled without FORCE RLS';
  END IF;

  IF has_table_privilege('anon', 'public.chat_sessions', 'SELECT')
    OR has_table_privilege('anon', 'public.chat_sessions', 'INSERT')
    OR has_table_privilege('anon', 'public.chat_sessions', 'UPDATE')
    OR has_table_privilege('anon', 'public.chat_sessions', 'DELETE')
    OR has_table_privilege('authenticated', 'public.chat_sessions', 'SELECT')
    OR has_table_privilege('authenticated', 'public.chat_sessions', 'INSERT')
    OR has_table_privilege('authenticated', 'public.chat_sessions', 'UPDATE')
    OR has_table_privilege('authenticated', 'public.chat_sessions', 'DELETE')
  THEN
    RAISE EXCEPTION '2B-IV-A requires zero client table privileges';
  END IF;
END
$$;

COMMIT;

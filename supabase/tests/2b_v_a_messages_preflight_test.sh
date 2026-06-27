#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
db_container="${SUPABASE_DB_CONTAINER:-supabase_db_Stasisly}"
migration="$repo_root/supabase/migrations/00006_harden_messages_deny_all.sql"
rollback="$repo_root/supabase/tests/2b_v_a_messages_rollback.psql"

db_psql() {
  docker exec -i "$db_container" psql -v ON_ERROR_STOP=1 -U postgres -d postgres "$@"
}

echo "2B-V-A preflight: restore historical-compatible shape while preserving deny-all"
db_psql < "$rollback" >/tmp/2b_v_a_preflight_rollback.out

echo "2B-V-A preflight: insert incompatible local-only fixture"
db_psql <<'SQL'
BEGIN;

INSERT INTO auth.users (
  id, instance_id, aud, role, email, encrypted_password, created_at, updated_at
) VALUES (
  '51000000-0000-4000-8000-000000000001',
  '00000000-0000-0000-0000-000000000000',
  'authenticated',
  'authenticated',
  '2b-v-a-preflight@example.invalid',
  '',
  now(),
  now()
);

INSERT INTO public.users (id, display_name)
VALUES ('51000000-0000-4000-8000-000000000001', '2B-V-A preflight fixture');

INSERT INTO public.specialists (id, name, category, prompt_template)
VALUES (
  '52000000-0000-4000-8000-000000000001',
  '2B-V-A preflight fixture',
  'salud',
  '{"system":"test_only_preflight"}'
);

INSERT INTO public.chat_sessions (
  id, user_id, specialist_id, started_at, last_message_at, status
) VALUES (
  '53000000-0000-4000-8000-000000000001',
  '51000000-0000-4000-8000-000000000001',
  '52000000-0000-4000-8000-000000000001',
  '2026-06-15 12:00:00',
  '2026-06-15 12:00:00',
  'active'
);

INSERT INTO public.messages (
  id, session_id, role, content, attachments, created_at
) VALUES (
  '54000000-0000-4000-8000-000000000001',
  '53000000-0000-4000-8000-000000000001',
  'chief_intervention',
  'Legacy incompatible message',
  '{"type":"legacy"}',
  NULL
);

COMMIT;
SQL

echo "2B-V-A preflight: migration must abort before transforming schema"
set +e
output="$(db_psql < "$migration" 2>&1)"
status=$?
set -e

printf '%s\n' "$output"

if [ "$status" -eq 0 ]; then
  echo "Expected migration to fail with incompatible messages fixture" >&2
  exit 1
fi

if ! printf '%s\n' "$output" | grep -q "2B-V-A preflight rejected"; then
  echo "Expected explicit 2B-V-A preflight rejection" >&2
  exit 1
fi

echo "2B-V-A preflight: verify migration did not partially transform messages"
db_psql <<'SQL'
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_catalog.pg_constraint
    WHERE conrelid = 'public.messages'::regclass
      AND conname = 'messages_role_check'
      AND pg_get_constraintdef(oid) LIKE '%chief_intervention%'
  ) THEN
    RAISE EXCEPTION 'historical role constraint was unexpectedly transformed';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_catalog.pg_constraint
    WHERE conrelid = 'public.messages'::regclass
      AND conname = 'messages_role_valid'
  ) THEN
    RAISE EXCEPTION 'new role constraint should not exist after aborted preflight';
  END IF;

  IF to_regclass('public.idx_messages_session_created_id') IS NOT NULL THEN
    RAISE EXCEPTION 'new index should not exist after aborted preflight';
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM public.messages
    WHERE id = '54000000-0000-4000-8000-000000000001'
      AND role = 'chief_intervention'
  ) THEN
    RAISE EXCEPTION 'incompatible fixture unexpectedly disappeared';
  END IF;
END
$$;
SQL

echo "2B-V-A preflight PASS"

-- FOUNDATION-005-R1: close inherited client access to legacy public tables.
-- This migration adds no positive authorization and changes no schema data.
BEGIN;

DO $$
DECLARE
  target_tables CONSTANT text[] := ARRAY[
    'memberships',
    'user_memberships',
    'branch_chiefs',
    'subcategory_chiefs',
    'user_health_data',
    'calendar_events',
    'reminders',
    'orchestator_summaries',
    'chief_write_permissions',
    'specialist_temporary_disables'
  ];
  existing_count integer;
  policy_count integer;
BEGIN
  SELECT count(*)
  INTO existing_count
  FROM pg_catalog.pg_class c
  JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
  WHERE n.nspname = 'public'
    AND c.relkind = 'r'
    AND c.relname = ANY (target_tables);

  IF existing_count <> cardinality(target_tables) THEN
    RAISE EXCEPTION
      'FOUNDATION-005-R1 expected % legacy tables, found %',
      cardinality(target_tables),
      existing_count;
  END IF;

  SELECT count(*)
  INTO policy_count
  FROM pg_catalog.pg_policies
  WHERE schemaname = 'public'
    AND tablename = ANY (target_tables);

  IF policy_count <> 0 THEN
    RAISE EXCEPTION
      'FOUNDATION-005-R1 refuses to replace % unexpected policies',
      policy_count;
  END IF;
END
$$;

ALTER TABLE public.memberships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_memberships ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.branch_chiefs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subcategory_chiefs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_health_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.calendar_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reminders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orchestator_summaries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chief_write_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.specialist_temporary_disables ENABLE ROW LEVEL SECURITY;

REVOKE ALL PRIVILEGES ON TABLE public.memberships
  FROM PUBLIC, anon, authenticated;
REVOKE ALL PRIVILEGES ON TABLE public.user_memberships
  FROM PUBLIC, anon, authenticated;
REVOKE ALL PRIVILEGES ON TABLE public.branch_chiefs
  FROM PUBLIC, anon, authenticated;
REVOKE ALL PRIVILEGES ON TABLE public.subcategory_chiefs
  FROM PUBLIC, anon, authenticated;
REVOKE ALL PRIVILEGES ON TABLE public.user_health_data
  FROM PUBLIC, anon, authenticated;
REVOKE ALL PRIVILEGES ON TABLE public.calendar_events
  FROM PUBLIC, anon, authenticated;
REVOKE ALL PRIVILEGES ON TABLE public.reminders
  FROM PUBLIC, anon, authenticated;
REVOKE ALL PRIVILEGES ON TABLE public.orchestator_summaries
  FROM PUBLIC, anon, authenticated;
REVOKE ALL PRIVILEGES ON TABLE public.chief_write_permissions
  FROM PUBLIC, anon, authenticated;
REVOKE ALL PRIVILEGES ON TABLE public.specialist_temporary_disables
  FROM PUBLIC, anon, authenticated;

DO $$
DECLARE
  target_table text;
BEGIN
  FOREACH target_table IN ARRAY ARRAY[
    'memberships',
    'user_memberships',
    'branch_chiefs',
    'subcategory_chiefs',
    'user_health_data',
    'calendar_events',
    'reminders',
    'orchestator_summaries',
    'chief_write_permissions',
    'specialist_temporary_disables'
  ]
  LOOP
    IF NOT (
      SELECT c.relrowsecurity AND NOT c.relforcerowsecurity
      FROM pg_catalog.pg_class c
      JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
      WHERE n.nspname = 'public' AND c.relname = target_table
    ) THEN
      RAISE EXCEPTION
        'FOUNDATION-005-R1 requires RLS without FORCE on public.%',
        target_table;
    END IF;

    IF EXISTS (
      SELECT 1
      FROM pg_catalog.pg_policies
      WHERE schemaname = 'public' AND tablename = target_table
    ) THEN
      RAISE EXCEPTION
        'FOUNDATION-005-R1 requires zero policies on public.%',
        target_table;
    END IF;

    IF has_table_privilege(
      'anon', format('public.%I', target_table),
      'SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER'
    ) OR has_table_privilege(
      'authenticated', format('public.%I', target_table),
      'SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER'
    ) OR has_any_column_privilege(
      'anon', format('public.%I', target_table), 'SELECT,INSERT,UPDATE,REFERENCES'
    ) OR has_any_column_privilege(
      'authenticated', format('public.%I', target_table),
      'SELECT,INSERT,UPDATE,REFERENCES'
    ) THEN
      RAISE EXCEPTION
        'FOUNDATION-005-R1 requires zero client privileges on public.%',
        target_table;
    END IF;
  END LOOP;
END
$$;

COMMIT;

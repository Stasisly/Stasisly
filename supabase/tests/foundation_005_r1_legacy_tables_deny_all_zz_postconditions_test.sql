begin;

create extension if not exists pgtap with schema extensions;

-- 40 legacy postconditions plus 10 modern-table regression checks.
select plan(50);

create temporary table foundation_005_r1_targets (
  table_name text primary key
) on commit drop;

insert into foundation_005_r1_targets (table_name) values
  ('memberships'),
  ('user_memberships'),
  ('branch_chiefs'),
  ('subcategory_chiefs'),
  ('user_health_data'),
  ('calendar_events'),
  ('reminders'),
  ('orchestator_summaries'),
  ('chief_write_permissions'),
  ('specialist_temporary_disables');

select ok(
  (
    select c.relrowsecurity and not c.relforcerowsecurity
    from pg_catalog.pg_class c
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = target.table_name
  ),
  format('public.%I remains RLS deny-all after the suite', table_name)
)
from foundation_005_r1_targets target order by table_name;

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_policies
    where schemaname = 'public' and tablename = target.table_name
  ),
  0::bigint,
  format('public.%I still has zero policies', table_name)
)
from foundation_005_r1_targets target order by table_name;

select ok(
  not has_table_privilege(
    'anon', format('public.%I', table_name),
    'SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER'
  ) and not has_table_privilege(
    'authenticated', format('public.%I', table_name),
    'SELECT,INSERT,UPDATE,DELETE,TRUNCATE,REFERENCES,TRIGGER'
  ) and not has_any_column_privilege(
    'anon', format('public.%I', table_name),
    'SELECT,INSERT,UPDATE,REFERENCES'
  ) and not has_any_column_privilege(
    'authenticated', format('public.%I', table_name),
    'SELECT,INSERT,UPDATE,REFERENCES'
  ),
  format('public.%I still has zero client privileges', table_name)
)
from foundation_005_r1_targets order by table_name;

select ok(
  has_table_privilege(
    'service_role', format('public.%I', table_name),
    'SELECT,INSERT,UPDATE,DELETE'
  ),
  format('service_role retains backend CRUD on public.%I', table_name)
)
from foundation_005_r1_targets order by table_name;

create temporary table foundation_005_r1_modern_tables (
  table_name text primary key,
  expected_policies bigint not null
) on commit drop;

insert into foundation_005_r1_modern_tables (
  table_name, expected_policies
) values
  ('users', 2),
  ('specialists', 0),
  ('specialist_catalog', 0),
  ('chat_sessions', 0),
  ('messages', 0);

select ok(
  (
    select c.relrowsecurity and not c.relforcerowsecurity
    from pg_catalog.pg_class c
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = target.table_name
  ),
  format('modern table public.%I keeps expected RLS state', table_name)
)
from foundation_005_r1_modern_tables target order by table_name;

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_policies
    where schemaname = 'public' and tablename = target.table_name
  ),
  expected_policies,
  format('modern table public.%I keeps expected policies', table_name)
)
from foundation_005_r1_modern_tables target order by table_name;

select * from finish();

rollback;

begin;

create extension if not exists pgtap with schema extensions;

-- 10 fixed tables x 12 mandatory controls = 120 assertions.
select plan(120);

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

select has_table(
  'public', table_name,
  format('public.%I exists', table_name)
)
from foundation_005_r1_targets
order by table_name;

select ok(
  coalesce((
    select c.relrowsecurity and not c.relforcerowsecurity
    from pg_catalog.pg_class c
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = target.table_name
  ), false),
  format('public.%I has RLS enabled without FORCE', table_name)
)
from foundation_005_r1_targets target
order by table_name;

select ok(
  not has_table_privilege('anon', format('public.%I', table_name), 'SELECT'),
  format('anon cannot SELECT public.%I', table_name)
)
from foundation_005_r1_targets order by table_name;

select ok(
  not has_table_privilege('anon', format('public.%I', table_name), 'INSERT'),
  format('anon cannot INSERT public.%I', table_name)
)
from foundation_005_r1_targets order by table_name;

select ok(
  not has_table_privilege('anon', format('public.%I', table_name), 'UPDATE'),
  format('anon cannot UPDATE public.%I', table_name)
)
from foundation_005_r1_targets order by table_name;

select ok(
  not has_table_privilege('anon', format('public.%I', table_name), 'DELETE'),
  format('anon cannot DELETE public.%I', table_name)
)
from foundation_005_r1_targets order by table_name;

select ok(
  not has_table_privilege(
    'authenticated', format('public.%I', table_name), 'SELECT'
  ),
  format('authenticated cannot SELECT public.%I', table_name)
)
from foundation_005_r1_targets order by table_name;

select ok(
  not has_table_privilege(
    'authenticated', format('public.%I', table_name), 'INSERT'
  ),
  format('authenticated cannot INSERT public.%I', table_name)
)
from foundation_005_r1_targets order by table_name;

select ok(
  not has_table_privilege(
    'authenticated', format('public.%I', table_name), 'UPDATE'
  ),
  format('authenticated cannot UPDATE public.%I', table_name)
)
from foundation_005_r1_targets order by table_name;

select ok(
  not has_table_privilege(
    'authenticated', format('public.%I', table_name), 'DELETE'
  ),
  format('authenticated cannot DELETE public.%I', table_name)
)
from foundation_005_r1_targets order by table_name;

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_policies
    where schemaname = 'public' and tablename = target.table_name
  ),
  0::bigint,
  format('public.%I has zero policies', table_name)
)
from foundation_005_r1_targets target
order by table_name;

select ok(
  not exists (
    select 1
    from information_schema.role_table_grants grants
    where grants.table_schema = 'public'
      and grants.table_name = target.table_name
      and grants.grantee in ('PUBLIC', 'anon', 'authenticated')
  ) and not exists (
    select 1
    from information_schema.column_privileges grants
    where grants.table_schema = 'public'
      and grants.table_name = target.table_name
      and grants.grantee in ('PUBLIC', 'anon', 'authenticated')
  ),
  format('public.%I has no equivalent client grants', table_name)
)
from foundation_005_r1_targets target
order by table_name;

select * from finish();

rollback;

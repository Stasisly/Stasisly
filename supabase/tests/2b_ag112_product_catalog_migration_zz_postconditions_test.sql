begin;

create extension if not exists pgtap with schema extensions;

select plan(8);

select is(
  (
    select count(*)::bigint
    from public.specialists
    where id::text like 'a1120000-0000-4000-8000-%'
      or name like 'test_only_ag112%'
  ),
  0::bigint,
  'AG112 internal specialist fixtures were rolled back'
);

select is(
  (
    select count(*)::bigint
    from public.specialist_catalog c
    left join public.specialists s on s.id = c.specialist_id
    where c.id::text like 'a1130000-0000-4000-8000-%'
      or c.slug like 'ag112-%'
      or s.id::text like 'a1120000-0000-4000-8000-%'
      or s.name like 'test_only_ag112%'
  ),
  0::bigint,
  'AG112 catalog fixtures were rolled back'
);

select ok(
  (
    select c.relrowsecurity and not c.relforcerowsecurity
    from pg_catalog.pg_class c
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'specialist_catalog'
  ),
  'specialist_catalog still has RLS enabled without FORCE after AG112'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_policies
    where schemaname = 'public'
      and tablename = 'specialist_catalog'
  ),
  0::bigint,
  'specialist_catalog still has zero policies after AG112'
);

select ok(
  not has_table_privilege('anon', 'public.specialist_catalog', 'SELECT')
    and not has_table_privilege('authenticated', 'public.specialist_catalog', 'SELECT')
    and not has_table_privilege('anon', 'public.specialist_catalog', 'INSERT')
    and not has_table_privilege('authenticated', 'public.specialist_catalog', 'INSERT')
    and not has_table_privilege('anon', 'public.specialist_catalog', 'UPDATE')
    and not has_table_privilege('authenticated', 'public.specialist_catalog', 'UPDATE')
    and not has_table_privilege('anon', 'public.specialist_catalog', 'DELETE')
    and not has_table_privilege('authenticated', 'public.specialist_catalog', 'DELETE'),
  'client roles still have zero table privileges after AG112'
);

select ok(
  not has_any_column_privilege('anon', 'public.specialist_catalog', 'SELECT')
    and not has_any_column_privilege('authenticated', 'public.specialist_catalog', 'SELECT')
    and not has_any_column_privilege('anon', 'public.specialist_catalog', 'UPDATE')
    and not has_any_column_privilege('authenticated', 'public.specialist_catalog', 'UPDATE'),
  'client roles still have zero column privileges after AG112'
);

select is(
  (
    select count(*)::bigint
    from public.specialist_catalog
    where access_tier = 'premium'
  ),
  0::bigint,
  'no legacy premium catalog rows remain after AG112'
);

select is(
  (
    select count(*)::bigint
    from public.specialist_catalog
  ),
  0::bigint,
  'specialist_catalog is empty after AG112 validation'
);

select * from finish();

rollback;

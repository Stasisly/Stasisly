begin;

create extension if not exists pgtap with schema extensions;

select plan(6);

select ok(
  (
    select c.relrowsecurity
    from pg_catalog.pg_class c
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'users'
  ),
  'RLS is enabled on public.users'
);

select ok(
  not (
    select c.relforcerowsecurity
    from pg_catalog.pg_class c
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'users'
  ),
  'FORCE ROW LEVEL SECURITY is not enabled on public.users'
);

select is(
  (
    select array_agg(c.relname order by c.relname)::text
    from pg_catalog.pg_class c
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relkind in ('r', 'p')
      and c.relname <> 'users'
      and c.relrowsecurity
  ),
  '{branch_chiefs,calendar_events,chat_sessions,chief_write_permissions,conversation_idempotency,memberships,messages,orchestator_summaries,reminders,specialist_catalog,specialist_temporary_disables,specialists,subcategory_chiefs,user_health_data,user_memberships}',
  'only the approved later deny-all tables, including R1, additionally have RLS'
);

select ok(
  coalesce(
    (select not rolbypassrls from pg_catalog.pg_roles where rolname = 'anon'),
    false
  ),
  'anon exists and cannot bypass RLS'
);

select ok(
  coalesce(
    (
      select not rolbypassrls
      from pg_catalog.pg_roles
      where rolname = 'authenticated'
    ),
    false
  ),
  'authenticated exists and cannot bypass RLS'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_policies
    where schemaname = 'public'
      and tablename <> 'users'
  ),
  0::bigint,
  '2B-II did not create policies on other public tables'
);

select * from finish();

rollback;

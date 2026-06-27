begin;

create extension if not exists pgtap with schema extensions;

select plan(38);

select ok(
  (
    select c.relrowsecurity and not c.relforcerowsecurity
    from pg_catalog.pg_class c
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'users'
  ),
  'public.users has RLS enabled without FORCE RLS'
);

select is(
  (
    select array_agg(policyname order by policyname)::text
    from pg_catalog.pg_policies
    where schemaname = 'public' and tablename = 'users'
  ),
  '{users_select_own_minimal,users_update_own_display_name}',
  'public.users has exactly the two expected 2B-II policies'
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
  '{chat_sessions,messages,specialist_catalog,specialists}',
  'only the approved later deny-all tables additionally have RLS'
);

select ok(
  has_column_privilege('authenticated', 'public.users', 'id', 'SELECT')
    and has_column_privilege(
      'authenticated', 'public.users', 'display_name', 'SELECT'
    ),
  'authenticated can SELECT id and display_name'
);

select ok(
  has_column_privilege(
    'authenticated', 'public.users', 'display_name', 'UPDATE'
  ),
  'authenticated can UPDATE display_name'
);

select ok(
  not has_table_privilege('authenticated', 'public.users', 'SELECT')
    and not has_table_privilege('authenticated', 'public.users', 'UPDATE')
    and not has_table_privilege('authenticated', 'public.users', 'INSERT')
    and not has_table_privilege('authenticated', 'public.users', 'DELETE'),
  'authenticated has no broad table privileges'
);

select ok(
  not has_any_column_privilege('anon', 'public.users', 'SELECT')
    and not has_any_column_privilege('anon', 'public.users', 'UPDATE')
    and not has_table_privilege('anon', 'public.users', 'INSERT')
    and not has_table_privilege('anon', 'public.users', 'DELETE'),
  'anon has no client privileges on public.users'
);

select ok(
  not has_column_privilege('authenticated', 'public.users', 'role', 'SELECT')
    and not has_column_privilege(
      'authenticated', 'public.users', 'avatar_url', 'SELECT'
    )
    and not has_column_privilege(
      'authenticated', 'public.users', 'created_at', 'SELECT'
    )
    and not has_column_privilege(
      'authenticated', 'public.users', 'updated_at', 'SELECT'
    ),
  'authenticated cannot SELECT blocked columns'
);

select ok(
  not has_column_privilege('authenticated', 'public.users', 'id', 'UPDATE')
    and not has_column_privilege(
      'authenticated', 'public.users', 'role', 'UPDATE'
    )
    and not has_column_privilege(
      'authenticated', 'public.users', 'avatar_url', 'UPDATE'
    )
    and not has_column_privilege(
      'authenticated', 'public.users', 'created_at', 'UPDATE'
    )
    and not has_column_privilege(
      'authenticated', 'public.users', 'updated_at', 'UPDATE'
    ),
  'authenticated cannot UPDATE blocked columns'
);

insert into auth.users (
  id, instance_id, aud, role, email, encrypted_password, created_at, updated_at
) values
  (
    '11111111-1111-4111-8111-111111111111',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'user-a@example.invalid', '', now(), now()
  ),
  (
    '22222222-2222-4222-8222-222222222222',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'user-b@example.invalid', '', now(), now()
  );

insert into public.users (
  id, display_name, avatar_url, role, created_at, updated_at
) values
  (
    '11111111-1111-4111-8111-111111111111',
    'User A', 'blocked-a', 'user', now(), now()
  ),
  (
    '22222222-2222-4222-8222-222222222222',
    'User B', 'blocked-b', 'user', now(), now()
  );

set local role anon;

select throws_ok(
  $$select id, display_name from public.users$$,
  '42501', null, 'anon cannot SELECT allowed columns'
);
select throws_ok(
  $$update public.users set display_name = 'Anon'$$,
  '42501', null, 'anon cannot UPDATE display_name'
);
select throws_ok(
  $$insert into public.users (id, display_name)
    values ('33333333-3333-4333-8333-333333333333', 'Anon')$$,
  '42501', null, 'anon cannot INSERT'
);
select throws_ok(
  $$delete from public.users$$,
  '42501', null, 'anon cannot DELETE'
);

reset role;
set local role authenticated;
select set_config(
  'request.jwt.claims',
  '{"sub":"11111111-1111-4111-8111-111111111111","role":"authenticated"}',
  true
);

select results_eq(
  $$select id from public.users order by id$$,
  $$values ('11111111-1111-4111-8111-111111111111'::uuid)$$,
  'owner can SELECT only own id'
);
select results_eq(
  $$select display_name from public.users order by id$$,
  $$values ('User A'::text)$$,
  'owner can SELECT own display_name'
);
select is_empty(
  $$select id from public.users
    where id = '22222222-2222-4222-8222-222222222222'$$,
  'user A cannot SELECT user B'
);
select throws_ok($$select role from public.users$$, '42501', null, 'role blocked');
select throws_ok(
  $$select avatar_url from public.users$$, '42501', null, 'avatar_url blocked'
);
select throws_ok(
  $$select created_at from public.users$$, '42501', null, 'created_at blocked'
);
select throws_ok(
  $$select updated_at from public.users$$, '42501', null, 'updated_at blocked'
);
select throws_ok($$select * from public.users$$, '42501', null, 'SELECT * blocked');

select results_eq(
  $$update public.users
    set display_name = 'User A Updated'
    where id = '11111111-1111-4111-8111-111111111111'
    returning display_name$$,
  $$values ('User A Updated'::text)$$,
  'owner can UPDATE own display_name'
);
select is_empty(
  $$update public.users
    set display_name = 'Blocked B'
    where id = '22222222-2222-4222-8222-222222222222'
    returning display_name$$,
  'user A cannot UPDATE user B'
);
select throws_ok(
  $$update public.users set role = 'admin'$$, '42501', null, 'role UPDATE blocked'
);
select throws_ok(
  $$update public.users set avatar_url = 'blocked'$$,
  '42501', null, 'avatar_url UPDATE blocked'
);
select throws_ok(
  $$update public.users set created_at = now()$$,
  '42501', null, 'created_at UPDATE blocked'
);
select throws_ok(
  $$update public.users set updated_at = now()$$,
  '42501', null, 'updated_at UPDATE blocked'
);
select throws_ok(
  $$update public.users
    set id = '22222222-2222-4222-8222-222222222222'
    where id = '11111111-1111-4111-8111-111111111111'$$,
  '42501', null, 'id UPDATE blocked by column privilege'
);
select throws_ok(
  $$insert into public.users (id, display_name)
    values ('33333333-3333-4333-8333-333333333333', 'Blocked')$$,
  '42501', null, 'authenticated owner cannot INSERT'
);
select throws_ok(
  $$delete from public.users
    where id = '11111111-1111-4111-8111-111111111111'$$,
  '42501', null, 'authenticated owner cannot DELETE'
);

reset role;

grant update (id) on table public.users to authenticated;
set local role authenticated;
select set_config(
  'request.jwt.claims',
  '{"sub":"11111111-1111-4111-8111-111111111111","role":"authenticated"}',
  true
);
select throws_ok(
  $$update public.users
    set id = '33333333-3333-4333-8333-333333333333'
    where id = '11111111-1111-4111-8111-111111111111'$$,
  '42501', null, 'WITH CHECK blocks owner id change under accidental grant'
);
reset role;
revoke update (id) on table public.users from authenticated;

select is(
  (
    select display_name
    from public.users
    where id = '11111111-1111-4111-8111-111111111111'
  ),
  'User A Updated',
  'allowed owner display_name update persisted inside test transaction'
);
select is(
  (
    select display_name
    from public.users
    where id = '22222222-2222-4222-8222-222222222222'
  ),
  'User B',
  'user B remained unchanged'
);
select is(
  (
    select role
    from public.users
    where id = '11111111-1111-4111-8111-111111111111'
  ),
  'user',
  'role remained unchanged'
);
select is(
  (
    select avatar_url
    from public.users
    where id = '11111111-1111-4111-8111-111111111111'
  ),
  'blocked-a',
  'avatar_url remained unchanged'
);
select ok(
  not has_column_privilege('authenticated', 'public.users', 'id', 'UPDATE'),
  'temporary id UPDATE grant was revoked'
);
select is(
  (select count(*)::bigint from public.users),
  2::bigint,
  'no client INSERT or DELETE changed fixture count'
);
select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_policies
    where schemaname = 'public' and tablename <> 'users'
  ),
  0::bigint,
  'no policy was added to another public table'
);

select * from finish();

rollback;

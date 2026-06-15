begin;

create extension if not exists pgtap with schema extensions;

select plan(31);

select is(
  (select count(*)::bigint from public.chat_sessions),
  0::bigint,
  'chat_sessions starts empty before transactional fixtures'
);

insert into auth.users (
  id, instance_id, aud, role, email, encrypted_password, created_at, updated_at
) values
  (
    '41000000-0000-4000-8000-000000000001',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'owner_test_only_2b_iv_b@example.invalid', '', now(), now()
  ),
  (
    '41000000-0000-4000-8000-000000000002',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'other_test_only_2b_iv_b@example.invalid', '', now(), now()
  );

insert into public.users (id, display_name) values
  ('41000000-0000-4000-8000-000000000001', 'owner_test_only_2b_iv_b'),
  ('41000000-0000-4000-8000-000000000002', 'other_test_only_2b_iv_b');

insert into public.specialists (
  id, name, category, prompt_template, is_premium, is_active
) values (
  '42000000-0000-4000-8000-000000000001',
  'internal_specialist_test_only_2b_iv_b',
  'salud',
  '{"marker":"test_only_2b_iv_b_placeholder_not_for_production"}',
  false,
  true
);

insert into public.specialist_catalog (
  id, specialist_id, display_name, product_area, short_description,
  is_published, availability_status, access_tier, sort_order
) values (
  '43000000-0000-4000-8000-000000000001',
  '42000000-0000-4000-8000-000000000001',
  'catalog_test_only_2b_iv_b',
  'health',
  'Fixture transaccional test_only_2b_iv_b no apto para producción.',
  false,
  'available',
  'free',
  1
);

insert into public.chat_sessions (
  id, user_id, specialist_id, started_at, last_message_at, status, message_count
) values
  (
    '44000000-0000-4000-8000-000000000001',
    '41000000-0000-4000-8000-000000000001',
    '42000000-0000-4000-8000-000000000001',
    '2026-06-14 10:00:00', '2026-06-14 12:00:00', 'active', 0
  ),
  (
    '44000000-0000-4000-8000-000000000002',
    '41000000-0000-4000-8000-000000000001',
    '42000000-0000-4000-8000-000000000001',
    '2026-06-14 08:00:00', '2026-06-14 09:00:00', 'archived', 2
  ),
  (
    '44000000-0000-4000-8000-000000000003',
    '41000000-0000-4000-8000-000000000002',
    '42000000-0000-4000-8000-000000000001',
    '2026-06-14 09:00:00', '2026-06-14 11:00:00', 'active', 1
  );

select is(
  (select count(*)::bigint from auth.users
    where email like '%test_only_2b_iv_b%'),
  2::bigint,
  'exactly two fictitious Auth users exist inside the transaction'
);
select is(
  (select count(*)::bigint from public.users
    where display_name like '%test_only_2b_iv_b%'),
  2::bigint,
  'exactly two fictitious public profiles exist inside the transaction'
);
select is(
  (select count(*)::bigint from public.specialists
    where name like '%test_only_2b_iv_b%'),
  1::bigint,
  'exactly one internal specialist exists inside the transaction'
);
select is(
  (select count(*)::bigint from public.specialist_catalog
    where display_name like '%test_only_2b_iv_b%'),
  1::bigint,
  'exactly one catalog entry exists inside the transaction'
);
select is(
  (select count(*)::bigint from public.chat_sessions
    where id::text like '44000000-0000-4000-8000-%'),
  3::bigint,
  'exactly three chat session fixtures exist inside the transaction'
);

select ok(
  (
    select id <> specialist_id
    from public.specialist_catalog
    where id = '43000000-0000-4000-8000-000000000001'
  ),
  'public catalog ID is separate from internal specialist ID'
);
select is(
  (
    select count(*)::bigint
    from public.chat_sessions cs
    join public.users u on u.id = cs.user_id
    join public.specialists s on s.id = cs.specialist_id
    where cs.id::text like '44000000-0000-4000-8000-%'
  ),
  3::bigint,
  'all session fixtures satisfy approved foreign keys'
);

select is(
  (select user_id from public.chat_sessions
    where id = '44000000-0000-4000-8000-000000000001'),
  '41000000-0000-4000-8000-000000000001'::uuid,
  'owner active session belongs to owner'
);
select is(
  (select status from public.chat_sessions
    where id = '44000000-0000-4000-8000-000000000001'),
  'active',
  'owner active session is active'
);
select is(
  (select message_count from public.chat_sessions
    where id = '44000000-0000-4000-8000-000000000001'),
  0,
  'owner active session starts with zero messages'
);
select ok(
  (select last_message_at >= started_at from public.chat_sessions
    where id = '44000000-0000-4000-8000-000000000001'),
  'owner active session chronology is valid'
);
select is(
  (select status from public.chat_sessions
    where id = '44000000-0000-4000-8000-000000000002'),
  'archived',
  'owner archived session is archived'
);
select is(
  (select user_id from public.chat_sessions
    where id = '44000000-0000-4000-8000-000000000002'),
  '41000000-0000-4000-8000-000000000001'::uuid,
  'owner archived session belongs to owner'
);
select isnt(
  (select user_id from public.chat_sessions
    where id = '44000000-0000-4000-8000-000000000003'),
  '41000000-0000-4000-8000-000000000001'::uuid,
  'other session does not belong to owner'
);
select is(
  (
    select array_agg(id order by last_message_at desc, id desc)::text
    from public.chat_sessions
    where user_id = '41000000-0000-4000-8000-000000000001'
  ),
  '{44000000-0000-4000-8000-000000000001,44000000-0000-4000-8000-000000000002}',
  'owner sessions follow approved stable ordering'
);

select throws_ok(
  $$insert into public.chat_sessions (user_id, specialist_id)
    values (null, '42000000-0000-4000-8000-000000000001')$$,
  '23502', null, 'null owner is rejected'
);
select throws_ok(
  $$insert into public.chat_sessions (user_id, specialist_id)
    values ('41000000-0000-4000-8000-000000000001', null)$$,
  '23502', null, 'null specialist is rejected'
);
select throws_ok(
  $$update public.chat_sessions set status = 'deleted'
    where id = '44000000-0000-4000-8000-000000000001'$$,
  '23514', null, 'invalid status is rejected'
);
select throws_ok(
  $$update public.chat_sessions set message_count = -1
    where id = '44000000-0000-4000-8000-000000000001'$$,
  '23514', null, 'negative message_count is rejected'
);
select throws_ok(
  $$update public.chat_sessions set last_message_at = started_at - interval '1 second'
    where id = '44000000-0000-4000-8000-000000000001'$$,
  '23514', null, 'invalid chronology is rejected'
);

select ok(
  (
    select c.relrowsecurity and not c.relforcerowsecurity
    from pg_catalog.pg_class c
    where c.oid = 'public.chat_sessions'::regclass
  ),
  'chat_sessions preserves RLS without FORCE'
);
select is(
  (select count(*)::bigint from pg_catalog.pg_policies
    where schemaname = 'public' and tablename = 'chat_sessions'),
  0::bigint,
  'chat_sessions preserves zero policies'
);
select ok(
  not has_table_privilege('anon', 'public.chat_sessions', 'SELECT')
    and not has_table_privilege('anon', 'public.chat_sessions', 'INSERT')
    and not has_table_privilege('anon', 'public.chat_sessions', 'UPDATE')
    and not has_table_privilege('anon', 'public.chat_sessions', 'DELETE'),
  'anon preserves zero CRUD privileges'
);
select ok(
  not has_table_privilege('authenticated', 'public.chat_sessions', 'SELECT')
    and not has_table_privilege('authenticated', 'public.chat_sessions', 'INSERT')
    and not has_table_privilege('authenticated', 'public.chat_sessions', 'UPDATE')
    and not has_table_privilege('authenticated', 'public.chat_sessions', 'DELETE'),
  'authenticated preserves zero CRUD privileges'
);

set local role anon;
select throws_ok(
  $$select * from public.chat_sessions$$,
  '42501', null, 'anon cannot read transactional session fixtures'
);
reset role;
set local role authenticated;
select throws_ok(
  $$select * from public.chat_sessions$$,
  '42501', null, 'authenticated cannot read transactional session fixtures'
);
reset role;

select is(
  (select count(*)::bigint from public.messages),
  0::bigint,
  'messages remains empty'
);
select is(
  (
    select array_agg(a.attname order by a.attnum)::text
    from pg_catalog.pg_attribute a
    where a.attrelid = 'public.messages'::regclass
      and a.attnum > 0 and not a.attisdropped
  ),
  '{id,session_id,role,content,attachments,created_at}',
  'messages structure remains intact'
);
select ok(
  (select not c.relrowsecurity and not c.relforcerowsecurity
    from pg_catalog.pg_class c where c.oid = 'public.messages'::regclass),
  'messages RLS state remains intact'
);

select is(
  (select count(*)::bigint from public.chat_sessions
    where id::text like '44000000-0000-4000-8000-%'),
  3::bigint,
  'denied and invalid attempts did not change valid session fixtures'
);

select * from finish();

rollback;

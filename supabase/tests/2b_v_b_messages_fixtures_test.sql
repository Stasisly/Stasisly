begin;

create extension if not exists pgtap with schema extensions;

select plan(55);

select is(
  (select count(*)::bigint from public.messages),
  0::bigint,
  'messages starts empty before transactional fixtures'
);

insert into auth.users (
  id, instance_id, aud, role, email, encrypted_password, created_at, updated_at
) values
  (
    '61000000-0000-4000-8000-000000000001',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'owner_test_only_2b_v_b@example.invalid', '', now(), now()
  ),
  (
    '61000000-0000-4000-8000-000000000002',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'other_test_only_2b_v_b@example.invalid', '', now(), now()
  );

insert into public.users (id, display_name) values
  ('61000000-0000-4000-8000-000000000001', 'owner_test_only_2b_v_b'),
  ('61000000-0000-4000-8000-000000000002', 'other_test_only_2b_v_b');

insert into public.specialists (
  id, name, category, prompt_template, is_premium, is_active
) values (
  '62000000-0000-4000-8000-000000000001',
  'internal_specialist_test_only_2b_v_b',
  'salud',
  '{"marker":"test_only_2b_v_b_placeholder_not_for_production"}',
  false,
  true
);

insert into public.specialist_catalog (
  id, specialist_id, display_name, product_area, short_description,
  is_published, availability_status, access_tier, sort_order
) values (
  '63000000-0000-4000-8000-000000000001',
  '62000000-0000-4000-8000-000000000001',
  'catalog_test_only_2b_v_b',
  'health',
  'Fixture transaccional test_only_2b_v_b no apto para producción.',
  false,
  'available',
  'free',
  1
);

insert into public.chat_sessions (
  id, user_id, specialist_id, started_at, last_message_at, status, message_count
) values
  (
    '64000000-0000-4000-8000-000000000001',
    '61000000-0000-4000-8000-000000000001',
    '62000000-0000-4000-8000-000000000001',
    '2026-06-16 09:00:00', '2026-06-16 09:00:00', 'active', 0
  ),
  (
    '64000000-0000-4000-8000-000000000002',
    '61000000-0000-4000-8000-000000000001',
    '62000000-0000-4000-8000-000000000001',
    '2026-06-16 08:00:00', '2026-06-16 08:30:00', 'archived', 0
  ),
  (
    '64000000-0000-4000-8000-000000000003',
    '61000000-0000-4000-8000-000000000002',
    '62000000-0000-4000-8000-000000000001',
    '2026-06-16 10:00:00', '2026-06-16 10:00:00', 'active', 0
  );

insert into public.messages (
  id, session_id, role, content, created_at
) values
  (
    '65000000-0000-4000-8000-000000000001',
    '64000000-0000-4000-8000-000000000001',
    'user',
    'owner_user_message_1 test_only_2b_v_b',
    '2026-06-16 09:01:00'
  ),
  (
    '65000000-0000-4000-8000-000000000002',
    '64000000-0000-4000-8000-000000000001',
    'user',
    'owner_user_message_2 test_only_2b_v_b',
    '2026-06-16 09:01:00'
  ),
  (
    '65000000-0000-4000-8000-000000000003',
    '64000000-0000-4000-8000-000000000001',
    'assistant',
    'assistant internal message test_only_2b_v_b',
    '2026-06-16 09:02:00'
  ),
  (
    '65000000-0000-4000-8000-000000000004',
    '64000000-0000-4000-8000-000000000001',
    'system',
    'system internal message test_only_2b_v_b',
    '2026-06-16 09:03:00'
  ),
  (
    '65000000-0000-4000-8000-000000000005',
    '64000000-0000-4000-8000-000000000001',
    'tool',
    'tool internal message test_only_2b_v_b',
    '2026-06-16 09:04:00'
  ),
  (
    '65000000-0000-4000-8000-000000000006',
    '64000000-0000-4000-8000-000000000003',
    'user',
    'other_user_message test_only_2b_v_b',
    '2026-06-16 10:01:00'
  ),
  (
    '65000000-0000-4000-8000-000000000007',
    '64000000-0000-4000-8000-000000000002',
    'user',
    'archived_session_historical_message test_only_2b_v_b',
    '2026-06-16 08:15:00'
  );

select is(
  (select count(*)::bigint from auth.users
    where email like '%test_only_2b_v_b%'),
  2::bigint,
  'exactly two Auth fixtures exist inside the transaction'
);
select is(
  (select count(*)::bigint from public.users
    where display_name like '%test_only_2b_v_b%'),
  2::bigint,
  'exactly two public profile fixtures exist inside the transaction'
);
select is(
  (select count(*)::bigint from public.specialists
    where name like '%test_only_2b_v_b%'),
  1::bigint,
  'exactly one internal specialist fixture exists inside the transaction'
);
select is(
  (select count(*)::bigint from public.specialist_catalog
    where display_name like '%test_only_2b_v_b%'),
  1::bigint,
  'exactly one catalog fixture exists inside the transaction'
);
select is(
  (select count(*)::bigint from public.chat_sessions
    where id::text like '64000000-0000-4000-8000-%'),
  3::bigint,
  'exactly three chat session fixtures exist inside the transaction'
);
select is(
  (select count(*)::bigint from public.messages
    where id::text like '65000000-0000-4000-8000-%'),
  7::bigint,
  'exactly seven message fixtures exist inside the transaction'
);

select is(
  (select count(*)::bigint
    from public.messages m
    join public.chat_sessions s on s.id = m.session_id
    where m.id::text like '65000000-0000-4000-8000-%'),
  7::bigint,
  'all message fixtures satisfy the session foreign key'
);
select is(
  (select user_id from public.chat_sessions
    where id = '64000000-0000-4000-8000-000000000001'),
  '61000000-0000-4000-8000-000000000001'::uuid,
  'owner active session belongs to owner'
);
select is(
  (select status from public.chat_sessions
    where id = '64000000-0000-4000-8000-000000000001'),
  'active',
  'owner active session is active'
);
select is(
  (select user_id from public.chat_sessions
    where id = '64000000-0000-4000-8000-000000000003'),
  '61000000-0000-4000-8000-000000000002'::uuid,
  'other user session belongs to other user'
);
select is(
  (select status from public.chat_sessions
    where id = '64000000-0000-4000-8000-000000000002'),
  'archived',
  'owner archived session is archived'
);
select is(
  (select count(*)::bigint from public.messages
    where session_id = '64000000-0000-4000-8000-000000000001'),
  5::bigint,
  'owner active session has five direct fixture messages'
);
select is(
  (select count(*)::bigint from public.messages
    where session_id = '64000000-0000-4000-8000-000000000003'),
  1::bigint,
  'other user session has one direct fixture message'
);
select is(
  (select count(*)::bigint from public.messages
    where session_id = '64000000-0000-4000-8000-000000000002'),
  1::bigint,
  'archived session has one historical direct fixture message'
);
select is(
  (select content from public.messages
    where id = '65000000-0000-4000-8000-000000000007'),
  'archived_session_historical_message test_only_2b_v_b',
  'archived session message is explicitly historical'
);

select is(
  (
    select array_agg(id order by created_at asc, id asc)::text
    from public.messages
    where session_id = '64000000-0000-4000-8000-000000000001'
  ),
  '{65000000-0000-4000-8000-000000000001,65000000-0000-4000-8000-000000000002,65000000-0000-4000-8000-000000000003,65000000-0000-4000-8000-000000000004,65000000-0000-4000-8000-000000000005}',
  'owner active messages follow stable created_at ASC, id ASC order'
);

select set_eq(
  $$select distinct role from public.messages
    where id::text like '65000000-0000-4000-8000-%'$$,
  $$values ('user'), ('assistant'), ('system'), ('tool')$$,
  'all approved internal roles are represented'
);
select is(
  (select count(*)::bigint from public.messages
    where role = 'user'
      and id::text like '65000000-0000-4000-8000-%'),
  4::bigint,
  'user role is accepted internally'
);
select is(
  (select count(*)::bigint from public.messages
    where role = 'assistant'
      and id::text like '65000000-0000-4000-8000-%'),
  1::bigint,
  'assistant role is accepted internally'
);
select is(
  (select count(*)::bigint from public.messages
    where role = 'system'
      and id::text like '65000000-0000-4000-8000-%'),
  1::bigint,
  'system role is accepted internally'
);
select is(
  (select count(*)::bigint from public.messages
    where role = 'tool'
      and id::text like '65000000-0000-4000-8000-%'),
  1::bigint,
  'tool role is accepted internally'
);
select is(
  (select count(*)::bigint from public.messages
    where attachments is null
      and id::text like '65000000-0000-4000-8000-%'),
  7::bigint,
  'all fixtures keep attachments NULL'
);

select lives_ok(
  $$insert into public.messages (
      id, session_id, role, content, created_at
    ) values (
      '65000000-0000-4000-8000-000000000008',
      '64000000-0000-4000-8000-000000000001',
      'user',
      repeat('x', 4000),
      '2026-06-16 09:05:00'
    )$$,
  'content with exactly 4000 characters is accepted internally'
);
select throws_ok(
  $$insert into public.messages (role, content)
    values ('user', 'Missing session')$$,
  '23502', null, 'session_id NULL is rejected'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '69999999-0000-4000-8000-000000000001',
      'user',
      'Missing session'
    )$$,
  '23503', null, 'nonexistent session_id is rejected'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '64000000-0000-4000-8000-000000000001',
      'user',
      null
    )$$,
  '23502', null, 'content NULL is rejected'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '64000000-0000-4000-8000-000000000001',
      'user',
      ''
    )$$,
  '23514', null, 'empty content is rejected'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '64000000-0000-4000-8000-000000000001',
      'user',
      '     '
    )$$,
  '23514', null, 'whitespace content is rejected'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '64000000-0000-4000-8000-000000000001',
      'user',
      repeat('x', 4001)
    )$$,
  '23514', null, 'content longer than 4000 characters is rejected'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '64000000-0000-4000-8000-000000000001',
      'admin',
      'Invalid role'
    )$$,
  '23514', null, 'invalid role is rejected'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '64000000-0000-4000-8000-000000000001',
      'chief_intervention',
      'Legacy role'
    )$$,
  '23514', null, 'chief_intervention remains rejected'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content, attachments)
    values (
      '64000000-0000-4000-8000-000000000001',
      'user',
      'Attachment attempt',
      '{"type":"pdf"}'
    )$$,
  '23514', null, 'attachments not NULL are rejected'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content, created_at)
    values (
      '64000000-0000-4000-8000-000000000001',
      'user',
      'Missing timestamp',
      null
    )$$,
  '23502', null, 'created_at NULL is rejected'
);

select is(
  (select message_count from public.chat_sessions
    where id = '64000000-0000-4000-8000-000000000001'),
  0,
  'direct fixtures do not update owner active message_count'
);
select is(
  (select last_message_at from public.chat_sessions
    where id = '64000000-0000-4000-8000-000000000001'),
  '2026-06-16 09:00:00'::timestamp,
  'direct fixtures do not update owner active last_message_at'
);
select is(
  (select message_count from public.chat_sessions
    where id = '64000000-0000-4000-8000-000000000002'),
  0,
  'historical archived fixture does not update archived message_count'
);
select is(
  (select last_message_at from public.chat_sessions
    where id = '64000000-0000-4000-8000-000000000002'),
  '2026-06-16 08:30:00'::timestamp,
  'historical archived fixture does not update archived last_message_at'
);
select is(
  (select count(*)::bigint from public.chat_sessions
    where id::text like '64000000-0000-4000-8000-%'),
  3::bigint,
  'direct message fixtures do not create or delete chat_sessions'
);

select ok(
  (
    select c.relrowsecurity and not c.relforcerowsecurity
    from pg_catalog.pg_class c
    where c.oid = 'public.messages'::regclass
  ),
  'messages preserves RLS without FORCE'
);
select is(
  (select count(*)::bigint from pg_catalog.pg_policies
    where schemaname = 'public' and tablename = 'messages'),
  0::bigint,
  'messages preserves zero policies'
);
select ok(
  not has_table_privilege('anon', 'public.messages', 'SELECT')
    and not has_table_privilege('anon', 'public.messages', 'INSERT')
    and not has_table_privilege('anon', 'public.messages', 'UPDATE')
    and not has_table_privilege('anon', 'public.messages', 'DELETE'),
  'anon preserves zero CRUD privileges on messages'
);
select ok(
  not has_table_privilege('authenticated', 'public.messages', 'SELECT')
    and not has_table_privilege('authenticated', 'public.messages', 'INSERT')
    and not has_table_privilege('authenticated', 'public.messages', 'UPDATE')
    and not has_table_privilege('authenticated', 'public.messages', 'DELETE'),
  'authenticated preserves zero CRUD privileges on messages'
);
select ok(
  not has_any_column_privilege('anon', 'public.messages', 'SELECT')
    and not has_any_column_privilege('authenticated', 'public.messages', 'SELECT')
    and not has_any_column_privilege('anon', 'public.messages', 'UPDATE')
    and not has_any_column_privilege('authenticated', 'public.messages', 'UPDATE'),
  'anon and authenticated preserve zero column privileges on messages'
);

set local role anon;
select throws_ok(
  $$select * from public.messages$$,
  '42501', null, 'anon cannot SELECT message fixtures'
);
select throws_ok(
  $$insert into public.messages default values$$,
  '42501', null, 'anon cannot INSERT message fixtures'
);
select throws_ok(
  $$update public.messages set content = 'Changed'$$,
  '42501', null, 'anon cannot UPDATE message fixtures'
);
select throws_ok(
  $$delete from public.messages$$,
  '42501', null, 'anon cannot DELETE message fixtures'
);
reset role;

set local role authenticated;
select throws_ok(
  $$select * from public.messages$$,
  '42501', null, 'authenticated cannot SELECT message fixtures'
);
select throws_ok(
  $$insert into public.messages default values$$,
  '42501', null, 'authenticated cannot INSERT message fixtures'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '64000000-0000-4000-8000-000000000002',
      'user',
      'Archived write attempt'
    )$$,
  '42501', null, 'authenticated cannot write a new message into an archived session'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '64000000-0000-4000-8000-000000000001',
      'assistant',
      'Spoofed assistant'
    )$$,
  '42501', null, 'authenticated cannot spoof assistant role'
);
select throws_ok(
  $$update public.messages set content = 'Changed'$$,
  '42501', null, 'authenticated cannot UPDATE message fixtures'
);
select throws_ok(
  $$delete from public.messages$$,
  '42501', null, 'authenticated cannot DELETE message fixtures'
);
reset role;

select is(
  (select count(*)::bigint from public.messages
    where id::text like '65000000-0000-4000-8000-%'),
  8::bigint,
  'invalid and denied attempts only added the approved direct fixtures'
);

select * from finish();

rollback;

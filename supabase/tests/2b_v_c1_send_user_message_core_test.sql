begin;

create extension if not exists pgtap with schema extensions;

select plan(48);

select has_function(
  'public',
  'send_user_message_core',
  ARRAY['uuid', 'uuid', 'text'],
  'send_user_message_core RPC exists'
);

select ok(
  not (
    select p.prosecdef
    from pg_catalog.pg_proc p
    join pg_catalog.pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.proname = 'send_user_message_core'
      and p.pronargs = 3
  ),
  'send_user_message_core is not SECURITY DEFINER'
);

select is(
  (
    select array_agg(pg_catalog.format_type(t, null) order by ord)::text
    from pg_catalog.pg_proc p
    join pg_catalog.pg_namespace n on n.oid = p.pronamespace
    cross join unnest(p.proargtypes::oid[]) with ordinality as args(t, ord)
    where n.nspname = 'public'
      and p.proname = 'send_user_message_core'
  ),
  '{uuid,uuid,text}',
  'send_user_message_core has the approved argument types'
);

select ok(
  not has_function_privilege(
    'anon',
    'public.send_user_message_core(uuid, uuid, text)',
    'EXECUTE'
  ),
  'anon cannot execute send_user_message_core'
);
select ok(
  not has_function_privilege(
    'authenticated',
    'public.send_user_message_core(uuid, uuid, text)',
    'EXECUTE'
  ),
  'authenticated cannot execute send_user_message_core'
);
select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_proc p
    join pg_catalog.pg_namespace n on n.oid = p.pronamespace
    cross join lateral aclexplode(
      coalesce(p.proacl, acldefault('f', p.proowner))
    ) as acl
    where n.nspname = 'public'
      and p.proname = 'send_user_message_core'
      and acl.grantee = 0
      and acl.privilege_type = 'EXECUTE'
  ),
  0::bigint,
  'PUBLIC has no EXECUTE grant on send_user_message_core'
);
select ok(
  has_function_privilege(
    'service_role',
    'public.send_user_message_core(uuid, uuid, text)',
    'EXECUTE'
  ),
  'service_role can execute send_user_message_core for local backend use'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_policies
    where schemaname = 'public'
      and tablename in ('messages', 'chat_sessions')
  ),
  0::bigint,
  'messages and chat_sessions still have zero policies'
);
select ok(
  not has_table_privilege('anon', 'public.messages', 'INSERT')
    and not has_table_privilege('authenticated', 'public.messages', 'INSERT')
    and not has_table_privilege('anon', 'public.chat_sessions', 'UPDATE')
    and not has_table_privilege('authenticated', 'public.chat_sessions', 'UPDATE'),
  'client table grants remain closed on messages and chat_sessions'
);

insert into auth.users (
  id, instance_id, aud, role, email, encrypted_password, created_at, updated_at
) values
  (
    '71000000-0000-4000-8000-000000000001',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'owner_test_only_2b_v_c1@example.invalid', '', now(), now()
  ),
  (
    '71000000-0000-4000-8000-000000000002',
    '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated',
    'other_test_only_2b_v_c1@example.invalid', '', now(), now()
  );

insert into public.users (id, display_name) values
  ('71000000-0000-4000-8000-000000000001', 'owner_test_only_2b_v_c1'),
  ('71000000-0000-4000-8000-000000000002', 'other_test_only_2b_v_c1');

insert into public.specialists (
  id, name, category, prompt_template, is_premium, is_active
) values (
  '72000000-0000-4000-8000-000000000001',
  'internal_specialist_test_only_2b_v_c1',
  'salud',
  '{"marker":"test_only_2b_v_c1_placeholder_not_for_production"}',
  false,
  true
);

insert into public.specialist_catalog (
  id, specialist_id, display_name, product_area, short_description,
  is_published, availability_status, access_tier, sort_order
) values (
  '73000000-0000-4000-8000-000000000001',
  '72000000-0000-4000-8000-000000000001',
  'catalog_test_only_2b_v_c1',
  'health',
  'Fixture transaccional test_only_2b_v_c1 no apto para producción.',
  false,
  'available',
  'free',
  1
);

insert into public.chat_sessions (
  id, user_id, specialist_id, started_at, last_message_at, status, message_count
) values
  (
    '74000000-0000-4000-8000-000000000001',
    '71000000-0000-4000-8000-000000000001',
    '72000000-0000-4000-8000-000000000001',
    '2026-06-20 09:00:00', '2026-06-20 09:00:00', 'active', 0
  ),
  (
    '74000000-0000-4000-8000-000000000002',
    '71000000-0000-4000-8000-000000000001',
    '72000000-0000-4000-8000-000000000001',
    '2026-06-20 08:00:00', '2026-06-20 08:30:00', 'archived', 0
  ),
  (
    '74000000-0000-4000-8000-000000000003',
    '71000000-0000-4000-8000-000000000002',
    '72000000-0000-4000-8000-000000000001',
    '2026-06-20 10:00:00', '2026-06-20 10:00:00', 'active', 0
  );

select is(
  (select count(*)::bigint from auth.users
    where email like '%test_only_2b_v_c1%'),
  2::bigint,
  'two Auth fixtures exist inside the transaction'
);
select is(
  (select count(*)::bigint from public.chat_sessions
    where id::text like '74000000-0000-4000-8000-%'),
  3::bigint,
  'three chat session fixtures exist inside the transaction'
);
select is(
  (select count(*)::bigint from public.messages
    where id::text like '75000000-0000-4000-8000-%'),
  0::bigint,
  'no C1 messages exist before RPC invocation'
);

set local role anon;
select throws_ok(
  $$select * from public.send_user_message_core(
      '74000000-0000-4000-8000-000000000001',
      '71000000-0000-4000-8000-000000000001',
      'anon attempt'
    )$$,
  '42501', null, 'anon cannot invoke send_user_message_core'
);
reset role;

set local role authenticated;
select throws_ok(
  $$select * from public.send_user_message_core(
      '74000000-0000-4000-8000-000000000001',
      '71000000-0000-4000-8000-000000000001',
      'authenticated attempt'
    )$$,
  '42501', null, 'authenticated cannot invoke send_user_message_core'
);
reset role;

set local role service_role;
select lives_ok(
  $$select * from public.send_user_message_core(
      '74000000-0000-4000-8000-000000000001',
      '71000000-0000-4000-8000-000000000001',
      '  Hello from C1  '
    )$$,
  'service_role can invoke send_user_message_core for owner active session'
);
reset role;

select is(
  (select count(*)::bigint from public.messages
    where session_id = '74000000-0000-4000-8000-000000000001'),
  1::bigint,
  'one message was created for owner active session'
);
select is(
  (select role from public.messages
    where session_id = '74000000-0000-4000-8000-000000000001'),
  'user',
  'created message role is always user'
);
select is(
  (select content from public.messages
    where session_id = '74000000-0000-4000-8000-000000000001'),
  'Hello from C1',
  'created message content is trimmed'
);
select is(
  (select attachments from public.messages
    where session_id = '74000000-0000-4000-8000-000000000001'),
  null,
  'created message attachments remain NULL'
);
select isnt(
  (select created_at from public.messages
    where session_id = '74000000-0000-4000-8000-000000000001'),
  null,
  'created message timestamp is server-managed'
);
select is(
  (select count(*)::bigint from public.messages
    where role in ('assistant', 'system', 'tool')
      and session_id = '74000000-0000-4000-8000-000000000001'),
  0::bigint,
  'RPC creates no assistant/system/tool messages'
);
select is(
  (select message_count from public.chat_sessions
    where id = '74000000-0000-4000-8000-000000000001'),
  1,
  'message_count increments exactly once'
);
select is(
  (
    select cs.last_message_at = m.created_at
    from public.chat_sessions cs
    join public.messages m on m.session_id = cs.id
    where cs.id = '74000000-0000-4000-8000-000000000001'
  ),
  true,
  'last_message_at matches inserted message created_at'
);

set local role service_role;
select throws_ok(
  $$select * from public.send_user_message_core(
      null,
      '71000000-0000-4000-8000-000000000001',
      'missing session'
    )$$,
  'P0001', 'invalid_request', 'NULL session_id is rejected'
);
select throws_ok(
  $$select * from public.send_user_message_core(
      '74000000-0000-4000-8000-000000000001',
      null,
      'missing owner'
    )$$,
  'P0001', 'invalid_request', 'NULL owner is rejected'
);
select throws_ok(
  $$select * from public.send_user_message_core(
      '79999999-0000-4000-8000-000000000001',
      '71000000-0000-4000-8000-000000000001',
      'missing session'
    )$$,
  'P0001', 'session_not_found', 'missing session is rejected'
);
select throws_ok(
  $$select * from public.send_user_message_core(
      '74000000-0000-4000-8000-000000000003',
      '71000000-0000-4000-8000-000000000001',
      'other session'
    )$$,
  'P0001', 'session_not_found', 'other user session is rejected'
);
select throws_ok(
  $$select * from public.send_user_message_core(
      '74000000-0000-4000-8000-000000000002',
      '71000000-0000-4000-8000-000000000001',
      'archived session'
    )$$,
  'P0001', 'session_archived', 'archived session is rejected'
);
select throws_ok(
  $$select * from public.send_user_message_core(
      '74000000-0000-4000-8000-000000000001',
      '71000000-0000-4000-8000-000000000001',
      null
    )$$,
  'P0001', 'content_invalid', 'NULL content is rejected'
);
select throws_ok(
  $$select * from public.send_user_message_core(
      '74000000-0000-4000-8000-000000000001',
      '71000000-0000-4000-8000-000000000001',
      ''
    )$$,
  'P0001', 'content_invalid', 'empty content is rejected'
);
select throws_ok(
  $$select * from public.send_user_message_core(
      '74000000-0000-4000-8000-000000000001',
      '71000000-0000-4000-8000-000000000001',
      '     '
    )$$,
  'P0001', 'content_invalid', 'whitespace content is rejected'
);
select throws_ok(
  $$select * from public.send_user_message_core(
      '74000000-0000-4000-8000-000000000001',
      '71000000-0000-4000-8000-000000000001',
      repeat('x', 4001)
    )$$,
  'P0001', 'content_too_long', 'content longer than 4000 is rejected'
);
reset role;

select is(
  (select count(*)::bigint from public.messages),
  1::bigint,
  'failed validations did not insert additional messages'
);
select is(
  (select count(*)::bigint from public.messages
    where session_id = '74000000-0000-4000-8000-000000000002'),
  0::bigint,
  'archived session failure inserted no message'
);
select is(
  (select count(*)::bigint from public.messages
    where session_id = '74000000-0000-4000-8000-000000000003'),
  0::bigint,
  'other session failure inserted no message'
);
select is(
  (select message_count from public.chat_sessions
    where id = '74000000-0000-4000-8000-000000000002'),
  0,
  'archived session failure did not change message_count'
);
select is(
  (select last_message_at from public.chat_sessions
    where id = '74000000-0000-4000-8000-000000000002'),
  '2026-06-20 08:30:00'::timestamp,
  'archived session failure did not change last_message_at'
);
select is(
  (select message_count from public.chat_sessions
    where id = '74000000-0000-4000-8000-000000000003'),
  0,
  'other session failure did not change message_count'
);
select is(
  (select last_message_at from public.chat_sessions
    where id = '74000000-0000-4000-8000-000000000003'),
  '2026-06-20 10:00:00'::timestamp,
  'other session failure did not change last_message_at'
);

select is(
  (select count(*)::bigint from public.specialists
    where name like '%test_only_2b_v_c1%'),
  1::bigint,
  'specialists fixture remains unchanged'
);
select is(
  (select count(*)::bigint from public.specialist_catalog
    where display_name like '%test_only_2b_v_c1%'),
  1::bigint,
  'specialist_catalog fixture remains unchanged'
);
select ok(
  (
    select c.relrowsecurity and not c.relforcerowsecurity
    from pg_catalog.pg_class c
    where c.oid = 'public.messages'::regclass
  ),
  'messages preserves RLS without FORCE'
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
    where schemaname = 'public'
      and tablename in ('messages', 'chat_sessions')),
  0::bigint,
  'messages and chat_sessions preserve zero policies'
);
select ok(
  not has_table_privilege('anon', 'public.messages', 'SELECT')
    and not has_table_privilege('authenticated', 'public.messages', 'SELECT')
    and not has_table_privilege('anon', 'public.chat_sessions', 'SELECT')
    and not has_table_privilege('authenticated', 'public.chat_sessions', 'SELECT'),
  'client SELECT table grants remain closed'
);

select set_eq(
  $$select distinct role from public.messages$$,
  $$values ('user')$$,
  'only user role exists after C1 calls'
);
select is(
  (select count(*)::bigint from public.messages
    where attachments is not null),
  0::bigint,
  'no C1 message has attachments'
);
select is(
  (select count(*)::bigint from public.messages m
    left join public.chat_sessions cs on cs.id = m.session_id
    where cs.id is null),
  0::bigint,
  'no orphan messages exist'
);

select * from finish();

rollback;

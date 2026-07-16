begin;

create extension if not exists pgtap with schema extensions;
select no_plan();

select has_table('public', 'conversation_idempotency', 'idempotency ledger exists');
select ok(
  (select relrowsecurity and not relforcerowsecurity
   from pg_catalog.pg_class where oid = 'public.conversation_idempotency'::regclass),
  'idempotency ledger has deny-all RLS posture'
);
select is(
  (select count(*)::bigint from pg_catalog.pg_policies
   where schemaname = 'public' and tablename = 'conversation_idempotency'),
  0::bigint,
  'idempotency ledger has zero policies'
);
select ok(
  not has_table_privilege('anon', 'public.conversation_idempotency', 'SELECT,INSERT,UPDATE,DELETE')
  and not has_table_privilege('authenticated', 'public.conversation_idempotency', 'SELECT,INSERT,UPDATE,DELETE'),
  'client roles have zero idempotency CRUD grants'
);
select has_function(
  'public', 'create_own_chat_session_core', ARRAY['uuid', 'uuid', 'text'],
  'transactional create RPC exists'
);
select has_function(
  'public', 'send_user_message_core', ARRAY['uuid', 'uuid', 'text', 'text'],
  'idempotent send RPC exists'
);
select ok(
  not has_function_privilege('anon', 'public.create_own_chat_session_core(uuid,uuid,text)', 'EXECUTE')
  and not has_function_privilege('authenticated', 'public.create_own_chat_session_core(uuid,uuid,text)', 'EXECUTE')
  and not has_function_privilege('anon', 'public.send_user_message_core(uuid,uuid,text,text)', 'EXECUTE')
  and not has_function_privilege('authenticated', 'public.send_user_message_core(uuid,uuid,text,text)', 'EXECUTE'),
  'clients cannot invoke either write RPC'
);
select ok(
  has_function_privilege('service_role', 'public.create_own_chat_session_core(uuid,uuid,text)', 'EXECUTE')
  and has_function_privilege('service_role', 'public.send_user_message_core(uuid,uuid,text,text)', 'EXECUTE'),
  'backend service role has only the required RPC entry points'
);
select is(
  (select count(*)::bigint from pg_catalog.pg_proc p
   join pg_catalog.pg_namespace n on n.oid = p.pronamespace
   where n.nspname = 'public'
     and p.proname in ('create_own_chat_session_core', 'send_user_message_core')
     and p.prosecdef),
  0::bigint,
  'write RPCs are not SECURITY DEFINER'
);
select is(
  (select count(*)::bigint from pg_catalog.pg_proc p
   join pg_catalog.pg_namespace n on n.oid = p.pronamespace
   where n.nspname = 'public'
     and p.proname in ('create_own_chat_session_core', 'send_user_message_core')
     and not ('search_path=public, extensions, pg_temp' = any(p.proconfig))),
  0::bigint,
  'write RPCs pin a safe search_path'
);

insert into auth.users (id, instance_id, aud, role, email, encrypted_password, created_at, updated_at) values
  ('f1300000-0000-4000-8000-000000000001', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'foundation_013b_a@example.invalid', '', now(), now()),
  ('f1300000-0000-4000-8000-000000000002', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'foundation_013b_b@example.invalid', '', now(), now());
insert into public.users (id, display_name) values
  ('f1300000-0000-4000-8000-000000000001', 'foundation_013b_a'),
  ('f1300000-0000-4000-8000-000000000002', 'foundation_013b_b');
insert into public.specialists (id, name, category, prompt_template, is_premium, is_active) values
  ('f1310000-0000-4000-8000-000000000001', 'foundation_013b_free', 'salud', '{}', false, true),
  ('f1310000-0000-4000-8000-000000000002', 'foundation_013b_unavailable', 'salud', '{}', false, true),
  ('f1310000-0000-4000-8000-000000000003', 'foundation_013b_pro', 'salud', '{}', true, true);
insert into public.specialist_catalog (
  id, specialist_id, slug, display_name, product_area, short_description,
  publication_status, is_published, availability_status, access_tier,
  supported_surfaces, is_conversable
) values
  ('f1320000-0000-4000-8000-000000000001', 'f1310000-0000-4000-8000-000000000001', 'foundation-013b-free', 'Foundation 013B Free', 'health', 'Synthetic.', 'published', true, 'available', 'free', ARRAY['product']::text[], true),
  ('f1320000-0000-4000-8000-000000000002', 'f1310000-0000-4000-8000-000000000002', 'foundation-013b-unavailable', 'Foundation 013B Unavailable', 'health', 'Synthetic.', 'published', true, 'unavailable', 'free', ARRAY['product']::text[], true),
  ('f1320000-0000-4000-8000-000000000003', 'f1310000-0000-4000-8000-000000000003', 'foundation-013b-pro', 'Foundation 013B Pro', 'health', 'Synthetic.', 'published', true, 'available', 'pro', ARRAY['product']::text[], true);

set local role service_role;
create temporary table foundation_013b_create_first as
select * from public.create_own_chat_session_core(
  'f1300000-0000-4000-8000-000000000001',
  'f1320000-0000-4000-8000-000000000001',
  'foundation_create_key_0001'
);
create temporary table foundation_013b_create_replay as
select * from public.create_own_chat_session_core(
  'f1300000-0000-4000-8000-000000000001',
  'f1320000-0000-4000-8000-000000000001',
  'foundation_create_key_0001'
);
reset role;

select is(
  (select session_id from foundation_013b_create_replay),
  (select session_id from foundation_013b_create_first),
  'same create key and payload returns the original conversation'
);
select ok(
  not (select idempotent_replay from foundation_013b_create_first)
  and (select idempotent_replay from foundation_013b_create_replay),
  'create distinguishes first effect from successful replay internally'
);
select is(
  (select count(*)::bigint from public.chat_sessions
   where user_id = 'f1300000-0000-4000-8000-000000000001'),
  1::bigint,
  'create replay inserts exactly one conversation'
);
select is(
  (select count(*)::bigint from public.messages), 0::bigint,
  'conversation creation never creates messages'
);

set local role service_role;
select throws_ok(
  $$select * from public.create_own_chat_session_core(
    'f1300000-0000-4000-8000-000000000001',
    'f1320000-0000-4000-8000-000000000002',
    'foundation_create_key_0001')$$,
  'P0001', 'idempotency_conflict',
  'same create key with a conflicting specialist is denied before effect'
);
select lives_ok(
  $$select * from public.create_own_chat_session_core(
    'f1300000-0000-4000-8000-000000000001',
    'f1320000-0000-4000-8000-000000000001',
    'foundation_create_key_0002')$$,
  'different create key creates a new conversation'
);
select lives_ok(
  $$select * from public.create_own_chat_session_core(
    'f1300000-0000-4000-8000-000000000002',
    'f1320000-0000-4000-8000-000000000001',
    'foundation_create_key_0001')$$,
  'same create key is independent for another authenticated subject'
);
select throws_ok(
  $$select * from public.create_own_chat_session_core(
    'f1300000-0000-4000-8000-000000000001',
    'ffffffff-ffff-4fff-8fff-ffffffffffff',
    'foundation_create_invalid_01')$$,
  'P0001', 'invalid_selectable_specialist', 'missing catalog selection fails closed'
);
select throws_ok(
  $$select * from public.create_own_chat_session_core(
    'f1300000-0000-4000-8000-000000000001',
    'f1320000-0000-4000-8000-000000000002',
    'foundation_create_invalid_02')$$,
  'P0001', 'specialist_unavailable', 'unavailable specialist is denied atomically'
);
select throws_ok(
  $$select * from public.create_own_chat_session_core(
    'f1300000-0000-4000-8000-000000000001',
    'f1320000-0000-4000-8000-000000000003',
    'foundation_create_invalid_03')$$,
  'P0001', 'pro_locked', 'recognized locked tier preserves current access behavior'
);
select throws_ok(
  $$select * from public.create_own_chat_session_core(
    'f1300000-0000-4000-8000-000000000001',
    'f1320000-0000-4000-8000-000000000001',
    'short')$$,
  'P0001', 'invalid_idempotency_key', 'invalid create idempotency key is rejected'
);
reset role;

set local role service_role;
create temporary table foundation_013b_send_first as
select * from public.send_user_message_core(
  (select session_id from foundation_013b_create_first),
  'f1300000-0000-4000-8000-000000000001',
  '  Synthetic hello  ',
  'foundation_send_key_000001'
);
create temporary table foundation_013b_send_replay as
select * from public.send_user_message_core(
  (select session_id from foundation_013b_create_first),
  'f1300000-0000-4000-8000-000000000001',
  'Synthetic hello',
  'foundation_send_key_000001'
);
reset role;

select is(
  (select message_id from foundation_013b_send_replay),
  (select message_id from foundation_013b_send_first),
  'same send key and normalized content returns original message'
);
select ok(
  not (select idempotent_replay from foundation_013b_send_first)
  and (select idempotent_replay from foundation_013b_send_replay),
  'send distinguishes first effect from successful replay internally'
);
select is((select count(*)::bigint from public.messages), 1::bigint,
  'send replay inserts exactly one message');
select is(
  (select message_count from public.chat_sessions
   where id = (select session_id from foundation_013b_create_first)),
  1, 'send replay increments message_count exactly once'
);

set local role service_role;
select throws_ok(
  $$select * from public.send_user_message_core(
    (select session_id from foundation_013b_create_first),
    'f1300000-0000-4000-8000-000000000001',
    'Conflicting content', 'foundation_send_key_000001')$$,
  'P0001', 'idempotency_conflict', 'same send key with conflicting content is denied'
);
select throws_ok(
  $$select * from public.send_user_message_core(
    (select id from public.chat_sessions
     where user_id = 'f1300000-0000-4000-8000-000000000001'
       and id <> (select session_id from foundation_013b_create_first)
     limit 1),
    'f1300000-0000-4000-8000-000000000001',
    'Synthetic hello', 'foundation_send_key_000001')$$,
  'P0001', 'idempotency_conflict', 'same send key cannot move to another conversation'
);
select lives_ok(
  $$select * from public.send_user_message_core(
    (select id from public.chat_sessions
     where user_id = 'f1300000-0000-4000-8000-000000000001'
       and status = 'active'
     limit 1),
    'f1300000-0000-4000-8000-000000000001',
    'Second intent', 'foundation_send_key_000002')$$,
  'different send key creates a second message'
);
select throws_ok(
  $$select * from public.send_user_message_core(
    (select session_id from foundation_013b_create_first),
    'f1300000-0000-4000-8000-000000000002',
    'Foreign attempt', 'foundation_send_foreign_01')$$,
  'P0001', 'session_not_found', 'non-owner receives opaque not found'
);

update public.chat_sessions set status = 'archived'
where id = (select session_id from foundation_013b_create_first);
select throws_ok(
  $$select * from public.send_user_message_core(
    (select session_id from foundation_013b_create_first),
    'f1300000-0000-4000-8000-000000000001',
    'Archived attempt', 'foundation_send_archived_01')$$,
  'P0001', 'session_archived', 'archived conversation rejects user message'
);
reset role;

select is((select count(*)::bigint from public.messages), 2::bigint,
  'failed send attempts create no additional effects');
select is(
  (select count(*)::bigint from public.conversation_idempotency
   where result_metadata::text like '%Synthetic hello%'),
  0::bigint,
  'idempotency ledger stores no message content'
);
select is(
  (select count(*)::bigint from public.conversation_idempotency
   where payload_fingerprint !~ '^[0-9a-f]{64}$'),
  0::bigint,
  'all persisted payloads are represented by deterministic fingerprints'
);
select lives_ok(
  $$select * from public.send_user_message_core(
    (select id from public.chat_sessions
     where user_id = 'f1300000-0000-4000-8000-000000000001'
       and status = 'active'
     limit 1),
    'f1300000-0000-4000-8000-000000000001',
    'Cross-operation key', 'foundation_create_key_0001')$$,
  'same opaque key is independent across create and send operations'
);

select * from finish();
rollback;

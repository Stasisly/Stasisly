begin;
create extension if not exists pgtap with schema extensions;
select no_plan();

select has_column('public', 'chat_sessions', 'archived_at', 'lifecycle timestamp exists');
select has_function('public', 'list_own_conversations_core', array['uuid','text','integer','timestamp without time zone','uuid'], 'canonical list RPC exists');
select has_function('public', 'read_own_conversation_core', array['uuid','uuid'], 'canonical read RPC exists');
select has_function('public', 'archive_own_conversation_core', array['uuid','uuid'], 'canonical archive RPC exists');
select has_function('public', 'restore_own_conversation_core', array['uuid','uuid'], 'canonical restore RPC exists');
select ok(
  not has_function_privilege('anon', 'public.list_own_conversations_core(uuid,text,integer,timestamp without time zone,uuid)', 'EXECUTE')
  and not has_function_privilege('authenticated', 'public.read_own_conversation_core(uuid,uuid)', 'EXECUTE')
  and not has_function_privilege('anon', 'public.archive_own_conversation_core(uuid,uuid)', 'EXECUTE')
  and not has_function_privilege('authenticated', 'public.restore_own_conversation_core(uuid,uuid)', 'EXECUTE'),
  'client roles cannot invoke lifecycle RPCs'
);
select ok(
  has_function_privilege('service_role', 'public.list_own_conversations_core(uuid,text,integer,timestamp without time zone,uuid)', 'EXECUTE')
  and has_function_privilege('service_role', 'public.read_own_conversation_core(uuid,uuid)', 'EXECUTE')
  and has_function_privilege('service_role', 'public.archive_own_conversation_core(uuid,uuid)', 'EXECUTE')
  and has_function_privilege('service_role', 'public.restore_own_conversation_core(uuid,uuid)', 'EXECUTE'),
  'service role has only the lifecycle entry points'
);
select is(
  (select count(*)::bigint from pg_proc p join pg_namespace n on n.oid = p.pronamespace
   where n.nspname = 'public' and p.proname in ('list_own_conversations_core','read_own_conversation_core','archive_own_conversation_core','restore_own_conversation_core') and p.prosecdef),
  0::bigint, 'lifecycle RPCs are invoker security'
);

insert into auth.users (id, instance_id, aud, role, email, encrypted_password, created_at, updated_at) values
 ('f13c0000-0000-4000-8000-000000000001','00000000-0000-0000-0000-000000000000','authenticated','authenticated','foundation_013c_a@example.invalid','',now(),now()),
 ('f13c0000-0000-4000-8000-000000000002','00000000-0000-0000-0000-000000000000','authenticated','authenticated','foundation_013c_b@example.invalid','',now(),now());
insert into public.users (id, display_name) values
 ('f13c0000-0000-4000-8000-000000000001','foundation_013c_a'),
 ('f13c0000-0000-4000-8000-000000000002','foundation_013c_b');
insert into public.specialists (id,name,category,prompt_template,is_premium,is_active)
values ('f13c1000-0000-4000-8000-000000000001','foundation_013c_specialist','salud','{}',false,true);
insert into public.specialist_catalog (id,specialist_id,slug,display_name,product_area,short_description,publication_status,is_published,availability_status,access_tier,supported_surfaces,is_conversable)
values ('f13c2000-0000-4000-8000-000000000001','f13c1000-0000-4000-8000-000000000001','foundation-013c','Foundation 013C','health','Synthetic.','published',true,'available','free',array['product']::text[],true);
insert into public.chat_sessions (id,user_id,specialist_id,started_at,last_message_at,status,message_count,archived_at) values
 ('f13c3000-0000-4000-8000-000000000001','f13c0000-0000-4000-8000-000000000001','f13c1000-0000-4000-8000-000000000001','2026-01-01','2026-01-03','active',1,null),
 ('f13c3000-0000-4000-8000-000000000002','f13c0000-0000-4000-8000-000000000001','f13c1000-0000-4000-8000-000000000001','2026-01-01','2026-01-02','archived',1,'2026-01-04'),
 ('f13c3000-0000-4000-8000-000000000003','f13c0000-0000-4000-8000-000000000002','f13c1000-0000-4000-8000-000000000001','2026-01-01','2026-01-05','active',0,null);
insert into public.messages (id,session_id,role,content,attachments,created_at) values
 ('f13c4000-0000-4000-8000-000000000001','f13c3000-0000-4000-8000-000000000001','user','foundation 013c active',null,'2026-01-03'),
 ('f13c4000-0000-4000-8000-000000000002','f13c3000-0000-4000-8000-000000000002','user','foundation 013c archived',null,'2026-01-02');

set local role service_role;
select is((select count(*) from public.list_own_conversations_core('f13c0000-0000-4000-8000-000000000001')), 1::bigint, 'default list returns only own active');
select is((select conversation_id from public.list_own_conversations_core('f13c0000-0000-4000-8000-000000000001','archived',20,null,null)), 'f13c3000-0000-4000-8000-000000000002'::uuid, 'archived filter returns own archived');
select is((select count(*) from public.list_own_conversations_core('f13c0000-0000-4000-8000-000000000001','all',20,null,null)), 2::bigint, 'all transitional filter excludes foreign rows');
select is((select count(*) from public.list_own_conversations_core('f13c0000-0000-4000-8000-000000000001','active',20,'2026-01-03','f13c3000-0000-4000-8000-000000000001')), 0::bigint, 'stable tuple cursor excludes prior page');
select throws_ok($$select * from public.list_own_conversations_core('f13c0000-0000-4000-8000-000000000001','unknown',20,null,null)$$,'P0001','invalid_request','unknown filter rejected');
select throws_ok($$select * from public.list_own_conversations_core('f13c0000-0000-4000-8000-000000000001','active',52,null,null)$$,'P0001','invalid_request','unbounded limit rejected');
select is((select status from public.read_own_conversation_core('f13c0000-0000-4000-8000-000000000001','f13c3000-0000-4000-8000-000000000001')), 'active', 'owner reads active');
select is((select status from public.read_own_conversation_core('f13c0000-0000-4000-8000-000000000001','f13c3000-0000-4000-8000-000000000002')), 'archived', 'owner reads archived');
select throws_ok($$select * from public.read_own_conversation_core('f13c0000-0000-4000-8000-000000000002','f13c3000-0000-4000-8000-000000000001')$$,'P0001','conversation_not_found','foreign read is opaque');
select lives_ok($$select * from public.archive_own_conversation_core('f13c0000-0000-4000-8000-000000000001','f13c3000-0000-4000-8000-000000000001')$$,'active archives');
select lives_ok($$select * from public.archive_own_conversation_core('f13c0000-0000-4000-8000-000000000001','f13c3000-0000-4000-8000-000000000001')$$,'archive replay succeeds');
select is((select status from public.chat_sessions where id='f13c3000-0000-4000-8000-000000000001'),'archived','archive final state valid');
select is((select count(*) from public.messages where session_id='f13c3000-0000-4000-8000-000000000001'),1::bigint,'archive preserves messages');
select throws_ok($$select * from public.send_user_message_core('f13c3000-0000-4000-8000-000000000001','f13c0000-0000-4000-8000-000000000001','denied','foundation_013c_send_0001')$$,'P0001','session_archived','send denied while archived');
select lives_ok($$select * from public.restore_own_conversation_core('f13c0000-0000-4000-8000-000000000001','f13c3000-0000-4000-8000-000000000001')$$,'archived restores');
select lives_ok($$select * from public.restore_own_conversation_core('f13c0000-0000-4000-8000-000000000001','f13c3000-0000-4000-8000-000000000001')$$,'restore replay succeeds');
select lives_ok($$select * from public.send_user_message_core('f13c3000-0000-4000-8000-000000000001','f13c0000-0000-4000-8000-000000000001','restored send','foundation_013c_send_0002')$$,'restored conversation accepts send');
select throws_ok($$select * from public.archive_own_conversation_core('f13c0000-0000-4000-8000-000000000002','f13c3000-0000-4000-8000-000000000001')$$,'P0001','conversation_not_found','foreign lifecycle is opaque');
select lives_ok($$select * from public.archive_own_conversation_core('f13c0000-0000-4000-8000-000000000001','f13c3000-0000-4000-8000-000000000001'); select * from public.restore_own_conversation_core('f13c0000-0000-4000-8000-000000000001','f13c3000-0000-4000-8000-000000000001')$$,'serialized opposite transitions remain valid');
select is((select status from public.chat_sessions where id='f13c3000-0000-4000-8000-000000000001'),'active','last serialized lifecycle transition wins validly');
reset role;

select * from finish();
rollback;

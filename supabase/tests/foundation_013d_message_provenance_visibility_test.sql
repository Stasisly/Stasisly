BEGIN;

CREATE EXTENSION IF NOT EXISTS pgtap WITH SCHEMA extensions;
SELECT no_plan();

SELECT columns_are(
  'public', 'messages',
  ARRAY['id','session_id','role','content','attachments','created_at','author_type','provenance_type','visibility_type'],
  'messages exposes the transitional physical columns plus canonical metadata'
);
SELECT ok(
  (SELECT relrowsecurity FROM pg_catalog.pg_class WHERE oid = 'public.messages'::regclass),
  'messages RLS remains enabled'
);
SELECT is(
  (SELECT count(*)::bigint FROM pg_catalog.pg_policies
   WHERE schemaname = 'public' AND tablename = 'messages'),
  0::bigint,
  'messages retains zero policies'
);
SELECT ok(
  NOT has_table_privilege('anon', 'public.messages', 'SELECT,INSERT,UPDATE,DELETE')
  AND NOT has_table_privilege('authenticated', 'public.messages', 'SELECT,INSERT,UPDATE,DELETE'),
  'client roles retain zero message CRUD grants'
);
SELECT has_function(
  'public', 'list_own_conversation_messages_core',
  ARRAY['uuid','uuid','integer','timestamp without time zone','uuid'],
  'canonical owner-scoped list RPC exists'
);
SELECT ok(
  NOT has_function_privilege('anon', 'public.list_own_conversation_messages_core(uuid,uuid,integer,timestamp without time zone,uuid)', 'EXECUTE')
  AND NOT has_function_privilege('authenticated', 'public.list_own_conversation_messages_core(uuid,uuid,integer,timestamp without time zone,uuid)', 'EXECUTE')
  AND has_function_privilege('service_role', 'public.list_own_conversation_messages_core(uuid,uuid,integer,timestamp without time zone,uuid)', 'EXECUTE'),
  'only backend service role can invoke canonical message reads'
);
SELECT is(
  (SELECT count(*)::bigint FROM pg_catalog.pg_proc AS procedure
   JOIN pg_catalog.pg_namespace AS namespace ON namespace.oid = procedure.pronamespace
   WHERE namespace.nspname = 'public'
     AND procedure.proname IN ('send_user_message_core', 'list_own_conversation_messages_core')
     AND procedure.prosecdef),
  0::bigint,
  'message RPCs remain SECURITY INVOKER'
);

INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, created_at, updated_at) VALUES
  ('f13d0000-0000-4000-8000-000000000001','00000000-0000-0000-0000-000000000000','authenticated','authenticated','foundation_013d_owner@example.invalid','',now(),now()),
  ('f13d0000-0000-4000-8000-000000000002','00000000-0000-0000-0000-000000000000','authenticated','authenticated','foundation_013d_other@example.invalid','',now(),now());
INSERT INTO public.users (id, display_name) VALUES
  ('f13d0000-0000-4000-8000-000000000001','foundation_013d_owner'),
  ('f13d0000-0000-4000-8000-000000000002','foundation_013d_other');
INSERT INTO public.specialists (id,name,category,prompt_template,is_premium,is_active)
VALUES ('f13d1000-0000-4000-8000-000000000001','foundation_013d_specialist','mental','{}',false,true);
INSERT INTO public.chat_sessions (
  id,user_id,specialist_id,started_at,last_message_at,status,message_count,archived_at
) VALUES
  ('f13d2000-0000-4000-8000-000000000001','f13d0000-0000-4000-8000-000000000001','f13d1000-0000-4000-8000-000000000001','2026-07-17 09:00:00','2026-07-17 09:00:00','active',0,NULL),
  ('f13d2000-0000-4000-8000-000000000002','f13d0000-0000-4000-8000-000000000002','f13d1000-0000-4000-8000-000000000001','2026-07-17 09:00:00','2026-07-17 09:00:00','active',0,NULL);

SELECT throws_ok(
  $$INSERT INTO public.messages(session_id,role,content,author_type,provenance_type,visibility_type)
    VALUES ('f13d2000-0000-4000-8000-000000000001','user','bad','forged','userProvided','productVisible')$$,
  '23514', NULL, 'closed author constraint rejects unknown values'
);
SELECT throws_ok(
  $$INSERT INTO public.messages(session_id,role,content,author_type,provenance_type,visibility_type)
    VALUES ('f13d2000-0000-4000-8000-000000000001','user','bad','user','modelGenerated','productVisible')$$,
  '23514', NULL, 'closed provenance constraint rejects unknown values'
);
SELECT throws_ok(
  $$INSERT INTO public.messages(session_id,role,content,author_type,provenance_type,visibility_type)
    VALUES ('f13d2000-0000-4000-8000-000000000001','user','bad','user','userProvided','public')$$,
  '23514', NULL, 'closed visibility constraint rejects unknown values'
);
SELECT throws_ok(
  $$INSERT INTO public.messages(session_id,role,content,author_type,provenance_type,visibility_type)
    VALUES ('f13d2000-0000-4000-8000-000000000001','assistant','bad','stasis','unknown','productVisible')$$,
  '23514', NULL, 'positive author and provenance must be coherent'
);

SET LOCAL ROLE service_role;
CREATE TEMPORARY TABLE foundation_013d_send_first AS
SELECT * FROM public.send_user_message_core(
  'f13d2000-0000-4000-8000-000000000001',
  'f13d0000-0000-4000-8000-000000000001',
  'Synthetic owner message', 'foundation_013d_send_0001'
);
CREATE TEMPORARY TABLE foundation_013d_send_replay AS
SELECT * FROM public.send_user_message_core(
  'f13d2000-0000-4000-8000-000000000001',
  'f13d0000-0000-4000-8000-000000000001',
  'Synthetic owner message', 'foundation_013d_send_0001'
);
RESET ROLE;

SELECT is((SELECT author_type FROM foundation_013d_send_first), 'user',
  'send establishes user author backend-side');
SELECT is((SELECT provenance_type FROM foundation_013d_send_first), 'userProvided',
  'send establishes user provenance backend-side');
SELECT is((SELECT visibility_type FROM foundation_013d_send_first), 'productVisible',
  'send establishes Product visibility backend-side');
SELECT is((SELECT message_status FROM foundation_013d_send_first), 'accepted',
  'persisted user message is accepted');
SELECT ok(
  (SELECT message_id FROM foundation_013d_send_first) =
    (SELECT message_id FROM foundation_013d_send_replay)
  AND (SELECT idempotent_replay FROM foundation_013d_send_replay),
  'idempotent replay preserves identity and canonical metadata'
);

INSERT INTO public.messages (
  id,session_id,role,content,created_at,author_type,provenance_type,visibility_type
) VALUES
  ('f13d3000-0000-4000-8000-000000000001','f13d2000-0000-4000-8000-000000000001','assistant','INTERNAL_ASSISTANT','2026-07-17 10:00:00','unknown','unknown','unknown'),
  ('f13d3000-0000-4000-8000-000000000002','f13d2000-0000-4000-8000-000000000001','tool','INTERNAL_TOOL','2026-07-17 10:01:00','unknown','unknown','internal'),
  ('f13d3000-0000-4000-8000-000000000003','f13d2000-0000-4000-8000-000000000001','system','Safe notice','2026-07-17 10:02:00','systemNotice','systemGenerated','systemVisible'),
  ('f13d3000-0000-4000-8000-000000000004','f13d2000-0000-4000-8000-000000000001','user','SECRET_REDACTED','2026-07-17 10:03:00','user','userProvided','redacted'),
  ('f13d3000-0000-4000-8000-000000000005','f13d2000-0000-4000-8000-000000000001','user','Visible after hidden','2026-07-17 10:04:00','user','userProvided','productVisible'),
  ('f13d3000-0000-4000-8000-000000000006','f13d2000-0000-4000-8000-000000000002','user','Foreign private','2026-07-17 10:05:00','user','userProvided','productVisible');

SELECT is(
  (SELECT author_type || '|' || provenance_type || '|' || visibility_type
   FROM public.messages WHERE id = 'f13d3000-0000-4000-8000-000000000001'),
  'unknown|unknown|unknown',
  'unverified assistant is not mapped to Stasis'
);
SELECT is(
  (SELECT author_type || '|' || visibility_type
   FROM public.messages WHERE id = 'f13d3000-0000-4000-8000-000000000002'),
  'unknown|internal',
  'tool record is not Product-visible or specialist-authored'
);

SET LOCAL ROLE service_role;
CREATE TEMPORARY TABLE foundation_013d_visible AS
SELECT * FROM public.list_own_conversation_messages_core(
  'f13d0000-0000-4000-8000-000000000001',
  'f13d2000-0000-4000-8000-000000000001', 101, NULL, NULL
);
RESET ROLE;

SELECT is((SELECT count(*)::bigint FROM foundation_013d_visible
  WHERE content IN ('INTERNAL_ASSISTANT','INTERNAL_TOOL')), 0::bigint,
  'unknown and internal content is filtered in SQL');
SELECT is((SELECT count(*)::bigint FROM foundation_013d_visible
  WHERE visibility_type = 'systemVisible' AND content = 'Safe notice'), 1::bigint,
  'supported safe system notice is visible to owner');
SELECT ok((SELECT content IS NULL AND message_status = 'redacted'
  FROM foundation_013d_visible WHERE visibility_type = 'redacted'),
  'redacted row never returns original content');
SELECT is((SELECT count(*)::bigint FROM foundation_013d_visible
  WHERE content = 'Foreign private'), 0::bigint,
  'foreign Conversation content is not returned');

SET LOCAL ROLE service_role;
CREATE TEMPORARY TABLE foundation_013d_page_one AS
SELECT * FROM public.list_own_conversation_messages_core(
  'f13d0000-0000-4000-8000-000000000001',
  'f13d2000-0000-4000-8000-000000000001', 2, NULL, NULL
);
CREATE TEMPORARY TABLE foundation_013d_page_two AS
SELECT * FROM public.list_own_conversation_messages_core(
  'f13d0000-0000-4000-8000-000000000001',
  'f13d2000-0000-4000-8000-000000000001', 10,
  (SELECT created_at FROM foundation_013d_page_one ORDER BY created_at DESC, message_id DESC LIMIT 1),
  (SELECT message_id FROM foundation_013d_page_one ORDER BY created_at DESC, message_id DESC LIMIT 1)
);
RESET ROLE;
SELECT is(
  (SELECT count(*) FROM (
    SELECT message_id FROM foundation_013d_page_one
    INTERSECT SELECT message_id FROM foundation_013d_page_two
  ) AS duplicate), 0::bigint,
  'pagination over the SQL-visible stream has no duplicates'
);
SELECT ok(EXISTS (SELECT 1 FROM foundation_013d_page_two WHERE content = 'Visible after hidden'),
  'pagination advances across hidden physical rows without empty loops');

UPDATE public.chat_sessions SET status = 'archived', archived_at = now()
WHERE id = 'f13d2000-0000-4000-8000-000000000001';
SET LOCAL ROLE service_role;
SELECT lives_ok(
  $$SELECT * FROM public.list_own_conversation_messages_core(
    'f13d0000-0000-4000-8000-000000000001',
    'f13d2000-0000-4000-8000-000000000001', 10, NULL, NULL)$$,
  'archived owner history remains readable'
);
SELECT throws_ok(
  $$SELECT * FROM public.list_own_conversation_messages_core(
    'f13d0000-0000-4000-8000-000000000002',
    'f13d2000-0000-4000-8000-000000000001', 10, NULL, NULL)$$,
  'P0001', 'session_not_found', 'foreign owner receives opaque not found'
);
RESET ROLE;

SELECT * FROM finish();
ROLLBACK;

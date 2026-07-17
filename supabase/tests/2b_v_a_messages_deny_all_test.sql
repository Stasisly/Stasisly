begin;

create extension if not exists pgtap with schema extensions;

select plan(57);

select has_table('public', 'messages', 'messages exists');

select is(
  (
    select array_agg(a.attname order by a.attnum)::text
    from pg_catalog.pg_attribute a
    where a.attrelid = 'public.messages'::regclass
      and a.attnum > 0 and not a.attisdropped
  ),
  '{id,session_id,role,content,attachments,created_at}',
  'messages has exactly the expected columns'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_attribute a
    where a.attrelid = 'public.messages'::regclass
      and a.attnum > 0 and not a.attisdropped and a.attnotnull
  ),
  5::bigint,
  'id, session_id, role, content and created_at are NOT NULL'
);

select ok(
  not (
    select a.attnotnull
    from pg_catalog.pg_attribute a
    where a.attrelid = 'public.messages'::regclass
      and a.attname = 'attachments'
  ),
  'attachments remains nullable but constrained to NULL for MVP'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_attribute a
    where a.attrelid = 'public.messages'::regclass
      and a.attname in ('id', 'session_id')
      and pg_catalog.format_type(a.atttypid, a.atttypmod) = 'uuid'
  ),
  2::bigint,
  'message identifiers are UUID'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_attribute a
    where a.attrelid = 'public.messages'::regclass
      and a.attname in ('role', 'content')
      and pg_catalog.format_type(a.atttypid, a.atttypmod) = 'text'
  ),
  2::bigint,
  'role and content remain TEXT'
);

select is(
  (
    select pg_catalog.format_type(a.atttypid, a.atttypmod)
    from pg_catalog.pg_attribute a
    where a.attrelid = 'public.messages'::regclass
      and a.attname = 'attachments'
  ),
  'jsonb',
  'attachments remains JSONB'
);

select is(
  (
    select pg_catalog.format_type(a.atttypid, a.atttypmod)
    from pg_catalog.pg_attribute a
    where a.attrelid = 'public.messages'::regclass
      and a.attname = 'created_at'
  ),
  'timestamp without time zone',
  'created_at keeps its approved historical type'
);

select ok(
  (
    select pg_get_expr(d.adbin, d.adrelid) like '%uuid_generate_v4%'
    from pg_catalog.pg_attrdef d
    join pg_catalog.pg_attribute a
      on a.attrelid = d.adrelid and a.attnum = d.adnum
    where d.adrelid = 'public.messages'::regclass
      and a.attname = 'id'
  ),
  'id default generates UUID'
);

select is(
  (
    select pg_get_expr(d.adbin, d.adrelid)
    from pg_catalog.pg_attrdef d
    join pg_catalog.pg_attribute a
      on a.attrelid = d.adrelid and a.attnum = d.adnum
    where d.adrelid = 'public.messages'::regclass
      and a.attname = 'created_at'
  ),
  'now()',
  'created_at defaults to now()'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_constraint
    where conrelid = 'public.messages'::regclass
      and contype = 'f'
      and confrelid = 'public.chat_sessions'::regclass
  ),
  1::bigint,
  'session foreign key remains present'
);

select ok(
  exists (
    select 1
    from pg_catalog.pg_constraint
    where conrelid = 'public.messages'::regclass
      and conname = 'messages_role_valid'
      and pg_get_constraintdef(oid)
        = 'CHECK ((role = ANY (ARRAY[''user''::text, ''assistant''::text, ''system''::text, ''tool''::text])))'
  ),
  'role constraint allows only approved internal roles'
);
select ok(
  exists (
    select 1
    from pg_catalog.pg_constraint
    where conrelid = 'public.messages'::regclass
      and conname = 'messages_content_not_blank'
  ),
  'content not blank constraint exists'
);
select ok(
  exists (
    select 1
    from pg_catalog.pg_constraint
    where conrelid = 'public.messages'::regclass
      and conname = 'messages_content_max_length'
  ),
  'content max length constraint exists'
);
select ok(
  exists (
    select 1
    from pg_catalog.pg_constraint
    where conrelid = 'public.messages'::regclass
      and conname = 'messages_attachments_null_mvp'
  ),
  'attachments must remain NULL in MVP constraint exists'
);
select ok(
  not exists (
    select 1
    from pg_catalog.pg_constraint
    where conrelid = 'public.messages'::regclass
      and pg_get_constraintdef(oid) like '%chief_intervention%'
  ),
  'chief_intervention is not allowed by any messages constraint'
);

select has_index(
  'public', 'messages', 'idx_messages_session_created_id',
  'stable session message listing index exists'
);
select is(
  (
    select pg_get_indexdef(i.indexrelid)
    from pg_catalog.pg_index i
    join pg_catalog.pg_class c on c.oid = i.indexrelid
    where c.relname = 'idx_messages_session_created_id'
  ),
  'CREATE INDEX idx_messages_session_created_id ON public.messages USING btree (session_id, created_at, id)',
  'stable session message listing index has the exact approved shape'
);
select ok(
  to_regclass('public.idx_messages_session') is null,
  'historical simple session index was replaced'
);

select ok(
  (
    select c.relrowsecurity and not c.relforcerowsecurity
    from pg_catalog.pg_class c
    where c.oid = 'public.messages'::regclass
  ),
  'messages has RLS enabled without FORCE RLS'
);
select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_policies
    where schemaname = 'public' and tablename = 'messages'
  ),
  0::bigint,
  'messages has zero policies'
);
select ok(
  not has_table_privilege('anon', 'public.messages', 'SELECT')
    and not has_table_privilege('anon', 'public.messages', 'INSERT')
    and not has_table_privilege('anon', 'public.messages', 'UPDATE')
    and not has_table_privilege('anon', 'public.messages', 'DELETE'),
  'anon has zero CRUD privileges on messages'
);
select ok(
  not has_table_privilege('authenticated', 'public.messages', 'SELECT')
    and not has_table_privilege('authenticated', 'public.messages', 'INSERT')
    and not has_table_privilege('authenticated', 'public.messages', 'UPDATE')
    and not has_table_privilege('authenticated', 'public.messages', 'DELETE'),
  'authenticated has zero CRUD privileges on messages'
);
select ok(
  not has_any_column_privilege('anon', 'public.messages', 'SELECT')
    and not has_any_column_privilege('anon', 'public.messages', 'UPDATE'),
  'anon has zero column privileges on messages'
);
select ok(
  not has_any_column_privilege('authenticated', 'public.messages', 'SELECT')
    and not has_any_column_privilege('authenticated', 'public.messages', 'UPDATE'),
  'authenticated has zero column privileges on messages'
);

select is(
  (
    select count(*)::bigint
    from public.messages
  ),
  0::bigint,
  'messages remains empty after migration'
);

insert into auth.users (
  id, instance_id, aud, role, email, encrypted_password, created_at, updated_at
) values (
  '11000000-0000-4000-8000-000000000001',
  '00000000-0000-0000-0000-000000000000',
  'authenticated',
  'authenticated',
  '2b-v-a@example.invalid',
  '',
  now(),
  now()
);
insert into public.users (id, display_name)
values ('11000000-0000-4000-8000-000000000001', '2B-V-A fixture');
insert into public.specialists (id, name, category, prompt_template)
values (
  '22000000-0000-4000-8000-000000000001',
  '2B-V-A fixture',
  'salud',
  '{"system":"test_only"}'
);
insert into public.chat_sessions (
  id, user_id, specialist_id, started_at, last_message_at, status, archived_at
) values (
  '33000000-0000-4000-8000-000000000001',
  '11000000-0000-4000-8000-000000000001',
  '22000000-0000-4000-8000-000000000001',
  '2026-06-15 10:00:00',
  '2026-06-15 10:00:00',
  'active',
  null
), (
  '33000000-0000-4000-8000-000000000002',
  '11000000-0000-4000-8000-000000000001',
  '22000000-0000-4000-8000-000000000001',
  '2026-06-15 11:00:00',
  '2026-06-15 11:00:00',
  'archived',
  '2026-06-15 11:30:00'
);

select lives_ok(
  $$insert into public.messages (
      id, session_id, role, content
    ) values (
      '44000000-0000-4000-8000-000000000001',
      '33000000-0000-4000-8000-000000000001',
      'user',
      'Valid user message'
    )$$,
  'valid server-side user message is accepted'
);
select lives_ok(
  $$insert into public.messages (
      id, session_id, role, content
    ) values (
      '44000000-0000-4000-8000-000000000002',
      '33000000-0000-4000-8000-000000000001',
      'assistant',
      'Valid future assistant message from backend'
    )$$,
  'valid internal assistant role is accepted server-side'
);
select lives_ok(
  $$insert into public.messages (
      id, session_id, role, content
    ) values (
      '44000000-0000-4000-8000-000000000003',
      '33000000-0000-4000-8000-000000000001',
      'system',
      'Valid future system message from backend'
    )$$,
  'valid internal system role is accepted server-side'
);
select lives_ok(
  $$insert into public.messages (
      id, session_id, role, content
    ) values (
      '44000000-0000-4000-8000-000000000004',
      '33000000-0000-4000-8000-000000000001',
      'tool',
      'Valid future tool message from backend'
    )$$,
  'valid internal tool role is accepted server-side'
);
select is(
  (
    select attachments
    from public.messages
    where id = '44000000-0000-4000-8000-000000000001'
  ),
  null,
  'attachments default to NULL'
);
select isnt(
  (
    select created_at
    from public.messages
    where id = '44000000-0000-4000-8000-000000000001'
  ),
  null,
  'created_at default is populated'
);

select throws_ok(
  $$insert into public.messages (role, content)
    values ('user', 'Missing session')$$,
  '23502', null, 'session_id NOT NULL rejects missing session'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content, created_at)
    values (
      '33000000-0000-4000-8000-000000000001',
      'user',
      'Missing created_at',
      null
    )$$,
  '23502', null, 'created_at NOT NULL rejects null timestamp'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '33000000-0000-4000-8000-000000000001',
      'user',
      null
    )$$,
  '23502', null, 'content NOT NULL rejects null content'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '33000000-0000-4000-8000-000000000001',
      'user',
      ''
    )$$,
  '23514', null, 'empty content is rejected'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '33000000-0000-4000-8000-000000000001',
      'user',
      '     '
    )$$,
  '23514', null, 'whitespace-only content is rejected'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '33000000-0000-4000-8000-000000000001',
      'user',
      repeat('x', 4001)
    )$$,
  '23514', null, 'content longer than 4000 characters is rejected'
);
select lives_ok(
  $$insert into public.messages (
      id, session_id, role, content
    ) values (
      '44000000-0000-4000-8000-000000000005',
      '33000000-0000-4000-8000-000000000001',
      'user',
      repeat('x', 4000)
    )$$,
  'content with exactly 4000 characters is accepted'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '33000000-0000-4000-8000-000000000001',
      'admin',
      'Spoofed role'
    )$$,
  '23514', null, 'invalid role is rejected'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '33000000-0000-4000-8000-000000000001',
      'chief_intervention',
      'Legacy role'
    )$$,
  '23514', null, 'legacy chief_intervention role is rejected'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content, attachments)
    values (
      '33000000-0000-4000-8000-000000000001',
      'user',
      'Attachment attempt',
      '{"type":"pdf"}'
    )$$,
  '23514', null, 'attachments are blocked in MVP'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '99999999-0000-4000-8000-000000000001',
      'user',
      'Missing session'
    )$$,
  '23503', null, 'foreign key rejects missing session'
);

select is(
  (
    select count(*)::bigint
    from public.chat_sessions
    where id in (
      '33000000-0000-4000-8000-000000000001',
      '33000000-0000-4000-8000-000000000002'
    )
  ),
  2::bigint,
  'chat_sessions fixtures remain present'
);
select is(
  (
    select message_count
    from public.chat_sessions
    where id = '33000000-0000-4000-8000-000000000001'
  ),
  0,
  'message_count remains server-managed and is not changed by 2B-V-A'
);
select is(
  (
    select last_message_at
    from public.chat_sessions
    where id = '33000000-0000-4000-8000-000000000001'
  ),
  '2026-06-15 10:00:00'::timestamp,
  'last_message_at remains server-managed and is not changed by 2B-V-A'
);

set local role anon;
select throws_ok(
  $$select * from public.messages$$,
  '42501', null, 'anon cannot SELECT messages'
);
select throws_ok(
  $$insert into public.messages default values$$,
  '42501', null, 'anon cannot INSERT messages'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '33000000-0000-4000-8000-000000000002',
      'user',
      'Archived session attempt'
    )$$,
  '42501', null, 'anon cannot write messages even for archived sessions'
);
select throws_ok(
  $$update public.messages set content = 'Changed'$$,
  '42501', null, 'anon cannot UPDATE messages'
);
select throws_ok(
  $$delete from public.messages$$,
  '42501', null, 'anon cannot DELETE messages'
);

reset role;
set local role authenticated;
select throws_ok(
  $$select * from public.messages$$,
  '42501', null, 'authenticated cannot SELECT messages'
);
select throws_ok(
  $$insert into public.messages default values$$,
  '42501', null, 'authenticated cannot INSERT messages'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '33000000-0000-4000-8000-000000000001',
      'assistant',
      'Spoofed assistant'
    )$$,
  '42501', null, 'authenticated cannot spoof assistant role'
);
select throws_ok(
  $$insert into public.messages (session_id, role, content)
    values (
      '33000000-0000-4000-8000-000000000002',
      'user',
      'Archived session attempt'
    )$$,
  '42501', null, 'authenticated cannot write messages even for archived sessions'
);
select throws_ok(
  $$update public.messages set content = 'Changed'$$,
  '42501', null, 'authenticated cannot UPDATE messages'
);
select throws_ok(
  $$delete from public.messages$$,
  '42501', null, 'authenticated cannot DELETE messages'
);
reset role;

select * from finish();

rollback;

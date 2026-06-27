begin;

create extension if not exists pgtap with schema extensions;

select plan(40);

select has_table('public', 'chat_sessions', 'chat_sessions exists');

select is(
  (
    select array_agg(a.attname order by a.attnum)::text
    from pg_catalog.pg_attribute a
    where a.attrelid = 'public.chat_sessions'::regclass
      and a.attnum > 0 and not a.attisdropped
  ),
  '{id,user_id,specialist_id,started_at,last_message_at,status,message_count}',
  'chat_sessions has exactly the expected columns'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_attribute a
    where a.attrelid = 'public.chat_sessions'::regclass
      and a.attnum > 0 and not a.attisdropped and a.attnotnull
  ),
  7::bigint,
  'all chat_sessions columns are NOT NULL'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_attribute a
    where a.attrelid = 'public.chat_sessions'::regclass
      and a.attname in ('id', 'user_id', 'specialist_id')
      and pg_catalog.format_type(a.atttypid, a.atttypmod) = 'uuid'
  ),
  3::bigint,
  'identity columns remain UUID'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_attribute a
    where a.attrelid = 'public.chat_sessions'::regclass
      and a.attname in ('started_at', 'last_message_at')
      and pg_catalog.format_type(a.atttypid, a.atttypmod)
        = 'timestamp without time zone'
  ),
  2::bigint,
  'timestamps keep their approved historical type'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_attrdef d
    join pg_catalog.pg_attribute a
      on a.attrelid = d.adrelid and a.attnum = d.adnum
    where d.adrelid = 'public.chat_sessions'::regclass
      and a.attname in ('started_at', 'last_message_at')
      and pg_get_expr(d.adbin, d.adrelid) = 'now()'
  ),
  2::bigint,
  'timestamps default to now()'
);

select is(
  (
    select pg_get_expr(d.adbin, d.adrelid)
    from pg_catalog.pg_attrdef d
    join pg_catalog.pg_attribute a
      on a.attrelid = d.adrelid and a.attnum = d.adnum
    where d.adrelid = 'public.chat_sessions'::regclass
      and a.attname = 'status'
  ),
  '''active''::text',
  'status defaults to active'
);

select is(
  (
    select pg_get_expr(d.adbin, d.adrelid)
    from pg_catalog.pg_attrdef d
    join pg_catalog.pg_attribute a
      on a.attrelid = d.adrelid and a.attnum = d.adnum
    where d.adrelid = 'public.chat_sessions'::regclass
      and a.attname = 'message_count'
  ),
  '0',
  'message_count defaults to zero'
);

select ok(
  exists (
    select 1 from pg_catalog.pg_constraint
    where conrelid = 'public.chat_sessions'::regclass
      and conname = 'chat_sessions_status_valid' and contype = 'c'
  ),
  'status constraint exists'
);
select ok(
  exists (
    select 1 from pg_catalog.pg_constraint
    where conrelid = 'public.chat_sessions'::regclass
      and conname = 'chat_sessions_message_count_nonnegative' and contype = 'c'
  ),
  'message_count constraint exists'
);
select ok(
  exists (
    select 1 from pg_catalog.pg_constraint
    where conrelid = 'public.chat_sessions'::regclass
      and conname = 'chat_sessions_chronology_valid' and contype = 'c'
  ),
  'chronology constraint exists'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_constraint
    where conrelid = 'public.chat_sessions'::regclass
      and contype = 'f'
      and confrelid in ('public.users'::regclass, 'public.specialists'::regclass)
  ),
  2::bigint,
  'approved foreign keys remain present'
);

select has_index(
  'public', 'chat_sessions', 'idx_chat_sessions_owner_listing',
  'owner listing index exists'
);
select is(
  (
    select pg_get_indexdef(i.indexrelid)
    from pg_catalog.pg_index i
    join pg_catalog.pg_class c on c.oid = i.indexrelid
    where c.relname = 'idx_chat_sessions_owner_listing'
  ),
  'CREATE INDEX idx_chat_sessions_owner_listing ON public.chat_sessions USING btree (user_id, last_message_at DESC, id DESC)',
  'owner listing index has the exact approved shape'
);
select ok(
  to_regclass('public.idx_chat_sessions_user') is null,
  'historical simple owner index was replaced'
);

select ok(
  (
    select c.relrowsecurity and not c.relforcerowsecurity
    from pg_catalog.pg_class c
    where c.oid = 'public.chat_sessions'::regclass
  ),
  'chat_sessions has RLS enabled without FORCE RLS'
);
select is(
  (
    select count(*)::bigint from pg_catalog.pg_policies
    where schemaname = 'public' and tablename = 'chat_sessions'
  ),
  0::bigint,
  'chat_sessions has zero policies'
);
select ok(
  not has_table_privilege('anon', 'public.chat_sessions', 'SELECT')
    and not has_table_privilege('anon', 'public.chat_sessions', 'INSERT')
    and not has_table_privilege('anon', 'public.chat_sessions', 'UPDATE')
    and not has_table_privilege('anon', 'public.chat_sessions', 'DELETE'),
  'anon has zero CRUD privileges'
);
select ok(
  not has_table_privilege('authenticated', 'public.chat_sessions', 'SELECT')
    and not has_table_privilege('authenticated', 'public.chat_sessions', 'INSERT')
    and not has_table_privilege('authenticated', 'public.chat_sessions', 'UPDATE')
    and not has_table_privilege('authenticated', 'public.chat_sessions', 'DELETE'),
  'authenticated has zero CRUD privileges'
);

select is(
  (
    select array_agg(a.attname order by a.attnum)::text
    from pg_catalog.pg_attribute a
    where a.attrelid = 'public.messages'::regclass
      and a.attnum > 0 and not a.attisdropped
  ),
  '{id,session_id,role,content,attachments,created_at}',
  'messages columns remain intact'
);
select ok(
  (
    select c.relrowsecurity and not c.relforcerowsecurity
    from pg_catalog.pg_class c where c.oid = 'public.messages'::regclass
  ),
  'messages has deny-all RLS after 2B-V-A'
);
select is(
  (
    select count(*)::bigint from pg_catalog.pg_policies
    where schemaname = 'public' and tablename = 'messages'
  ),
  0::bigint,
  'messages policies remain unchanged'
);

insert into auth.users (
  id, instance_id, aud, role, email, encrypted_password, created_at, updated_at
) values (
  '10000000-0000-4000-8000-000000000001',
  '00000000-0000-0000-0000-000000000000',
  'authenticated',
  'authenticated',
  '2b-iv-a@example.invalid',
  '',
  now(),
  now()
);
insert into public.users (id, display_name)
values ('10000000-0000-4000-8000-000000000001', '2B-IV-A fixture');
insert into public.specialists (id, name, category, prompt_template)
values (
  '20000000-0000-4000-8000-000000000001',
  '2B-IV-A fixture',
  'salud',
  '{"system":"test_only"}'
);

select lives_ok(
  $$insert into public.chat_sessions (
      id, user_id, specialist_id, started_at, last_message_at
    ) values (
      '30000000-0000-4000-8000-000000000001',
      '10000000-0000-4000-8000-000000000001',
      '20000000-0000-4000-8000-000000000001',
      '2026-06-14 10:00:00',
      '2026-06-14 10:00:00'
    )$$,
  'valid server-side fixture accepts approved defaults'
);
select is(
  (select status from public.chat_sessions
    where id = '30000000-0000-4000-8000-000000000001'),
  'active',
  'valid fixture defaults status to active'
);
select is(
  (select message_count from public.chat_sessions
    where id = '30000000-0000-4000-8000-000000000001'),
  0,
  'valid fixture defaults message_count to zero'
);

select throws_ok(
  $$update public.chat_sessions set status = 'deleted'
    where id = '30000000-0000-4000-8000-000000000001'$$,
  '23514', null, 'unapproved status is rejected'
);
select throws_ok(
  $$update public.chat_sessions set message_count = -1
    where id = '30000000-0000-4000-8000-000000000001'$$,
  '23514', null, 'negative message_count is rejected'
);
select throws_ok(
  $$update public.chat_sessions set last_message_at = '2026-06-14 09:59:59'
    where id = '30000000-0000-4000-8000-000000000001'$$,
  '23514', null, 'last_message_at before started_at is rejected'
);
select throws_ok(
  $$update public.chat_sessions set user_id = null
    where id = '30000000-0000-4000-8000-000000000001'$$,
  '23502', null, 'null owner is rejected'
);
select throws_ok(
  $$update public.chat_sessions set specialist_id = null
    where id = '30000000-0000-4000-8000-000000000001'$$,
  '23502', null, 'null specialist is rejected'
);
select throws_ok(
  $$update public.chat_sessions set status = null
    where id = '30000000-0000-4000-8000-000000000001'$$,
  '23502', null, 'null status is rejected'
);
select throws_ok(
  $$update public.chat_sessions set message_count = null
    where id = '30000000-0000-4000-8000-000000000001'$$,
  '23502', null, 'null message_count is rejected'
);

set local role anon;
select throws_ok(
  $$select * from public.chat_sessions$$,
  '42501', null, 'anon cannot SELECT chat_sessions'
);
select throws_ok(
  $$insert into public.chat_sessions default values$$,
  '42501', null, 'anon cannot INSERT chat_sessions'
);
select throws_ok(
  $$update public.chat_sessions set status = 'archived'$$,
  '42501', null, 'anon cannot UPDATE chat_sessions'
);
select throws_ok(
  $$delete from public.chat_sessions$$,
  '42501', null, 'anon cannot DELETE chat_sessions'
);

reset role;
set local role authenticated;
select throws_ok(
  $$select * from public.chat_sessions$$,
  '42501', null, 'authenticated cannot SELECT chat_sessions'
);
select throws_ok(
  $$insert into public.chat_sessions default values$$,
  '42501', null, 'authenticated cannot INSERT chat_sessions'
);
select throws_ok(
  $$update public.chat_sessions set status = 'archived'$$,
  '42501', null, 'authenticated cannot UPDATE chat_sessions'
);
select throws_ok(
  $$delete from public.chat_sessions$$,
  '42501', null, 'authenticated cannot DELETE chat_sessions'
);
reset role;

select * from finish();

rollback;

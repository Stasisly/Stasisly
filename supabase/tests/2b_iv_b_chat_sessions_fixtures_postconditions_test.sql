begin;

create extension if not exists pgtap with schema extensions;

select plan(8);

select is(
  (select count(*)::bigint from auth.users
    where email like '%test_only_2b_iv_b%'),
  0::bigint,
  'zero 2B-IV-B Auth user fixtures persist after rollback'
);
select is(
  (select count(*)::bigint from public.users
    where display_name like '%test_only_2b_iv_b%'),
  0::bigint,
  'zero 2B-IV-B public user fixtures persist after rollback'
);
select is(
  (select count(*)::bigint from public.specialists
    where name like '%test_only_2b_iv_b%'),
  0::bigint,
  'zero 2B-IV-B specialist fixtures persist after rollback'
);
select is(
  (select count(*)::bigint from public.specialist_catalog
    where display_name like '%test_only_2b_iv_b%'),
  0::bigint,
  'zero 2B-IV-B catalog fixtures persist after rollback'
);
select is(
  (select count(*)::bigint from public.chat_sessions
    where id::text like '44000000-0000-4000-8000-%'),
  0::bigint,
  'zero 2B-IV-B chat session fixtures persist after rollback'
);
select is(
  (select count(*)::bigint from public.messages),
  0::bigint,
  'messages remains empty after rollback'
);
select ok(
  (
    select c.relrowsecurity and not c.relforcerowsecurity
    from pg_catalog.pg_class c
    where c.oid = 'public.chat_sessions'::regclass
  ),
  'chat_sessions deny-all base remains after rollback'
);
select is(
  (select count(*)::bigint from pg_catalog.pg_policies
    where schemaname = 'public' and tablename = 'chat_sessions'),
  0::bigint,
  'chat_sessions still has zero policies after rollback'
);

select * from finish();

rollback;

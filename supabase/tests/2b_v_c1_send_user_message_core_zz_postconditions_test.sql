begin;

create extension if not exists pgtap with schema extensions;

select plan(8);

select is(
  (select count(*)::bigint from auth.users
    where email like '%test_only_2b_v_c1%'),
  0::bigint,
  'no C1 Auth fixtures persisted after rollback'
);
select is(
  (select count(*)::bigint from public.users
    where display_name like '%test_only_2b_v_c1%'),
  0::bigint,
  'no C1 public user fixtures persisted after rollback'
);
select is(
  (select count(*)::bigint from public.specialists
    where name like '%test_only_2b_v_c1%'),
  0::bigint,
  'no C1 specialist fixtures persisted after rollback'
);
select is(
  (select count(*)::bigint from public.specialist_catalog
    where display_name like '%test_only_2b_v_c1%'),
  0::bigint,
  'no C1 catalog fixtures persisted after rollback'
);
select is(
  (select count(*)::bigint from public.chat_sessions
    where id::text like '74000000-0000-4000-8000-%'),
  0::bigint,
  'no C1 chat session fixtures persisted after rollback'
);
select is(
  (select count(*)::bigint from public.messages
    where session_id::text like '74000000-0000-4000-8000-%'),
  0::bigint,
  'no C1 message fixtures persisted after rollback'
);
select is(
  (
    select
      (select count(*) from auth.users where email like '%test_only_2b_v_c1%') || '|' ||
      (select count(*) from public.users where display_name like '%test_only_2b_v_c1%') || '|' ||
      (select count(*) from public.specialists where name like '%test_only_2b_v_c1%') || '|' ||
      (select count(*) from public.specialist_catalog where display_name like '%test_only_2b_v_c1%') || '|' ||
      (select count(*) from public.chat_sessions where id::text like '74000000-0000-4000-8000-%') || '|' ||
      (select count(*) from public.messages where session_id::text like '74000000-0000-4000-8000-%')
  ),
  '0|0|0|0|0|0',
  'C1 rollback postcondition is exactly 0|0|0|0|0|0'
);
select ok(
  not has_function_privilege(
    'anon',
    'public.send_user_message_core(uuid, uuid, text, text)',
    'EXECUTE'
  ) and not has_function_privilege(
    'authenticated',
    'public.send_user_message_core(uuid, uuid, text, text)',
    'EXECUTE'
  ),
  'client roles still cannot execute C1 RPC after rollback'
);

select * from finish();

rollback;

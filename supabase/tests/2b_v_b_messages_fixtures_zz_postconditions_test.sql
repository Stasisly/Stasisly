begin;

create extension if not exists pgtap with schema extensions;

select plan(7);

select is(
  (select count(*)::bigint from auth.users
    where email like '%test_only_2b_v_b%'),
  0::bigint,
  'no 2B-V-B Auth fixtures persisted after rollback'
);
select is(
  (select count(*)::bigint from public.users
    where display_name like '%test_only_2b_v_b%'),
  0::bigint,
  'no 2B-V-B public user fixtures persisted after rollback'
);
select is(
  (select count(*)::bigint from public.specialists
    where name like '%test_only_2b_v_b%'),
  0::bigint,
  'no 2B-V-B specialist fixtures persisted after rollback'
);
select is(
  (select count(*)::bigint from public.specialist_catalog
    where display_name like '%test_only_2b_v_b%'),
  0::bigint,
  'no 2B-V-B catalog fixtures persisted after rollback'
);
select is(
  (select count(*)::bigint from public.chat_sessions
    where id::text like '64000000-0000-4000-8000-%'),
  0::bigint,
  'no 2B-V-B chat session fixtures persisted after rollback'
);
select is(
  (select count(*)::bigint from public.messages
    where id::text like '65000000-0000-4000-8000-%'),
  0::bigint,
  'no 2B-V-B message fixtures persisted after rollback'
);
select is(
  (
    select
      (select count(*) from auth.users where email like '%test_only_2b_v_b%') || '|' ||
      (select count(*) from public.users where display_name like '%test_only_2b_v_b%') || '|' ||
      (select count(*) from public.specialists where name like '%test_only_2b_v_b%') || '|' ||
      (select count(*) from public.specialist_catalog where display_name like '%test_only_2b_v_b%') || '|' ||
      (select count(*) from public.chat_sessions where id::text like '64000000-0000-4000-8000-%') || '|' ||
      (select count(*) from public.messages where id::text like '65000000-0000-4000-8000-%')
  ),
  '0|0|0|0|0|0',
  '2B-V-B rollback postcondition is exactly 0|0|0|0|0|0'
);

select * from finish();

rollback;

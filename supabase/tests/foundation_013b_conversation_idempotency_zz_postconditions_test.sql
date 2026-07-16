begin;
create extension if not exists pgtap with schema extensions;
select plan(1);
select is(
  (
    select
      (select count(*) from auth.users where email like 'foundation_013b_%') || '|' ||
      (select count(*) from public.users where display_name like 'foundation_013b_%') || '|' ||
      (select count(*) from public.specialists where name like 'foundation_013b_%') || '|' ||
      (select count(*) from public.specialist_catalog where slug like 'foundation-013b-%') || '|' ||
      (select count(*) from public.chat_sessions where user_id::text like 'f1300000-%') || '|' ||
      (select count(*) from public.messages where content like 'Synthetic%') || '|' ||
      (select count(*) from public.conversation_idempotency where subject_id::text like 'f1300000-%')
  ),
  '0|0|0|0|0|0|0',
  'FOUNDATION-013B transaction rollback leaves zero fixtures and idempotency rows'
);
select * from finish();
rollback;

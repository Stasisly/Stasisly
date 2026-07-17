begin;
create extension if not exists pgtap with schema extensions;
select plan(1);
select is((select
  (select count(*) from auth.users where email like 'foundation_013c_%') || '|' ||
  (select count(*) from public.users where display_name like 'foundation_013c_%') || '|' ||
  (select count(*) from public.specialists where name like 'foundation_013c_%') || '|' ||
  (select count(*) from public.specialist_catalog where slug like 'foundation-013c%') || '|' ||
  (select count(*) from public.chat_sessions where id::text like 'f13c3%') || '|' ||
  (select count(*) from public.messages where id::text like 'f13c4%') || '|' ||
  (select count(*) from public.conversation_idempotency where subject_id::text like 'f13c%')),
  '0|0|0|0|0|0|0','FOUNDATION-013C rollback leaves seven zero fixture classes');
select * from finish();
rollback;

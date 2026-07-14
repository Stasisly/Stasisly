begin;

create extension if not exists pgtap with schema extensions;

select plan(4);

select is(
  (
    select count(*)::bigint
    from public.specialists
    where id::text like 'a1131000-0000-4000-8000-%'
      or name like 'test_only_ag113%'
  ),
  0::bigint,
  'AG113 internal specialist fixtures were rolled back'
);

select is(
  (
    select count(*)::bigint
    from public.specialist_catalog
    where slug like 'ag113-%'
      or id::text like 'a1132000-0000-4000-8000-%'
  ),
  0::bigint,
  'AG113 catalog fixtures were rolled back'
);

select is(
  (
    select count(*)::bigint
    from public.specialist_catalog
    where access_tier = 'premium'
  ),
  0::bigint,
  'no legacy premium rows persist after AG113'
);

select is(
  (
    select count(*)::bigint
    from public.specialist_catalog
    where access_tier not in ('free', 'pro', 'vip')
  ),
  0::bigint,
  'no non-canonical access_tier rows persist after AG113'
);

select * from finish();

rollback;

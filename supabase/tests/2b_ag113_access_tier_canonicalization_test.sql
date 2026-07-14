begin;

create extension if not exists pgtap with schema extensions;

select plan(14);

insert into public.specialists (
  id, name, category, prompt_template, is_premium, is_active
) values
  ('a1131000-0000-4000-8000-000000000001', 'test_only_ag113_free',
   'salud', '{"marker":"test_only_ag113"}', false, true),
  ('a1131000-0000-4000-8000-000000000002', 'test_only_ag113_pro',
   'salud', '{"marker":"test_only_ag113"}', true, true),
  ('a1131000-0000-4000-8000-000000000003', 'test_only_ag113_vip',
   'salud', '{"marker":"test_only_ag113"}', true, true),
  ('a1131000-0000-4000-8000-000000000004', 'test_only_ag113_invalid',
   'salud', '{"marker":"test_only_ag113"}', true, true);

select lives_ok(
  $$insert into public.specialist_catalog (
      id, specialist_id, slug, display_name, product_area, short_description,
      publication_status, is_published, availability_status, access_tier
    ) values (
      'a1132000-0000-4000-8000-000000000001',
      'a1131000-0000-4000-8000-000000000001',
      'ag113-free', 'AG113 Free', 'health',
      'Fixture local sintetico para tier free.',
      'published', true, 'available', 'free'
    )$$,
  'free is accepted as canonical access_tier'
);

select lives_ok(
  $$insert into public.specialist_catalog (
      id, specialist_id, slug, display_name, product_area, short_description,
      publication_status, is_published, availability_status, access_tier
    ) values (
      'a1132000-0000-4000-8000-000000000002',
      'a1131000-0000-4000-8000-000000000002',
      'ag113-pro', 'AG113 Pro', 'health',
      'Fixture local sintetico para tier pro.',
      'published', true, 'available', 'pro'
    )$$,
  'pro is accepted as canonical access_tier'
);

select lives_ok(
  $$insert into public.specialist_catalog (
      id, specialist_id, slug, display_name, product_area, short_description,
      publication_status, is_published, availability_status, access_tier
    ) values (
      'a1132000-0000-4000-8000-000000000003',
      'a1131000-0000-4000-8000-000000000003',
      'ag113-vip', 'AG113 VIP', 'health',
      'Fixture local sintetico para tier vip.',
      'published', true, 'available', 'vip'
    )$$,
  'vip is accepted as canonical access_tier'
);

select throws_ok(
  $$insert into public.specialist_catalog (
      specialist_id, slug, display_name, product_area, short_description,
      access_tier
    ) values (
      'a1131000-0000-4000-8000-000000000004',
      'ag113-premium', 'AG113 Premium', 'health',
      'Fixture local sintetico para tier legacy.', 'premium'
    )$$,
  '23514',
  null,
  'legacy premium is rejected for new catalog rows'
);

select throws_ok(
  $$insert into public.specialist_catalog (
      specialist_id, slug, display_name, product_area, short_description,
      access_tier
    ) values (
      'a1131000-0000-4000-8000-000000000004',
      'ag113-enterprise', 'AG113 Enterprise', 'health',
      'Fixture local sintetico para tier enterprise.', 'enterprise'
    )$$,
  '23514',
  null,
  'enterprise is rejected because Product access_tier is free/pro/vip'
);

select throws_ok(
  $$insert into public.specialist_catalog (
      specialist_id, slug, display_name, product_area, short_description,
      access_tier
    ) values (
      'a1131000-0000-4000-8000-000000000004',
      'ag113-internal', 'AG113 Internal', 'health',
      'Fixture local sintetico para tier internal.', 'internal'
    )$$,
  '23514',
  null,
  'unknown internal tier is rejected'
);

select throws_ok(
  $$update public.specialist_catalog
    set access_tier = 'premium'
    where slug = 'ag113-pro'$$,
  '23514',
  null,
  'existing rows cannot be changed to premium'
);

select set_eq(
  $$select access_tier from public.specialist_catalog
    where slug like 'ag113-%'$$,
  $$values ('free'), ('pro'), ('vip')$$,
  'only canonical access_tier values exist in AG113 fixtures'
);

select is(
  (
    select count(*)::bigint
    from public.specialist_catalog
    where access_tier = 'premium'
  ),
  0::bigint,
  'premium does not exist in catalog data after AG113 negative cases'
);

select is(
  (
    select count(*)::bigint
    from public.specialist_catalog
    where access_tier not in ('free', 'pro', 'vip')
  ),
  0::bigint,
  'no non-canonical access_tier exists after AG113 negative cases'
);

select ok(
  not has_table_privilege('anon', 'public.specialist_catalog', 'SELECT')
    and not has_table_privilege('authenticated', 'public.specialist_catalog', 'SELECT'),
  'client roles still cannot read specialist_catalog directly'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_policies
    where schemaname = 'public'
      and tablename = 'specialist_catalog'
  ),
  0::bigint,
  'specialist_catalog still has zero policies'
);

select is(
  (
    select count(*)::bigint
    from public.specialist_catalog
    where slug like 'ag113-%'
  ),
  3::bigint,
  'only three canonical AG113 fixtures exist before rollback'
);

select is(
  (
    select count(*)::bigint
    from public.specialists
    where id::text like 'a1131000-0000-4000-8000-%'
  ),
  4::bigint,
  'only four AG113 internal fixtures exist before rollback'
);

select * from finish();

rollback;

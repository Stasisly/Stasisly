begin;

create extension if not exists pgtap with schema extensions;

select plan(59);

select has_table(
  'public', 'specialist_catalog',
  'public.specialist_catalog exists after AG111 migration'
);

select is(
  (
    select array_agg(a.attname order by a.attnum)::text
    from pg_catalog.pg_attribute a
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname = 'specialist_catalog'
      and a.attnum > 0
      and not a.attisdropped
  ),
  '{id,specialist_id,display_name,product_area,short_description,is_published,availability_status,access_tier,sort_order,created_at,updated_at,slug,subcategory,public_capabilities,publication_status,supported_surfaces,locale,public_metadata,hierarchy_role,parent_catalog_id,is_conversable,published_at,unpublished_at}',
  'specialist_catalog has the AG111 approved columns in stable order'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_attribute a
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname = 'specialist_catalog'
      and a.attnum > 0
      and not a.attisdropped
      and a.attname in (
        'id',
        'specialist_id',
        'display_name',
        'product_area',
        'short_description',
        'is_published',
        'availability_status',
        'access_tier',
        'sort_order',
        'created_at',
        'updated_at',
        'slug',
        'public_capabilities',
        'publication_status',
        'supported_surfaces',
        'locale',
        'public_metadata',
        'hierarchy_role',
        'is_conversable'
      )
      and a.attnotnull
  ),
  19::bigint,
  'required catalog columns remain NOT NULL'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_attribute a
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname = 'specialist_catalog'
      and a.attname in (
        'slug',
        'subcategory',
        'publication_status',
        'locale',
        'hierarchy_role'
      )
      and pg_catalog.format_type(a.atttypid, a.atttypmod) = 'text'
  ),
  5::bigint,
  'new catalog text columns have expected type'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_attribute a
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname = 'specialist_catalog'
      and (
        (a.attname in ('public_capabilities', 'public_metadata')
          and pg_catalog.format_type(a.atttypid, a.atttypmod) = 'jsonb')
        or (a.attname = 'supported_surfaces'
          and pg_catalog.format_type(a.atttypid, a.atttypmod) = 'text[]')
        or (a.attname = 'parent_catalog_id'
          and pg_catalog.format_type(a.atttypid, a.atttypmod) = 'uuid')
        or (a.attname = 'is_conversable'
          and pg_catalog.format_type(a.atttypid, a.atttypmod) = 'boolean')
        or (a.attname in ('published_at', 'unpublished_at')
          and pg_catalog.format_type(a.atttypid, a.atttypmod)
            = 'timestamp with time zone')
      )
  ),
  7::bigint,
  'new catalog jsonb, array, uuid, boolean and timestamp columns have expected types'
);

select is(
  (
    select pg_get_expr(d.adbin, d.adrelid)
    from pg_catalog.pg_attrdef d
    join pg_catalog.pg_attribute a
      on a.attrelid = d.adrelid and a.attnum = d.adnum
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname = 'specialist_catalog'
      and a.attname = 'publication_status'
  ),
  '''draft''::text',
  'publication_status defaults to draft'
);

select is(
  (
    select pg_get_expr(d.adbin, d.adrelid)
    from pg_catalog.pg_attrdef d
    join pg_catalog.pg_attribute a
      on a.attrelid = d.adrelid and a.attnum = d.adnum
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname = 'specialist_catalog'
      and a.attname = 'supported_surfaces'
  ),
  'ARRAY[''product''::text]',
  'supported_surfaces defaults to product only'
);

select is(
  (
    select pg_get_expr(d.adbin, d.adrelid)
    from pg_catalog.pg_attrdef d
    join pg_catalog.pg_attribute a
      on a.attrelid = d.adrelid and a.attnum = d.adnum
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname = 'specialist_catalog'
      and a.attname = 'locale'
  ),
  '''es-ES''::text',
  'locale defaults to es-ES'
);

select is(
  (
    select pg_get_expr(d.adbin, d.adrelid)
    from pg_catalog.pg_attrdef d
    join pg_catalog.pg_attribute a
      on a.attrelid = d.adrelid and a.attnum = d.adnum
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname = 'specialist_catalog'
      and a.attname = 'hierarchy_role'
  ),
  '''specialist''::text',
  'hierarchy_role defaults to specialist'
);

select is(
  (
    select pg_get_expr(d.adbin, d.adrelid)
    from pg_catalog.pg_attrdef d
    join pg_catalog.pg_attribute a
      on a.attrelid = d.adrelid and a.attnum = d.adnum
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname = 'specialist_catalog'
      and a.attname = 'is_conversable'
  ),
  'true',
  'is_conversable defaults to true'
);

select ok(
  (
    select pg_get_expr(d.adbin, d.adrelid) like '%uuid_generate_v4%'
    from pg_catalog.pg_attrdef d
    join pg_catalog.pg_attribute a
      on a.attrelid = d.adrelid and a.attnum = d.adnum
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname = 'specialist_catalog'
      and a.attname = 'slug'
  ),
  'slug default generates a local opaque slug'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_constraint con
    join pg_catalog.pg_class c on c.oid = con.conrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname = 'specialist_catalog'
      and con.conname in (
        'specialist_catalog_slug_valid',
        'specialist_catalog_subcategory_valid',
        'specialist_catalog_public_capabilities_valid',
        'specialist_catalog_publication_status_valid',
        'specialist_catalog_is_published_consistent',
        'specialist_catalog_availability_status_valid',
        'specialist_catalog_access_tier_valid',
        'specialist_catalog_supported_surfaces_valid',
        'specialist_catalog_locale_valid',
        'specialist_catalog_public_metadata_valid',
        'specialist_catalog_hierarchy_role_valid',
        'specialist_catalog_parent_not_self'
      )
  ),
  12::bigint,
  'AG111 constraints exist'
);

select ok(
  (
    select c.relrowsecurity and not c.relforcerowsecurity
    from pg_catalog.pg_class c
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'specialist_catalog'
  ),
  'specialist_catalog preserves RLS without FORCE RLS'
);

select ok(
  (
    select c.relrowsecurity and not c.relforcerowsecurity
    from pg_catalog.pg_class c
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'specialists'
  ),
  'specialists preserves RLS without FORCE RLS'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_policies
    where schemaname = 'public'
      and tablename in ('specialists', 'specialist_catalog')
  ),
  0::bigint,
  'specialists and specialist_catalog still have zero policies'
);

select ok(
  not has_table_privilege('anon', 'public.specialist_catalog', 'SELECT')
    and not has_table_privilege('authenticated', 'public.specialist_catalog', 'SELECT')
    and not has_table_privilege('anon', 'public.specialist_catalog', 'INSERT')
    and not has_table_privilege('authenticated', 'public.specialist_catalog', 'INSERT')
    and not has_table_privilege('anon', 'public.specialist_catalog', 'UPDATE')
    and not has_table_privilege('authenticated', 'public.specialist_catalog', 'UPDATE')
    and not has_table_privilege('anon', 'public.specialist_catalog', 'DELETE')
    and not has_table_privilege('authenticated', 'public.specialist_catalog', 'DELETE'),
  'anon and authenticated have zero table privileges on specialist_catalog'
);

select ok(
  not has_any_column_privilege('anon', 'public.specialist_catalog', 'SELECT')
    and not has_any_column_privilege('authenticated', 'public.specialist_catalog', 'SELECT')
    and not has_any_column_privilege('anon', 'public.specialist_catalog', 'UPDATE')
    and not has_any_column_privilege('authenticated', 'public.specialist_catalog', 'UPDATE'),
  'anon and authenticated have zero column privileges on specialist_catalog'
);

select ok(
  (
    select count(*) >= 1
    from pg_catalog.pg_indexes
    where schemaname = 'public'
      and tablename = 'specialist_catalog'
      and indexname = 'idx_specialist_catalog_product_slug_unique'
      and indexdef like '%UNIQUE%'
      and indexdef like '%product_area%'
      and indexdef like '%slug%'
  ),
  'product slug unique index exists'
);

select ok(
  (
    select count(*) >= 1
    from pg_catalog.pg_indexes
    where schemaname = 'public'
      and tablename = 'specialist_catalog'
      and indexname = 'idx_specialist_catalog_product_listing_v2'
      and indexdef like '%publication_status%'
      and indexdef like '%supported_surfaces%'
  ),
  'product listing partial index exists'
);

select ok(
  (
    select count(*) >= 1
    from pg_catalog.pg_indexes
    where schemaname = 'public'
      and tablename = 'specialist_catalog'
      and indexname = 'idx_specialist_catalog_product_access_v2'
      and indexdef like '%access_tier%'
  ),
  'product access index exists'
);

select ok(
  (
    select count(*) >= 1
    from pg_catalog.pg_indexes
    where schemaname = 'public'
      and tablename = 'specialist_catalog'
      and indexname = 'idx_specialist_catalog_supported_surfaces_gin'
      and indexdef like '%gin%'
  ),
  'supported_surfaces GIN index exists'
);

select has_function(
  'public',
  'set_specialist_catalog_updated_at',
  'set_specialist_catalog_updated_at trigger function exists'
);

select ok(
  (
    select count(*) = 1
    from pg_catalog.pg_trigger t
    join pg_catalog.pg_class c on c.oid = t.tgrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname = 'specialist_catalog'
      and t.tgname = 'set_specialist_catalog_updated_at'
      and not t.tgisinternal
  ),
  'updated_at trigger exists on specialist_catalog'
);

select ok(
  not has_function_privilege(
    'anon',
    'public.set_specialist_catalog_updated_at()',
    'EXECUTE'
  )
    and not has_function_privilege(
      'authenticated',
      'public.set_specialist_catalog_updated_at()',
      'EXECUTE'
    ),
  'client roles cannot execute the updated_at trigger function directly'
);

insert into public.specialists (
  id, name, category, prompt_template, is_premium, is_active
) values
  ('a1120000-0000-4000-8000-000000000001', 'test_only_ag112_valid',
   'salud', '{"marker":"test_only_ag112"}', false, true),
  ('a1120000-0000-4000-8000-000000000002', 'test_only_ag112_child',
   'salud', '{"marker":"test_only_ag112"}', false, true),
  ('a1120000-0000-4000-8000-000000000003', 'test_only_ag112_invalid',
   'salud', '{"marker":"test_only_ag112"}', false, true);

select lives_ok(
  $$insert into public.specialist_catalog (
      id,
      specialist_id,
      slug,
      display_name,
      product_area,
      subcategory,
      short_description,
      public_capabilities,
      publication_status,
      is_published,
      availability_status,
      access_tier,
      supported_surfaces,
      locale,
      public_metadata,
      hierarchy_role,
      is_conversable,
      sort_order
    ) values (
      'a1130000-0000-4000-8000-000000000001',
      'a1120000-0000-4000-8000-000000000001',
      'ag112-valid',
      'AG112 Valid',
      'health',
      'general',
      'Fixture local sintetico para AG112.',
      '["triage", "education"]'::jsonb,
      'published',
      true,
      'available',
      'pro',
      ARRAY['product']::text[],
      'es-ES',
      '{"badge":"test-only"}'::jsonb,
      'specialist',
      true,
      10
    )$$,
  'valid local synthetic catalog row is accepted'
);

select is(
  (
    select count(*)::bigint
    from public.specialist_catalog
    where id = 'a1130000-0000-4000-8000-000000000001'
  ),
  1::bigint,
  'valid synthetic row exists inside the transaction'
);

select lives_ok(
  $$insert into public.specialist_catalog (
      id,
      specialist_id,
      slug,
      display_name,
      product_area,
      short_description,
      publication_status,
      is_published,
      availability_status,
      access_tier,
      hierarchy_role,
      parent_catalog_id
    ) values (
      'a1130000-0000-4000-8000-000000000002',
      'a1120000-0000-4000-8000-000000000002',
      'ag112-child',
      'AG112 Child',
      'health',
      'Fixture local sintetico hijo para AG112.',
      'draft',
      false,
      'unavailable',
      'free',
      'subcategory_chief',
      'a1130000-0000-4000-8000-000000000001'
    )$$,
  'basic parent_catalog_id relation to an existing row is accepted'
);

select throws_ok(
  $$update public.specialist_catalog
    set slug = ''
    where id = 'a1130000-0000-4000-8000-000000000001'$$,
  '23514',
  null,
  'empty slug is rejected'
);

select throws_ok(
  $$update public.specialist_catalog
    set slug = 'Bad Slug'
    where id = 'a1130000-0000-4000-8000-000000000001'$$,
  '23514',
  null,
  'non-normalized slug is rejected'
);

select throws_ok(
  $$update public.specialist_catalog
    set publication_status = 'public'
    where id = 'a1130000-0000-4000-8000-000000000001'$$,
  '23514',
  null,
  'invalid publication_status is rejected'
);

select throws_ok(
  $$update public.specialist_catalog
    set availability_status = 'demo_only'
    where id = 'a1130000-0000-4000-8000-000000000001'$$,
  '23514',
  null,
  'invalid availability_status is rejected'
);

select throws_ok(
  $$update public.specialist_catalog
    set access_tier = 'premium'
    where id = 'a1130000-0000-4000-8000-000000000001'$$,
  '23514',
  null,
  'legacy premium access_tier is rejected after AG111 normalization'
);

select throws_ok(
  $$update public.specialist_catalog
    set access_tier = 'internal'
    where id = 'a1130000-0000-4000-8000-000000000001'$$,
  '23514',
  null,
  'internal access_tier is rejected'
);

select throws_ok(
  $$update public.specialist_catalog
    set supported_surfaces = ARRAY['admin']::text[]
    where id = 'a1130000-0000-4000-8000-000000000001'$$,
  '23514',
  null,
  'supported_surfaces without product is rejected'
);

select throws_ok(
  $$update public.specialist_catalog
    set supported_surfaces = ARRAY['product', 'admin']::text[]
    where id = 'a1130000-0000-4000-8000-000000000001'$$,
  '23514',
  null,
  'supported_surfaces mixing product and admin is rejected'
);

select throws_ok(
  $$update public.specialist_catalog
    set locale = ''
    where id = 'a1130000-0000-4000-8000-000000000001'$$,
  '23514',
  null,
  'empty locale is rejected'
);

select throws_ok(
  $$update public.specialist_catalog
    set locale = 'spanish'
    where id = 'a1130000-0000-4000-8000-000000000001'$$,
  '23514',
  null,
  'invalid locale shape is rejected'
);

select throws_ok(
  $$update public.specialist_catalog
    set public_metadata = '[]'::jsonb
    where id = 'a1130000-0000-4000-8000-000000000001'$$,
  '23514',
  null,
  'public_metadata that is not an object is rejected'
);

select throws_ok(
  $$update public.specialist_catalog
    set public_capabilities = '{}'::jsonb
    where id = 'a1130000-0000-4000-8000-000000000001'$$,
  '23514',
  null,
  'public_capabilities that is not an array is rejected'
);

select throws_ok(
  $$update public.specialist_catalog
    set hierarchy_role = 'admin_agent'
    where id = 'a1130000-0000-4000-8000-000000000001'$$,
  '23514',
  null,
  'invalid hierarchy_role is rejected'
);

select throws_ok(
  $$update public.specialist_catalog
    set parent_catalog_id = id
    where id = 'a1130000-0000-4000-8000-000000000001'$$,
  '23514',
  null,
  'parent_catalog_id equal to own id is rejected'
);

select throws_ok(
  $$update public.specialist_catalog
    set parent_catalog_id = 'ffffffff-ffff-4fff-8fff-ffffffffffff'
    where id = 'a1130000-0000-4000-8000-000000000002'$$,
  '23503',
  null,
  'parent_catalog_id pointing to a missing catalog row is rejected'
);

select throws_ok(
  $$update public.specialist_catalog
    set is_published = false
    where id = 'a1130000-0000-4000-8000-000000000001'$$,
  '23514',
  null,
  'is_published false conflicts with publication_status published'
);

select throws_ok(
  $$update public.specialist_catalog
    set publication_status = 'published'
    where id = 'a1130000-0000-4000-8000-000000000002'$$,
  '23514',
  null,
  'publication_status published conflicts with is_published false'
);

select lives_ok(
  $$update public.specialist_catalog
    set publication_status = 'draft',
        is_published = false
    where id = 'a1130000-0000-4000-8000-000000000001'$$,
  'publication_status and is_published can be updated consistently together'
);

select throws_ok(
  $$insert into public.specialist_catalog (
      specialist_id,
      slug,
      display_name,
      product_area,
      short_description
    ) values (
      'a1120000-0000-4000-8000-000000000003',
      'ag112-valid',
      'AG112 Duplicate Slug',
      'health',
      'Fixture local sintetico para duplicado.'
    )$$,
  '23505',
  null,
  'duplicate slug in same product_area is rejected'
);

select lives_ok(
  $$insert into public.specialist_catalog (
      specialist_id,
      slug,
      display_name,
      product_area,
      short_description
    ) values (
      'a1120000-0000-4000-8000-000000000003',
      'ag112-valid',
      'AG112 Same Slug Different Area',
      'wellness',
      'Fixture local sintetico para slug por area.'
    )$$,
  'same slug in a different product_area is accepted'
);

select is(
  (
    select access_tier
    from public.specialist_catalog
    where slug = 'ag112-valid'
      and product_area = 'health'
  ),
  'pro',
  'valid fixture keeps pro access_tier'
);

select ok(
  (
    select updated_at >= created_at
    from public.specialist_catalog
    where id = 'a1130000-0000-4000-8000-000000000001'
  ),
  'updated_at remains coherent after trigger-backed updates'
);

set local role anon;

select throws_ok(
  $$select * from public.specialist_catalog$$,
  '42501',
  null,
  'anon cannot select specialist_catalog'
);

select throws_ok(
  $$insert into public.specialist_catalog (
      specialist_id,
      display_name,
      product_area,
      short_description
    ) values (
      'a1120000-0000-4000-8000-000000000001',
      'Anon',
      'health',
      'Fixture anon.'
    )$$,
  '42501',
  null,
  'anon cannot insert specialist_catalog rows'
);

select throws_ok(
  $$update public.specialist_catalog set display_name = 'Anon'$$,
  '42501',
  null,
  'anon cannot update specialist_catalog rows'
);

select throws_ok(
  $$delete from public.specialist_catalog$$,
  '42501',
  null,
  'anon cannot delete specialist_catalog rows'
);

reset role;
set local role authenticated;

select throws_ok(
  $$select * from public.specialist_catalog$$,
  '42501',
  null,
  'authenticated cannot select specialist_catalog'
);

select throws_ok(
  $$insert into public.specialist_catalog (
      specialist_id,
      display_name,
      product_area,
      short_description
    ) values (
      'a1120000-0000-4000-8000-000000000001',
      'Authenticated',
      'health',
      'Fixture authenticated.'
    )$$,
  '42501',
  null,
  'authenticated cannot insert specialist_catalog rows'
);

select throws_ok(
  $$update public.specialist_catalog set display_name = 'Authenticated'$$,
  '42501',
  null,
  'authenticated cannot update specialist_catalog rows'
);

select throws_ok(
  $$delete from public.specialist_catalog$$,
  '42501',
  null,
  'authenticated cannot delete specialist_catalog rows'
);

reset role;

select is(
  (
    select count(*)::bigint
    from public.specialist_catalog c
    join public.specialists s on s.id = c.specialist_id
    where s.id::text like 'a1120000-0000-4000-8000-%'
  ),
  3::bigint,
  'only the expected AG112 transaction fixtures exist before rollback'
);

select is(
  (
    select count(*)::bigint
    from public.specialists
    where id::text like 'a1120000-0000-4000-8000-%'
  ),
  3::bigint,
  'only the expected AG112 internal fixtures exist before rollback'
);

select * from finish();

rollback;

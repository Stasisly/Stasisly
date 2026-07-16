begin;

create extension if not exists pgtap with schema extensions;

select plan(56);

select has_table(
  'public', 'specialist_catalog',
  'public.specialist_catalog exists'
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
  'specialist_catalog has the approved AG111 columns'
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
      and a.attnotnull
  ),
  19::bigint,
  'required specialist_catalog columns are NOT NULL'
);

select is(
  (
    select pg_catalog.format_type(a.atttypid, a.atttypmod)
    from pg_catalog.pg_attribute a
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'specialist_catalog'
      and a.attname = 'id'
  ),
  'uuid',
  'id is UUID'
);

select is(
  (
    select pg_catalog.format_type(a.atttypid, a.atttypmod)
    from pg_catalog.pg_attribute a
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'specialist_catalog'
      and a.attname = 'specialist_id'
  ),
  'uuid',
  'specialist_id is UUID'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_attribute a
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'specialist_catalog'
      and a.attname in (
        'display_name', 'product_area', 'short_description',
        'availability_status', 'access_tier'
      )
      and pg_catalog.format_type(a.atttypid, a.atttypmod) = 'text'
  ),
  5::bigint,
  'approved catalog string columns are TEXT'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_attribute a
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'specialist_catalog'
      and (
        (a.attname = 'is_published'
          and pg_catalog.format_type(a.atttypid, a.atttypmod) = 'boolean')
        or (a.attname = 'sort_order'
          and pg_catalog.format_type(a.atttypid, a.atttypmod) = 'integer')
        or (a.attname in ('created_at', 'updated_at')
          and pg_catalog.format_type(a.atttypid, a.atttypmod)
            = 'timestamp with time zone')
      )
  ),
  4::bigint,
  'boolean, integer, and timestamptz columns have approved types'
);

select ok(
  (
    select pg_get_expr(d.adbin, d.adrelid) like '%uuid_generate_v4%'
    from pg_catalog.pg_attrdef d
    join pg_catalog.pg_attribute a
      on a.attrelid = d.adrelid and a.attnum = d.adnum
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'specialist_catalog'
      and a.attname = 'id'
  ),
  'id default generates a UUID'
);

select is(
  (
    select pg_get_expr(d.adbin, d.adrelid)
    from pg_catalog.pg_attrdef d
    join pg_catalog.pg_attribute a
      on a.attrelid = d.adrelid and a.attnum = d.adnum
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'specialist_catalog'
      and a.attname = 'is_published'
  ),
  'false',
  'is_published defaults to false'
);

select is(
  (
    select pg_get_expr(d.adbin, d.adrelid)
    from pg_catalog.pg_attrdef d
    join pg_catalog.pg_attribute a
      on a.attrelid = d.adrelid and a.attnum = d.adnum
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'specialist_catalog'
      and a.attname = 'availability_status'
  ),
  '''unavailable''::text',
  'availability_status defaults to unavailable'
);

select is(
  (
    select pg_get_expr(d.adbin, d.adrelid)
    from pg_catalog.pg_attrdef d
    join pg_catalog.pg_attribute a
      on a.attrelid = d.adrelid and a.attnum = d.adnum
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'specialist_catalog'
      and a.attname = 'access_tier'
  ),
  '''free''::text',
  'access_tier defaults to free'
);

select is(
  (
    select pg_get_expr(d.adbin, d.adrelid)
    from pg_catalog.pg_attrdef d
    join pg_catalog.pg_attribute a
      on a.attrelid = d.adrelid and a.attnum = d.adnum
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'specialist_catalog'
      and a.attname = 'sort_order'
  ),
  '0',
  'sort_order defaults to zero'
);

select ok(
  (
    select count(*) = 2
    from pg_catalog.pg_attrdef d
    join pg_catalog.pg_attribute a
      on a.attrelid = d.adrelid and a.attnum = d.adnum
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'specialist_catalog'
      and a.attname in ('created_at', 'updated_at')
      and pg_get_expr(d.adbin, d.adrelid) = 'now()'
  ),
  'created_at and updated_at default to now()'
);

select is(
  (
    select count(*)::bigint
    from public.specialist_catalog
  ),
  0::bigint,
  'specialist_catalog is empty after migration'
);

select ok(
  (
    select c.relrowsecurity and not c.relforcerowsecurity
    from pg_catalog.pg_class c
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'specialists'
  ),
  'specialists has RLS enabled without FORCE RLS'
);

select ok(
  (
    select c.relrowsecurity and not c.relforcerowsecurity
    from pg_catalog.pg_class c
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public' and c.relname = 'specialist_catalog'
  ),
  'specialist_catalog has RLS enabled without FORCE RLS'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_policies
    where schemaname = 'public'
      and tablename in ('specialists', 'specialist_catalog')
  ),
  0::bigint,
  'specialists and specialist_catalog have zero policies'
);

select ok(
  not has_table_privilege('anon', 'public.specialists', 'SELECT')
    and not has_table_privilege('anon', 'public.specialists', 'INSERT')
    and not has_table_privilege('anon', 'public.specialists', 'UPDATE')
    and not has_table_privilege('anon', 'public.specialists', 'DELETE')
    and not has_any_column_privilege('anon', 'public.specialists', 'SELECT')
    and not has_any_column_privilege('anon', 'public.specialists', 'UPDATE'),
  'anon has zero client privileges on specialists'
);

select ok(
  not has_table_privilege('authenticated', 'public.specialists', 'SELECT')
    and not has_table_privilege('authenticated', 'public.specialists', 'INSERT')
    and not has_table_privilege('authenticated', 'public.specialists', 'UPDATE')
    and not has_table_privilege('authenticated', 'public.specialists', 'DELETE')
    and not has_any_column_privilege(
      'authenticated', 'public.specialists', 'SELECT'
    )
    and not has_any_column_privilege(
      'authenticated', 'public.specialists', 'UPDATE'
    ),
  'authenticated has zero client privileges on specialists'
);

select ok(
  not has_table_privilege('anon', 'public.specialist_catalog', 'SELECT')
    and not has_table_privilege('anon', 'public.specialist_catalog', 'INSERT')
    and not has_table_privilege('anon', 'public.specialist_catalog', 'UPDATE')
    and not has_table_privilege('anon', 'public.specialist_catalog', 'DELETE')
    and not has_any_column_privilege(
      'anon', 'public.specialist_catalog', 'SELECT'
    )
    and not has_any_column_privilege(
      'anon', 'public.specialist_catalog', 'UPDATE'
    ),
  'anon has zero client privileges on specialist_catalog'
);

select ok(
  not has_table_privilege(
    'authenticated', 'public.specialist_catalog', 'SELECT'
  )
    and not has_table_privilege(
      'authenticated', 'public.specialist_catalog', 'INSERT'
    )
    and not has_table_privilege(
      'authenticated', 'public.specialist_catalog', 'UPDATE'
    )
    and not has_table_privilege(
      'authenticated', 'public.specialist_catalog', 'DELETE'
    )
    and not has_any_column_privilege(
      'authenticated', 'public.specialist_catalog', 'SELECT'
    )
    and not has_any_column_privilege(
      'authenticated', 'public.specialist_catalog', 'UPDATE'
    ),
  'authenticated has zero client privileges on specialist_catalog'
);

select is(
  (
    select count(*)::bigint
    from information_schema.role_table_grants
    where table_schema = 'public'
      and table_name in ('specialists', 'specialist_catalog')
      and grantee = 'PUBLIC'
  ),
  0::bigint,
  'PUBLIC has no table privileges on either specialist table'
);

select is(
  (
    select array_agg(c.relname order by c.relname)::text
    from pg_catalog.pg_class c
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relkind in ('r', 'p')
      and c.relrowsecurity
  ),
  '{branch_chiefs,calendar_events,chat_sessions,chief_write_permissions,conversation_idempotency,memberships,messages,orchestator_summaries,reminders,specialist_catalog,specialist_temporary_disables,specialists,subcategory_chiefs,user_health_data,user_memberships,users}',
  'only the approved public deny-all/profile tables, including R1, have RLS enabled'
);

select is(
  (
    select count(*)::bigint
    from pg_catalog.pg_indexes
    where schemaname = 'public'
      and tablename = 'specialist_catalog'
  ),
  8::bigint,
  'specialist_catalog has approved historical and AG111 indexes'
);

select ok(
  (
    select indexdef like '%WHERE (is_published = true)'
    from pg_catalog.pg_indexes
    where schemaname = 'public'
      and indexname = 'idx_specialist_catalog_published_listing'
  ),
  'published listing index is partial'
);

select ok(
  (
    select count(*) = 1
    from pg_catalog.pg_constraint con
    join pg_catalog.pg_class c on c.oid = con.conrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname = 'specialist_catalog'
      and con.contype = 'f'
      and con.confrelid = 'public.specialists'::regclass
      and con.confdeltype = 'r'
  ),
  'specialist_id FK references specialists with ON DELETE RESTRICT'
);

select ok(
  (
    select count(*) = 1
    from pg_catalog.pg_constraint con
    join pg_catalog.pg_class c on c.oid = con.conrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname = 'specialist_catalog'
      and con.contype = 'u'
  ),
  'specialist_id is unique'
);

select is(
  (
    select array_agg(a.attname order by a.attnum)::text
    from pg_catalog.pg_attribute a
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname = 'specialists'
      and a.attnum > 0
      and not a.attisdropped
  ),
  '{id,name,category,subcategory,prompt_template,is_premium,is_active,avatar_url,branch_id,chief_id,created_at}',
  'specialists columns remain unchanged'
);

select ok(
  (
    select a.attnotnull
      and pg_catalog.format_type(a.atttypid, a.atttypmod) = 'jsonb'
    from pg_catalog.pg_attribute a
    join pg_catalog.pg_class c on c.oid = a.attrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    where n.nspname = 'public'
      and c.relname = 'specialists'
      and a.attname = 'prompt_template'
  ),
  'specialists.prompt_template remains JSONB NOT NULL'
);

insert into public.specialists (
  id, name, category, prompt_template, is_premium, is_active
) values (
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  'Fixture Specialist',
  'salud',
  '{"system":"private"}'::jsonb,
  false,
  true
);

insert into public.specialist_catalog (
  id, specialist_id, display_name, product_area, short_description,
  is_published, publication_status, availability_status, access_tier, sort_order
) values (
  'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
  'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
  'Fixture Public',
  'health',
  'Fixture public description',
  true,
  'published',
  'available',
  'free',
  1
);

select lives_ok(
  $$insert into public.specialist_catalog (
      specialist_id, display_name, product_area, short_description
    ) values (
      'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
      'Second Public',
      'health',
      'Duplicate specialist'
    ) on conflict (specialist_id) do nothing$$,
  'approved defaults and valid values are usable'
);

select throws_ok(
  $$insert into public.specialist_catalog (
      specialist_id, display_name, product_area, short_description
    ) values (
      'cccccccc-cccc-4ccc-8ccc-cccccccccccc',
      'Missing FK',
      'health',
      'Missing specialist'
    )$$,
  '23503', null, 'missing specialist FK is rejected'
);

select throws_ok(
  $$insert into public.specialist_catalog (
      specialist_id, display_name, product_area, short_description
    ) values (
      'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
      'Duplicate',
      'health',
      'Duplicate specialist'
    )$$,
  '23505', null, 'duplicate specialist_id is rejected'
);

select throws_ok(
  $$delete from public.specialists
    where id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'$$,
  '23503', null, 'ON DELETE RESTRICT protects referenced specialist'
);

select throws_ok(
  $$insert into public.specialist_catalog (
      specialist_id, display_name, product_area, short_description
    ) values (
      uuid_generate_v4(), 'Legacy', 'fisico', 'Legacy area'
    )$$,
  '23514', null, 'legacy fisico product_area is rejected'
);

select throws_ok(
  $$update public.specialist_catalog set product_area = 'mental'
    where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'$$,
  '23514', null, 'legacy mental product_area is rejected'
);

select throws_ok(
  $$update public.specialist_catalog set availability_status = 'demo_only'
    where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'$$,
  '23514', null, 'demo_only availability is rejected'
);

select throws_ok(
  $$update public.specialist_catalog set access_tier = 'internal'
    where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'$$,
  '23514', null, 'internal access_tier is rejected'
);

select throws_ok(
  $$update public.specialist_catalog set sort_order = -1
    where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'$$,
  '23514', null, 'negative sort_order is rejected'
);

select throws_ok(
  $$update public.specialist_catalog set display_name = ''
    where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'$$,
  '23514', null, 'empty display_name is rejected'
);

select throws_ok(
  $$update public.specialist_catalog set display_name = ' Padded'
    where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'$$,
  '23514', null, 'padded display_name is rejected'
);

select throws_ok(
  $$update public.specialist_catalog set display_name = repeat('x', 81)
    where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'$$,
  '23514', null, 'overlong display_name is rejected'
);

select throws_ok(
  $$update public.specialist_catalog set short_description = ''
    where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'$$,
  '23514', null, 'empty short_description is rejected'
);

select throws_ok(
  $$update public.specialist_catalog set short_description = ' Padded'
    where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'$$,
  '23514', null, 'padded short_description is rejected'
);

select throws_ok(
  $$update public.specialist_catalog set short_description = repeat('x', 241)
    where id = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb'$$,
  '23514', null, 'overlong short_description is rejected'
);

set local role anon;
select throws_ok(
  $$select * from public.specialists$$,
  '42501', null, 'anon cannot SELECT specialists'
);
select throws_ok(
  $$select * from public.specialist_catalog$$,
  '42501', null, 'anon cannot SELECT specialist_catalog'
);
select throws_ok(
  $$insert into public.specialist_catalog (
      specialist_id, display_name, product_area, short_description
    ) values (
      'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
      'Anon',
      'health',
      'Anon insert'
    )$$,
  '42501', null, 'anon cannot INSERT specialist_catalog'
);
select throws_ok(
  $$update public.specialist_catalog set display_name = 'Anon'$$,
  '42501', null, 'anon cannot UPDATE specialist_catalog'
);
select throws_ok(
  $$delete from public.specialist_catalog$$,
  '42501', null, 'anon cannot DELETE specialist_catalog'
);

reset role;
set local role authenticated;
select throws_ok(
  $$select * from public.specialists$$,
  '42501', null, 'authenticated cannot SELECT specialists'
);
select throws_ok(
  $$select * from public.specialist_catalog$$,
  '42501', null, 'authenticated cannot SELECT specialist_catalog'
);
select throws_ok(
  $$insert into public.specialist_catalog (
      specialist_id, display_name, product_area, short_description
    ) values (
      'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
      'Authenticated',
      'health',
      'Authenticated insert'
    )$$,
  '42501', null, 'authenticated cannot INSERT specialist_catalog'
);
select throws_ok(
  $$update public.specialist_catalog set display_name = 'Authenticated'$$,
  '42501', null, 'authenticated cannot UPDATE specialist_catalog'
);
select throws_ok(
  $$delete from public.specialist_catalog$$,
  '42501', null, 'authenticated cannot DELETE specialist_catalog'
);
reset role;

select is(
  (select count(*)::bigint from public.specialist_catalog),
  1::bigint,
  'client attempts did not change catalog fixture count'
);

select is(
  (
    select prompt_template::text
    from public.specialists
    where id = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa'
  ),
  '{"system": "private"}',
  'prompt_template remains unchanged and internal'
);

select * from finish();

rollback;

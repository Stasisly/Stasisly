begin;

create extension if not exists pgtap with schema extensions;

select plan(40);

select is(
  (select count(*)::bigint from public.specialist_catalog),
  0::bigint,
  'catalog starts empty before transactional fixtures'
);

insert into public.specialists (
  id, name, category, prompt_template, is_premium, is_active
) values
  ('10000000-0000-4000-8000-000000000001', 'Test Only Stasis',
    'orquestador',
    '{"marker":"test_only_placeholder_prompt_not_for_production"}', false, false),
  ('10000000-0000-4000-8000-000000000002', 'Test Only Health',
    'salud',
    '{"marker":"test_only_placeholder_prompt_not_for_production"}', false, false),
  ('10000000-0000-4000-8000-000000000003', 'Test Only Nutrition',
    'nutricion',
    '{"marker":"test_only_placeholder_prompt_not_for_production"}', false, false),
  ('10000000-0000-4000-8000-000000000004', 'Test Only Training',
    'fisico',
    '{"marker":"test_only_placeholder_prompt_not_for_production"}', false, false),
  ('10000000-0000-4000-8000-000000000005', 'Test Only Wellness',
    'mental',
    '{"marker":"test_only_placeholder_prompt_not_for_production"}', false, false),
  ('10000000-0000-4000-8000-000000000006', 'Test Only Sleep Stress',
    'mental',
    '{"marker":"test_only_placeholder_prompt_not_for_production"}', false, false);

insert into public.specialist_catalog (
  id, specialist_id, display_name, product_area, short_description,
  is_published, availability_status, access_tier, sort_order
) values
  ('20000000-0000-4000-8000-000000000001',
    '10000000-0000-4000-8000-000000000001', 'Stasis', 'stasis',
    'Fixture local conceptual para validar el catálogo, no apto para producción.',
    false, 'unavailable', 'free', 10),
  ('20000000-0000-4000-8000-000000000002',
    '10000000-0000-4000-8000-000000000002', 'Salud general', 'health',
    'Fixture local conceptual para validar el catálogo, no apto para producción.',
    false, 'unavailable', 'free', 20),
  ('20000000-0000-4000-8000-000000000003',
    '10000000-0000-4000-8000-000000000003', 'Nutrición', 'nutrition',
    'Fixture local conceptual para validar el catálogo, no apto para producción.',
    false, 'unavailable', 'free', 30),
  ('20000000-0000-4000-8000-000000000004',
    '10000000-0000-4000-8000-000000000004', 'Entrenamiento', 'training',
    'Fixture local conceptual para validar el catálogo, no apto para producción.',
    false, 'unavailable', 'free', 40),
  ('20000000-0000-4000-8000-000000000005',
    '10000000-0000-4000-8000-000000000005', 'Wellness', 'wellness',
    'Fixture local conceptual para validar el catálogo, no apto para producción.',
    false, 'unavailable', 'free', 50),
  ('20000000-0000-4000-8000-000000000006',
    '10000000-0000-4000-8000-000000000006', 'Sueño y estrés', 'wellness',
    'Fixture local conceptual para validar el catálogo, no apto para producción.',
    false, 'unavailable', 'free', 60);

select is(
  (select count(*)::bigint from public.specialists
    where id::text like '10000000-0000-4000-8000-%'),
  6::bigint,
  'six fictitious internal specialists exist only inside the test transaction'
);

select is(
  (select count(*)::bigint from public.specialist_catalog),
  6::bigint,
  'six conceptual catalog fixtures exist inside the transaction'
);

select set_eq(
  $$select display_name from public.specialist_catalog$$,
  $$values ('Stasis'), ('Salud general'), ('Nutrición'), ('Entrenamiento'),
      ('Wellness'), ('Sueño y estrés')$$,
  'catalog contains exactly the approved conceptual display names'
);

select is(
  (select count(*)::bigint from public.specialist_catalog
    where product_area not in ('stasis', 'health', 'nutrition', 'training', 'wellness')),
  0::bigint,
  'all fixtures use approved product areas'
);

select is(
  (select product_area from public.specialist_catalog where display_name = 'Stasis'),
  'stasis',
  'Stasis uses the stasis product area'
);

select is(
  (select product_area from public.specialist_catalog where display_name = 'Sueño y estrés'),
  'wellness',
  'Sueño y estrés uses the wellness product area'
);

select is(
  (select count(*)::bigint from public.specialist_catalog where not is_published),
  6::bigint,
  'all fixtures are unpublished'
);

select is(
  (select count(*)::bigint from public.specialist_catalog
    where availability_status = 'unavailable'),
  6::bigint,
  'all fixtures are unavailable'
);

select is(
  (select count(*)::bigint from public.specialist_catalog where access_tier = 'free'),
  6::bigint,
  'all fixtures use the free provisional tier'
);

select is(
  (select count(*)::bigint from public.specialist_catalog
    where availability_status = 'demo_only'),
  0::bigint,
  'fixtures contain no demo_only availability'
);

select is(
  (select count(*)::bigint from public.specialist_catalog where access_tier = 'internal'),
  0::bigint,
  'fixtures contain no internal access tier'
);

select is(
  (select array_agg(sort_order order by sort_order)::text from public.specialist_catalog),
  '{10,20,30,40,50,60}',
  'fixture order is deterministic'
);

select is(
  (select count(*)::bigint from public.specialists
    where id::text like '10000000-0000-4000-8000-%'
      and prompt_template::text like '%test_only%'),
  6::bigint,
  'all internal fixture prompts contain test_only'
);

select is(
  (select count(*)::bigint from public.specialists
    where id::text like '10000000-0000-4000-8000-%'
      and lower(prompt_template::text) ~
        '(diagnostica|diagnóstico|trata|cura|médic|terapéut)'),
  0::bigint,
  'fixture prompts contain no medical or therapeutic claims'
);

select is(
  (select count(*)::bigint from public.specialist_catalog
    where lower(short_description) ~
      '(diagnostica|diagnóstico|trata|cura|recomendación médica|terapéut)'),
  0::bigint,
  'fixture descriptions contain no medical or therapeutic claims'
);

select is(
  (select count(*)::bigint
    from public.specialist_catalog c
    join public.specialists s on s.id = c.specialist_id),
  6::bigint,
  'every catalog fixture references a valid internal fixture'
);

select is(
  (select count(distinct specialist_id)::bigint from public.specialist_catalog),
  6::bigint,
  'each catalog fixture has a unique internal specialist'
);

select is(
  (select count(*)::bigint from public.specialist_catalog where id = specialist_id),
  0::bigint,
  'public catalog IDs remain separate from internal specialist IDs'
);

select ok(
  (select bool_and(c.relrowsecurity and not c.relforcerowsecurity)
   from pg_catalog.pg_class c
   join pg_catalog.pg_namespace n on n.oid = c.relnamespace
   where n.nspname = 'public'
     and c.relname in ('specialists', 'specialist_catalog')),
  'both specialist tables preserve RLS without FORCE RLS'
);

select is(
  (select count(*)::bigint from pg_catalog.pg_policies
   where schemaname = 'public'
     and tablename in ('specialists', 'specialist_catalog')),
  0::bigint,
  'both specialist tables preserve zero policies'
);

select ok(
  not has_table_privilege('anon', 'public.specialists', 'SELECT')
    and not has_table_privilege('authenticated', 'public.specialists', 'SELECT')
    and not has_table_privilege('anon', 'public.specialist_catalog', 'SELECT')
    and not has_table_privilege('authenticated', 'public.specialist_catalog', 'SELECT'),
  'anon and authenticated preserve zero SELECT table privileges'
);

select ok(
  not has_any_column_privilege('anon', 'public.specialists', 'SELECT')
    and not has_any_column_privilege('authenticated', 'public.specialists', 'SELECT')
    and not has_any_column_privilege('anon', 'public.specialist_catalog', 'SELECT')
    and not has_any_column_privilege('authenticated', 'public.specialist_catalog', 'SELECT'),
  'anon and authenticated preserve zero SELECT column privileges'
);

select throws_ok(
  $$insert into public.specialist_catalog (
      specialist_id, display_name, product_area, short_description
    ) values (
      '10000000-0000-4000-8000-000000000001', 'Duplicate', 'stasis',
      'Fixture local conceptual no apto para producción.'
    )$$,
  '23505', null, 'unique specialist_id still rejects duplicates'
);

select throws_ok(
  $$insert into public.specialist_catalog (
      specialist_id, display_name, product_area, short_description
    ) values (
      '99999999-9999-4999-8999-999999999999', 'Missing FK', 'stasis',
      'Fixture local conceptual no apto para producción.'
    )$$,
  '23503', null, 'foreign key still rejects a missing specialist'
);

select throws_ok(
  $$delete from public.specialists
    where id = '10000000-0000-4000-8000-000000000001'$$,
  '23503', null, 'ON DELETE RESTRICT still protects catalog references'
);

select throws_ok(
  $$update public.specialist_catalog set product_area = 'mental'
    where display_name = 'Wellness'$$,
  '23514', null, 'product area constraint still rejects legacy values'
);

select throws_ok(
  $$update public.specialist_catalog set short_description = ''
    where display_name = 'Wellness'$$,
  '23514', null, 'text constraint still rejects empty descriptions'
);

select throws_ok(
  $$update public.specialist_catalog set access_tier = 'premium'
    where display_name = 'Wellness'$$,
  '23514', null, 'legacy premium access_tier is rejected'
);

set local role anon;
select throws_ok(
  $$select specialist_id from public.specialist_catalog$$,
  '42501', null, 'anon cannot expose internal specialist IDs'
);
select throws_ok(
  $$select prompt_template from public.specialists$$,
  '42501', null, 'anon cannot expose prompt templates'
);
select throws_ok(
  $$insert into public.specialist_catalog (
      specialist_id, display_name, product_area, short_description
    ) values (
      '10000000-0000-4000-8000-000000000001', 'Anon', 'stasis',
      'Fixture local conceptual no apto para producción.'
    )$$,
  '42501', null, 'anon cannot insert catalog rows'
);
select throws_ok(
  $$update public.specialist_catalog set display_name = 'Anon'$$,
  '42501', null, 'anon cannot update catalog rows'
);
select throws_ok(
  $$delete from public.specialist_catalog$$,
  '42501', null, 'anon cannot delete catalog rows'
);

reset role;
set local role authenticated;
select throws_ok(
  $$select specialist_id from public.specialist_catalog$$,
  '42501', null, 'authenticated cannot expose internal specialist IDs'
);
select throws_ok(
  $$select prompt_template from public.specialists$$,
  '42501', null, 'authenticated cannot expose prompt templates'
);
select throws_ok(
  $$insert into public.specialist_catalog (
      specialist_id, display_name, product_area, short_description
    ) values (
      '10000000-0000-4000-8000-000000000001', 'Authenticated', 'stasis',
      'Fixture local conceptual no apto para producción.'
    )$$,
  '42501', null, 'authenticated cannot insert catalog rows'
);
select throws_ok(
  $$update public.specialist_catalog set display_name = 'Authenticated'$$,
  '42501', null, 'authenticated cannot update catalog rows'
);
select throws_ok(
  $$delete from public.specialist_catalog$$,
  '42501', null, 'authenticated cannot delete catalog rows'
);
reset role;

select is(
  (select count(*)::bigint from public.specialist_catalog),
  6::bigint,
  'denied client attempts do not mutate fixtures'
);

select * from finish();

rollback;

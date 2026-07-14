-- 2B-AG114: local-only synthetic Product catalog.
-- This file is intentionally not enabled in supabase/config.toml. Apply it only
-- to a local database after `supabase db reset --local --no-seed`.
-- It contains no auth users, personal data, real prompts or production data.

BEGIN;

INSERT INTO public.specialists (
  id,
  name,
  category,
  subcategory,
  prompt_template,
  is_premium,
  is_active,
  created_at
) VALUES
  ('11000000-0000-4000-8000-000000000001', 'Stasis', 'orquestador', NULL, '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000002', 'Salus', 'branch_chief', 'health', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000003', 'Sintoma', 'salud', 'symptoms', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000004', 'Cardia', 'salud', 'cardiovascular', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000005', 'Motus', 'salud', 'pain-mobility', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000006', 'Nutria', 'branch_chief', 'nutrition', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000007', 'Fuel', 'nutricion', 'sports-nutrition', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000008', 'Menu', 'nutricion', 'meal-planning', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000009', 'Emocion', 'nutricion', 'emotional-eating', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000010', 'Atlas', 'branch_chief', 'training', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000011', 'Kitesurf', 'fisico', 'water-sports', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000012', 'CrossFit', 'fisico', 'functional-training', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000013', 'HYROX', 'fisico', 'hybrid-racing', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000014', 'Yoga', 'fisico', 'mindful-movement', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000015', 'Pilates', 'fisico', 'core-mobility', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000016', 'Sofia', 'branch_chief', 'wellness', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000017', 'Somno', 'mental', 'sleep', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000018', 'Loto', 'mental', 'mindfulness', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z'),
  ('11000000-0000-4000-8000-000000000019', 'Calma', 'mental', 'stress', '{}'::jsonb, false, true, '2026-01-01T00:00:00Z')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.specialist_catalog (
  id,
  specialist_id,
  display_name,
  product_area,
  short_description,
  is_published,
  availability_status,
  access_tier,
  sort_order,
  created_at,
  updated_at,
  slug,
  subcategory,
  public_capabilities,
  publication_status,
  supported_surfaces,
  locale,
  public_metadata,
  hierarchy_role,
  parent_catalog_id,
  is_conversable,
  published_at,
  unpublished_at
) VALUES
  ('21000000-0000-4000-8000-000000000001', '11000000-0000-4000-8000-000000000001', 'Stasis', 'stasis', 'Coordinador sintetico del catalogo Product local.', true, 'available', 'free', 10, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'stasis', NULL, '["coordination", "orientation"]'::jsonb, 'published', ARRAY['product'], 'es-ES', '{"iconKey":"stasis","searchAliases":["asistente central"]}'::jsonb, 'coordinator', NULL, true, '2026-01-01T00:00:00Z', NULL),
  ('21000000-0000-4000-8000-000000000002', '11000000-0000-4000-8000-000000000002', 'Salus', 'health', 'Jefatura sintetica del area de Salud.', true, 'available', 'free', 10, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'salus', NULL, '["health-navigation"]'::jsonb, 'published', ARRAY['product'], 'es-ES', '{"iconKey":"health","searchAliases":["salud"]}'::jsonb, 'branch_chief', '21000000-0000-4000-8000-000000000001', false, '2026-01-01T00:00:00Z', NULL),
  ('21000000-0000-4000-8000-000000000003', '11000000-0000-4000-8000-000000000003', 'Sintoma', 'health', 'Registro sintetico en borrador para orientacion de sintomas.', false, 'available', 'free', 20, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'sintoma', 'Sintomas', '["symptom-journal"]'::jsonb, 'draft', ARRAY['product'], 'es-ES', '{"iconKey":"symptom","searchAliases":["sintomas"]}'::jsonb, 'specialist', '21000000-0000-4000-8000-000000000002', true, NULL, NULL),
  ('21000000-0000-4000-8000-000000000004', '11000000-0000-4000-8000-000000000004', 'Cardia', 'health', 'Especialista sintetico temporalmente no disponible.', true, 'unavailable', 'free', 30, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'cardia', 'Cardiovascular', '["cardiovascular-education"]'::jsonb, 'published', ARRAY['product'], 'es-ES', '{"iconKey":"heart","searchAliases":["tension"]}'::jsonb, 'specialist', '21000000-0000-4000-8000-000000000002', true, '2026-01-01T00:00:00Z', NULL),
  ('21000000-0000-4000-8000-000000000005', '11000000-0000-4000-8000-000000000005', 'Motus', 'health', 'Especialista sintetico de movilidad y seguimiento de molestias.', true, 'available', 'vip', 40, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'motus', 'Movilidad', '["mobility-journal", "pain-tracking"]'::jsonb, 'published', ARRAY['product'], 'es-ES', '{"iconKey":"mobility","searchAliases":["dolor","movilidad"]}'::jsonb, 'specialist', '21000000-0000-4000-8000-000000000002', true, '2026-01-01T00:00:00Z', NULL),
  ('21000000-0000-4000-8000-000000000006', '11000000-0000-4000-8000-000000000006', 'Nutria', 'nutrition', 'Jefatura sintetica del area de Nutricion.', true, 'available', 'free', 10, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'nutria', NULL, '["nutrition-navigation"]'::jsonb, 'published', ARRAY['product'], 'es-ES', '{"iconKey":"nutrition","searchAliases":["nutricion"]}'::jsonb, 'branch_chief', '21000000-0000-4000-8000-000000000001', false, '2026-01-01T00:00:00Z', NULL),
  ('21000000-0000-4000-8000-000000000007', '11000000-0000-4000-8000-000000000007', 'Fuel', 'nutrition', 'Especialista sintetico de nutricion deportiva.', true, 'available', 'pro', 20, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'fuel', 'Nutricion deportiva', '["sports-nutrition", "training-fuel"]'::jsonb, 'published', ARRAY['product'], 'es-ES', '{"iconKey":"fuel","searchAliases":["nutricion deportiva"]}'::jsonb, 'specialist', '21000000-0000-4000-8000-000000000006', true, '2026-01-01T00:00:00Z', NULL),
  ('21000000-0000-4000-8000-000000000008', '11000000-0000-4000-8000-000000000008', 'Menu', 'nutrition', 'Especialista sintetico de organizacion de menus.', true, 'available', 'free', 30, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'menu', 'Planificacion', '["meal-planning"]'::jsonb, 'published', ARRAY['product'], 'es-ES', '{"iconKey":"menu","searchAliases":["comidas","plan semanal"]}'::jsonb, 'specialist', '21000000-0000-4000-8000-000000000006', true, '2026-01-01T00:00:00Z', NULL),
  ('21000000-0000-4000-8000-000000000009', '11000000-0000-4000-8000-000000000009', 'Emocion', 'nutrition', 'Especialista sintetico de alimentacion emocional.', true, 'available', 'vip', 40, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'emocion', 'Alimentacion emocional', '["emotional-eating-journal"]'::jsonb, 'published', ARRAY['product'], 'es-ES', '{"iconKey":"emotion","searchAliases":["hambre emocional"]}'::jsonb, 'specialist', '21000000-0000-4000-8000-000000000006', true, '2026-01-01T00:00:00Z', NULL),
  ('21000000-0000-4000-8000-000000000010', '11000000-0000-4000-8000-000000000010', 'Atlas', 'training', 'Jefatura sintetica del area de Entrenamiento.', true, 'available', 'free', 10, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'atlas', NULL, '["training-navigation"]'::jsonb, 'published', ARRAY['product'], 'es-ES', '{"iconKey":"training","searchAliases":["entrenamiento"]}'::jsonb, 'branch_chief', '21000000-0000-4000-8000-000000000001', false, '2026-01-01T00:00:00Z', NULL),
  ('21000000-0000-4000-8000-000000000011', '11000000-0000-4000-8000-000000000011', 'Kitesurf', 'training', 'Especialista sintetico de preparacion para kitesurf.', true, 'available', 'free', 20, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'kitesurf', 'Deportes acuaticos', '["kitesurf-preparation", "mobility"]'::jsonb, 'published', ARRAY['product'], 'es-ES', '{"iconKey":"kitesurf","searchAliases":["kite","kiteboarding"],"experienceLevel":["beginner","intermediate","advanced"]}'::jsonb, 'specialist', '21000000-0000-4000-8000-000000000010', true, '2026-01-01T00:00:00Z', NULL),
  ('21000000-0000-4000-8000-000000000012', '11000000-0000-4000-8000-000000000012', 'CrossFit', 'training', 'Especialista sintetico de entrenamiento funcional CrossFit.', true, 'available', 'pro', 30, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'crossfit', 'Entrenamiento funcional', '["functional-training", "workout-planning"]'::jsonb, 'published', ARRAY['product'], 'es-ES', '{"iconKey":"crossfit","searchAliases":["cross training"]}'::jsonb, 'specialist', '21000000-0000-4000-8000-000000000010', true, '2026-01-01T00:00:00Z', NULL),
  ('21000000-0000-4000-8000-000000000013', '11000000-0000-4000-8000-000000000013', 'HYROX', 'training', 'Especialista sintetico HYROX temporalmente no disponible.', true, 'unavailable', 'pro', 40, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'hyrox', 'Carreras hibridas', '["hybrid-racing"]'::jsonb, 'published', ARRAY['product'], 'es-ES', '{"iconKey":"hyrox","searchAliases":["hybrid race"]}'::jsonb, 'specialist', '21000000-0000-4000-8000-000000000010', true, '2026-01-01T00:00:00Z', NULL),
  ('21000000-0000-4000-8000-000000000014', '11000000-0000-4000-8000-000000000014', 'Yoga', 'training', 'Especialista sintetico de yoga y movilidad consciente.', true, 'available', 'free', 50, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'yoga', 'Movilidad consciente', '["yoga", "mobility"]'::jsonb, 'published', ARRAY['product'], 'es-ES', '{"iconKey":"yoga","searchAliases":["movilidad consciente"]}'::jsonb, 'specialist', '21000000-0000-4000-8000-000000000010', true, '2026-01-01T00:00:00Z', NULL),
  ('21000000-0000-4000-8000-000000000015', '11000000-0000-4000-8000-000000000015', 'Pilates', 'training', 'Especialista sintetico en borrador de Pilates.', false, 'available', 'vip', 60, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'pilates', 'Core y movilidad', '["pilates", "core-mobility"]'::jsonb, 'draft', ARRAY['product'], 'es-ES', '{"iconKey":"pilates","searchAliases":["core"]}'::jsonb, 'specialist', '21000000-0000-4000-8000-000000000010', true, NULL, NULL),
  ('21000000-0000-4000-8000-000000000016', '11000000-0000-4000-8000-000000000016', 'Sofia', 'wellness', 'Jefatura sintetica del area de Wellness.', true, 'available', 'free', 10, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'sofia', NULL, '["wellness-navigation"]'::jsonb, 'published', ARRAY['product'], 'es-ES', '{"iconKey":"wellness","searchAliases":["bienestar"]}'::jsonb, 'branch_chief', '21000000-0000-4000-8000-000000000001', false, '2026-01-01T00:00:00Z', NULL),
  ('21000000-0000-4000-8000-000000000017', '11000000-0000-4000-8000-000000000017', 'Somno', 'wellness', 'Especialista sintetico de rutinas y registro de sueno.', true, 'available', 'free', 20, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'somno', 'Sueno', '["sleep-routines", "sleep-journal"]'::jsonb, 'published', ARRAY['product'], 'es-ES', '{"iconKey":"sleep","searchAliases":["sueno","descanso"]}'::jsonb, 'specialist', '21000000-0000-4000-8000-000000000016', true, '2026-01-01T00:00:00Z', NULL),
  ('21000000-0000-4000-8000-000000000018', '11000000-0000-4000-8000-000000000018', 'Loto', 'wellness', 'Especialista sintetico publicado pero no conversable.', true, 'available', 'pro', 30, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'loto', 'Mindfulness', '["mindfulness-practice"]'::jsonb, 'published', ARRAY['product'], 'es-ES', '{"iconKey":"mindfulness","searchAliases":["meditacion"]}'::jsonb, 'specialist', '21000000-0000-4000-8000-000000000016', false, '2026-01-01T00:00:00Z', NULL),
  ('21000000-0000-4000-8000-000000000019', '11000000-0000-4000-8000-000000000019', 'Calma', 'wellness', 'Especialista sintetico no publicado para gestion del estres.', false, 'available', 'free', 40, '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z', 'calma', 'Estres', '["stress-journal"]'::jsonb, 'unpublished', ARRAY['product'], 'es-ES', '{"iconKey":"calm","searchAliases":["estres","calma"]}'::jsonb, 'specialist', '21000000-0000-4000-8000-000000000016', true, NULL, '2026-01-01T00:00:00Z')
ON CONFLICT (id) DO NOTHING;

COMMIT;

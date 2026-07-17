BEGIN;
CREATE EXTENSION IF NOT EXISTS pgtap WITH SCHEMA extensions;
SELECT plan(1);
SELECT is(
  (SELECT count(*)::bigint FROM auth.users WHERE email LIKE 'foundation_013d_%@example.invalid'),
  0::bigint,
  'FOUNDATION-013D transactional fixtures leave zero residue'
);
SELECT * FROM finish();
ROLLBACK;

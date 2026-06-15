-- Micro-paquete 2B-II: perfil propio mínimo sobre public.users.
-- RLS limita filas; los grants de columna limitan la superficie visible.
BEGIN;

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_catalog.pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'users'
  ) THEN
    RAISE EXCEPTION
      'Unexpected policies exist on public.users before 2B-II';
  END IF;
END
$$;

REVOKE ALL PRIVILEGES ON TABLE public.users
  FROM PUBLIC, anon, authenticated;

CREATE POLICY users_select_own_minimal
ON public.users
FOR SELECT
TO authenticated
USING (id = (SELECT auth.uid()));

CREATE POLICY users_update_own_display_name
ON public.users
FOR UPDATE
TO authenticated
USING (id = (SELECT auth.uid()))
WITH CHECK (id = (SELECT auth.uid()));

GRANT SELECT (id, display_name)
ON TABLE public.users
TO authenticated;

GRANT UPDATE (display_name)
ON TABLE public.users
TO authenticated;

COMMIT;

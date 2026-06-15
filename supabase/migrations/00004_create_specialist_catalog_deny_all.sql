-- Micro-paquete 2B-III-A: catálogo sanitizado vacío y tablas de especialistas
-- cerradas a clientes por defecto. No crea policies permisivas ni datos.
BEGIN;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_catalog.pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'specialists'
  ) THEN
    RAISE EXCEPTION
      'Unexpected policies exist on public.specialists before 2B-III-A';
  END IF;
END
$$;

CREATE TABLE public.specialist_catalog (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  specialist_id UUID NOT NULL UNIQUE
    REFERENCES public.specialists(id) ON DELETE RESTRICT,
  display_name TEXT NOT NULL,
  product_area TEXT NOT NULL,
  short_description TEXT NOT NULL,
  is_published BOOLEAN NOT NULL DEFAULT false,
  availability_status TEXT NOT NULL DEFAULT 'unavailable',
  access_tier TEXT NOT NULL DEFAULT 'free',
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT specialist_catalog_display_name_valid
    CHECK (
      display_name = btrim(display_name)
      AND char_length(display_name) BETWEEN 1 AND 80
    ),
  CONSTRAINT specialist_catalog_product_area_valid
    CHECK (
      product_area IN ('stasis', 'health', 'nutrition', 'training', 'wellness')
    ),
  CONSTRAINT specialist_catalog_short_description_valid
    CHECK (
      short_description = btrim(short_description)
      AND char_length(short_description) BETWEEN 1 AND 240
    ),
  CONSTRAINT specialist_catalog_availability_status_valid
    CHECK (availability_status IN ('available', 'unavailable')),
  CONSTRAINT specialist_catalog_access_tier_valid
    CHECK (access_tier IN ('free', 'premium')),
  CONSTRAINT specialist_catalog_sort_order_valid
    CHECK (sort_order >= 0)
);

CREATE INDEX idx_specialist_catalog_published_listing
ON public.specialist_catalog(product_area, sort_order, display_name, id)
WHERE is_published = true;

ALTER TABLE public.specialists ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.specialist_catalog ENABLE ROW LEVEL SECURITY;

REVOKE ALL PRIVILEGES ON TABLE public.specialists
  FROM PUBLIC, anon, authenticated;
REVOKE ALL PRIVILEGES ON TABLE public.specialist_catalog
  FROM PUBLIC, anon, authenticated;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_catalog.pg_policies
    WHERE schemaname = 'public'
      AND tablename IN ('specialists', 'specialist_catalog')
  ) THEN
    RAISE EXCEPTION
      'Unexpected policies exist after 2B-III-A';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM pg_catalog.pg_class c
    JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
    WHERE n.nspname = 'public'
      AND c.relname IN ('specialists', 'specialist_catalog')
      AND (NOT c.relrowsecurity OR c.relforcerowsecurity)
  ) THEN
    RAISE EXCEPTION
      '2B-III-A requires RLS enabled without FORCE RLS';
  END IF;
END
$$;

COMMIT;

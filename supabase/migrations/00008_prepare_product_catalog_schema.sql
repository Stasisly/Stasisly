-- 2B-AG111: prepare product catalog schema for future synthetic catalog.
-- Local schema migration only. No policies, no seeds and no data population.
BEGIN;

ALTER TABLE public.specialist_catalog
  ADD COLUMN IF NOT EXISTS slug TEXT;

UPDATE public.specialist_catalog
SET slug = 'catalog-' || replace(extensions.uuid_generate_v4()::TEXT, '-', '')
WHERE slug IS NULL;

ALTER TABLE public.specialist_catalog
  ALTER COLUMN slug SET NOT NULL,
  ALTER COLUMN slug SET DEFAULT (
    'catalog-' || replace(extensions.uuid_generate_v4()::TEXT, '-', '')
  );

ALTER TABLE public.specialist_catalog
  ADD COLUMN IF NOT EXISTS subcategory TEXT,
  ADD COLUMN IF NOT EXISTS public_capabilities JSONB NOT NULL DEFAULT '[]'::JSONB,
  ADD COLUMN IF NOT EXISTS publication_status TEXT NOT NULL DEFAULT 'draft',
  ADD COLUMN IF NOT EXISTS supported_surfaces TEXT[] NOT NULL DEFAULT ARRAY['product']::TEXT[],
  ADD COLUMN IF NOT EXISTS locale TEXT NOT NULL DEFAULT 'es-ES',
  ADD COLUMN IF NOT EXISTS public_metadata JSONB NOT NULL DEFAULT '{}'::JSONB,
  ADD COLUMN IF NOT EXISTS hierarchy_role TEXT NOT NULL DEFAULT 'specialist',
  ADD COLUMN IF NOT EXISTS parent_catalog_id UUID REFERENCES public.specialist_catalog(id) ON DELETE RESTRICT,
  ADD COLUMN IF NOT EXISTS is_conversable BOOLEAN NOT NULL DEFAULT true,
  ADD COLUMN IF NOT EXISTS published_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS unpublished_at TIMESTAMPTZ;

UPDATE public.specialist_catalog
SET access_tier = 'pro'
WHERE access_tier = 'premium';

UPDATE public.specialist_catalog
SET publication_status = CASE
    WHEN is_published THEN 'published'
    ELSE 'draft'
  END
WHERE publication_status = 'draft';

ALTER TABLE public.specialist_catalog
  DROP CONSTRAINT IF EXISTS specialist_catalog_availability_status_valid,
  DROP CONSTRAINT IF EXISTS specialist_catalog_access_tier_valid;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_catalog.pg_constraint
    WHERE conname = 'specialist_catalog_slug_valid'
      AND conrelid = 'public.specialist_catalog'::regclass
  ) THEN
    ALTER TABLE public.specialist_catalog
      ADD CONSTRAINT specialist_catalog_slug_valid
      CHECK (
        slug = lower(btrim(slug))
        AND char_length(slug) BETWEEN 3 AND 80
        AND slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'
      );
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_catalog.pg_constraint
    WHERE conname = 'specialist_catalog_subcategory_valid'
      AND conrelid = 'public.specialist_catalog'::regclass
  ) THEN
    ALTER TABLE public.specialist_catalog
      ADD CONSTRAINT specialist_catalog_subcategory_valid
      CHECK (
        subcategory IS NULL
        OR (
          subcategory = btrim(subcategory)
          AND char_length(subcategory) BETWEEN 1 AND 80
        )
      );
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_catalog.pg_constraint
    WHERE conname = 'specialist_catalog_public_capabilities_valid'
      AND conrelid = 'public.specialist_catalog'::regclass
  ) THEN
    ALTER TABLE public.specialist_catalog
      ADD CONSTRAINT specialist_catalog_public_capabilities_valid
      CHECK (jsonb_typeof(public_capabilities) = 'array');
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_catalog.pg_constraint
    WHERE conname = 'specialist_catalog_publication_status_valid'
      AND conrelid = 'public.specialist_catalog'::regclass
  ) THEN
    ALTER TABLE public.specialist_catalog
      ADD CONSTRAINT specialist_catalog_publication_status_valid
      CHECK (
        publication_status IN (
          'draft',
          'review',
          'published',
          'unpublished',
          'disabled',
          'maintenance'
        )
      );
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_catalog.pg_constraint
    WHERE conname = 'specialist_catalog_is_published_consistent'
      AND conrelid = 'public.specialist_catalog'::regclass
  ) THEN
    ALTER TABLE public.specialist_catalog
      ADD CONSTRAINT specialist_catalog_is_published_consistent
      CHECK (is_published = (publication_status = 'published'));
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_catalog.pg_constraint
    WHERE conname = 'specialist_catalog_availability_status_valid'
      AND conrelid = 'public.specialist_catalog'::regclass
  ) THEN
    ALTER TABLE public.specialist_catalog
      ADD CONSTRAINT specialist_catalog_availability_status_valid
      CHECK (
        availability_status IN (
          'available',
          'limited',
          'unavailable',
          'coming_soon'
        )
      );
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_catalog.pg_constraint
    WHERE conname = 'specialist_catalog_access_tier_valid'
      AND conrelid = 'public.specialist_catalog'::regclass
  ) THEN
    ALTER TABLE public.specialist_catalog
      ADD CONSTRAINT specialist_catalog_access_tier_valid
      CHECK (access_tier IN ('free', 'pro', 'vip'));
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_catalog.pg_constraint
    WHERE conname = 'specialist_catalog_supported_surfaces_valid'
      AND conrelid = 'public.specialist_catalog'::regclass
  ) THEN
    ALTER TABLE public.specialist_catalog
      ADD CONSTRAINT specialist_catalog_supported_surfaces_valid
      CHECK (supported_surfaces = ARRAY['product']::TEXT[]);
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_catalog.pg_constraint
    WHERE conname = 'specialist_catalog_locale_valid'
      AND conrelid = 'public.specialist_catalog'::regclass
  ) THEN
    ALTER TABLE public.specialist_catalog
      ADD CONSTRAINT specialist_catalog_locale_valid
      CHECK (
        locale = btrim(locale)
        AND char_length(locale) BETWEEN 2 AND 16
        AND locale ~ '^[a-z]{2}(-[A-Z]{2})?$'
      );
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_catalog.pg_constraint
    WHERE conname = 'specialist_catalog_public_metadata_valid'
      AND conrelid = 'public.specialist_catalog'::regclass
  ) THEN
    ALTER TABLE public.specialist_catalog
      ADD CONSTRAINT specialist_catalog_public_metadata_valid
      CHECK (jsonb_typeof(public_metadata) = 'object');
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_catalog.pg_constraint
    WHERE conname = 'specialist_catalog_hierarchy_role_valid'
      AND conrelid = 'public.specialist_catalog'::regclass
  ) THEN
    ALTER TABLE public.specialist_catalog
      ADD CONSTRAINT specialist_catalog_hierarchy_role_valid
      CHECK (
        hierarchy_role IN (
          'coordinator',
          'branch_chief',
          'subcategory_chief',
          'specialist'
        )
      );
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_catalog.pg_constraint
    WHERE conname = 'specialist_catalog_parent_not_self'
      AND conrelid = 'public.specialist_catalog'::regclass
  ) THEN
    ALTER TABLE public.specialist_catalog
      ADD CONSTRAINT specialist_catalog_parent_not_self
      CHECK (parent_catalog_id IS NULL OR parent_catalog_id <> id);
  END IF;
END
$$;

CREATE OR REPLACE FUNCTION public.set_specialist_catalog_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION public.set_specialist_catalog_updated_at()
  FROM PUBLIC, anon, authenticated;

DROP TRIGGER IF EXISTS set_specialist_catalog_updated_at
  ON public.specialist_catalog;

CREATE TRIGGER set_specialist_catalog_updated_at
BEFORE UPDATE ON public.specialist_catalog
FOR EACH ROW
EXECUTE FUNCTION public.set_specialist_catalog_updated_at();

CREATE UNIQUE INDEX IF NOT EXISTS idx_specialist_catalog_product_slug_unique
ON public.specialist_catalog(product_area, slug);

CREATE INDEX IF NOT EXISTS idx_specialist_catalog_product_listing_v2
ON public.specialist_catalog(
  product_area,
  sort_order,
  display_name,
  id
)
WHERE
  publication_status = 'published'
  AND is_published = true
  AND availability_status IN ('available', 'limited')
  AND supported_surfaces = ARRAY['product']::TEXT[];

CREATE INDEX IF NOT EXISTS idx_specialist_catalog_product_access_v2
ON public.specialist_catalog(
  publication_status,
  availability_status,
  access_tier,
  product_area
);

CREATE INDEX IF NOT EXISTS idx_specialist_catalog_parent_catalog
ON public.specialist_catalog(parent_catalog_id);

CREATE INDEX IF NOT EXISTS idx_specialist_catalog_supported_surfaces_gin
ON public.specialist_catalog USING GIN (supported_surfaces);

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
      'Unexpected policies exist after 2B-AG111 product catalog migration';
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
      '2B-AG111 requires RLS enabled without FORCE RLS';
  END IF;

  IF has_table_privilege('anon', 'public.specialist_catalog', 'SELECT')
    OR has_table_privilege('authenticated', 'public.specialist_catalog', 'SELECT')
    OR has_table_privilege('anon', 'public.specialist_catalog', 'INSERT')
    OR has_table_privilege('authenticated', 'public.specialist_catalog', 'INSERT')
    OR has_table_privilege('anon', 'public.specialist_catalog', 'UPDATE')
    OR has_table_privilege('authenticated', 'public.specialist_catalog', 'UPDATE')
    OR has_table_privilege('anon', 'public.specialist_catalog', 'DELETE')
    OR has_table_privilege('authenticated', 'public.specialist_catalog', 'DELETE')
  THEN
    RAISE EXCEPTION
      '2B-AG111 requires no client table privileges on specialist_catalog';
  END IF;
END
$$;

COMMIT;

import { type AccessState, calculateAccessState } from "./access_state.ts";

export const PUBLIC_AREAS = [
  "stasis",
  "health",
  "nutrition",
  "training",
  "wellness",
] as const;

export type PublicArea = typeof PUBLIC_AREAS[number];

export interface SelectableSpecialist {
  id: string;
  displayName: string;
  area: PublicArea;
  shortDescription: string;
  accessState: AccessState;
  isDemo: false;
}

const EXPECTED_INTERNAL_KEYS = [
  "access_tier",
  "availability_status",
  "display_name",
  "id",
  "is_published",
  "product_area",
  "short_description",
  "sort_order",
  "specialist_id",
].sort();

const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

function isPublicArea(value: unknown): value is PublicArea {
  return typeof value === "string" &&
    PUBLIC_AREAS.includes(value as PublicArea);
}

function assertExactInternalKeys(row: Record<string, unknown>): void {
  const actual = Object.keys(row).sort();
  if (
    actual.length !== EXPECTED_INTERNAL_KEYS.length ||
    actual.some((key, index) => key !== EXPECTED_INTERNAL_KEYS[index])
  ) {
    throw new Error("catalogContractViolation");
  }
}

export function parseAreaFilter(url: URL): PublicArea | undefined {
  if ([...url.searchParams.keys()].some((key) => key !== "area")) {
    throw new Error("catalogInvalidRequest");
  }
  const values = url.searchParams.getAll("area");
  if (values.length === 0) return undefined;
  if (values.length !== 1 || !isPublicArea(values[0])) {
    throw new Error("catalogInvalidArea");
  }
  return values[0];
}

export function sanitizeCatalogRows(input: unknown): SelectableSpecialist[] {
  if (!Array.isArray(input)) {
    throw new Error("catalogContractViolation");
  }
  if (input.length > 20) {
    throw new Error("catalogContractViolation");
  }

  return input.map((value) => {
    if (typeof value !== "object" || value === null || Array.isArray(value)) {
      throw new Error("catalogContractViolation");
    }

    const row = value as Record<string, unknown>;
    assertExactInternalKeys(row);

    if (
      !UUID_PATTERN.test(String(row.id)) ||
      !UUID_PATTERN.test(String(row.specialist_id)) ||
      typeof row.display_name !== "string" ||
      row.display_name.length === 0 ||
      typeof row.short_description !== "string" ||
      row.short_description.length === 0 ||
      !isPublicArea(row.product_area) ||
      row.is_published !== true ||
      !Number.isInteger(row.sort_order)
    ) {
      throw new Error("catalogContractViolation");
    }

    return {
      id: row.id as string,
      displayName: row.display_name,
      area: row.product_area,
      shortDescription: row.short_description,
      accessState: calculateAccessState(
        row.availability_status,
        row.access_tier,
      ),
      isDemo: false,
    };
  });
}

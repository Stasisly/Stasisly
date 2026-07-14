export type AccessState = "available" | "lockedPro" | "unavailable";

export function calculateAccessState(
  availabilityStatus: unknown,
  accessTier: unknown,
): AccessState {
  if (availabilityStatus === "unavailable") {
    if (accessTier !== "free" && accessTier !== "pro" && accessTier !== "vip") {
      throw new Error("catalogContractViolation");
    }
    return "unavailable";
  }

  if (availabilityStatus !== "available") {
    throw new Error("catalogContractViolation");
  }

  if (accessTier === "free") {
    return "available";
  }
  if (accessTier === "pro" || accessTier === "vip") {
    return "lockedPro";
  }

  throw new Error("catalogContractViolation");
}

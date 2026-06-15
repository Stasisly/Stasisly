export type AccessState = "available" | "lockedPremium" | "unavailable";

export function calculateAccessState(
  availabilityStatus: unknown,
  accessTier: unknown,
): AccessState {
  if (availabilityStatus === "unavailable") {
    if (accessTier !== "free" && accessTier !== "premium") {
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
  if (accessTier === "premium") {
    return "lockedPremium";
  }

  throw new Error("catalogContractViolation");
}

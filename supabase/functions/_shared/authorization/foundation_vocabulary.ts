export type FoundationSurface =
  | "product"
  | "development"
  | "administration"
  | "platform"
  | "sharedInfrastructure"
  | "unknown";

export type FoundationEnvironment =
  | "local"
  | "development"
  | "staging"
  | "production"
  | "unknown";

export type FoundationAction =
  | "read"
  | "create"
  | "update"
  | "delete"
  | "execute"
  | "approve"
  | "configure"
  | "administer"
  | "export"
  | "delegate"
  | "elevate"
  | "unknown";

export type FoundationResourceType =
  | "specialistCatalog"
  | "chatSession"
  | "chatMessage"
  | "unknown";

export type BackendIdentityType = "human" | "unknown";

export type BackendAuthenticationState =
  | "authenticated"
  | "unauthenticated"
  | "invalid"
  | "unknown";

export type BackendOwnershipState =
  | "owned"
  | "notOwned"
  | "notApplicable"
  | "unknown";

export type BackendRequestSource = "edgeFunction" | "unknown";

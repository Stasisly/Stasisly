import type {
  FoundationAction,
  FoundationEnvironment,
  FoundationResourceType,
  FoundationSurface,
} from "./foundation_vocabulary.ts";

export type BackendOperationId =
  | "listSelectableSpecialists"
  | "createOwnChatSession"
  | "listOwnChatSessions"
  | "archiveOwnChatSession"
  | "listSessionMessages"
  | "sendUserMessage";

export interface BackendOperationDefinition {
  readonly operationId: BackendOperationId;
  readonly expectedSurface: FoundationSurface;
  readonly allowedEnvironments: readonly FoundationEnvironment[];
  readonly action: FoundationAction;
  readonly resourceType: FoundationResourceType;
  readonly authenticationRequired: boolean;
  readonly ownershipRequired: boolean;
  readonly entitlementRequired: false;
  readonly auditRequired: boolean;
}

function operation(
  definition: BackendOperationDefinition,
): BackendOperationDefinition {
  return Object.freeze({
    ...definition,
    allowedEnvironments: Object.freeze([...definition.allowedEnvironments]),
  });
}

const PRODUCT_ENVIRONMENTS = ["local", "development"] as const;

export const BACKEND_OPERATIONS = Object.freeze({
  listSelectableSpecialists: operation({
    operationId: "listSelectableSpecialists",
    expectedSurface: "product",
    allowedEnvironments: PRODUCT_ENVIRONMENTS,
    action: "read",
    resourceType: "specialistCatalog",
    authenticationRequired: true,
    ownershipRequired: false,
    entitlementRequired: false,
    auditRequired: true,
  }),
  createOwnChatSession: operation({
    operationId: "createOwnChatSession",
    expectedSurface: "product",
    allowedEnvironments: PRODUCT_ENVIRONMENTS,
    action: "create",
    resourceType: "chatSession",
    authenticationRequired: true,
    ownershipRequired: true,
    entitlementRequired: false,
    auditRequired: true,
  }),
  listOwnChatSessions: operation({
    operationId: "listOwnChatSessions",
    expectedSurface: "product",
    allowedEnvironments: PRODUCT_ENVIRONMENTS,
    action: "read",
    resourceType: "chatSession",
    authenticationRequired: true,
    ownershipRequired: true,
    entitlementRequired: false,
    auditRequired: true,
  }),
  archiveOwnChatSession: operation({
    operationId: "archiveOwnChatSession",
    expectedSurface: "product",
    allowedEnvironments: PRODUCT_ENVIRONMENTS,
    action: "update",
    resourceType: "chatSession",
    authenticationRequired: true,
    ownershipRequired: true,
    entitlementRequired: false,
    auditRequired: true,
  }),
  listSessionMessages: operation({
    operationId: "listSessionMessages",
    expectedSurface: "product",
    allowedEnvironments: PRODUCT_ENVIRONMENTS,
    action: "read",
    resourceType: "chatMessage",
    authenticationRequired: true,
    ownershipRequired: true,
    entitlementRequired: false,
    auditRequired: true,
  }),
  sendUserMessage: operation({
    operationId: "sendUserMessage",
    expectedSurface: "product",
    allowedEnvironments: PRODUCT_ENVIRONMENTS,
    action: "create",
    resourceType: "chatMessage",
    authenticationRequired: true,
    ownershipRequired: true,
    entitlementRequired: false,
    auditRequired: true,
  }),
});

export function registeredOperation(
  operationId: BackendOperationId,
): BackendOperationDefinition {
  return BACKEND_OPERATIONS[operationId];
}

export function isRegisteredOperation(
  definition: BackendOperationDefinition,
): boolean {
  const registered = registeredOperation(definition.operationId);
  return registered === definition;
}

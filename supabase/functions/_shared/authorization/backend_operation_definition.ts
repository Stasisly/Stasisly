import type {
  FoundationAction,
  FoundationEnvironment,
  FoundationResourceType,
  FoundationSurface,
} from "./foundation_vocabulary.ts";

export type BackendOperationId =
  | "listSelectableSpecialists"
  | "createOwnChatSession"
  | "conversation.listOwn"
  | "conversation.readOwn"
  | "conversation.archiveOwn"
  | "conversation.restoreOwn"
  | "conversation.message.listOwn"
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
    operationId: "conversation.listOwn",
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
    operationId: "conversation.archiveOwn",
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
    operationId: "conversation.message.listOwn",
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
  readOwnConversation: operation({
    operationId: "conversation.readOwn",
    expectedSurface: "product",
    allowedEnvironments: PRODUCT_ENVIRONMENTS,
    action: "read",
    resourceType: "chatSession",
    authenticationRequired: true,
    ownershipRequired: true,
    entitlementRequired: false,
    auditRequired: true,
  }),
  restoreOwnConversation: operation({
    operationId: "conversation.restoreOwn",
    expectedSurface: "product",
    allowedEnvironments: PRODUCT_ENVIRONMENTS,
    action: "update",
    resourceType: "chatSession",
    authenticationRequired: true,
    ownershipRequired: true,
    entitlementRequired: false,
    auditRequired: true,
  }),
});

export function registeredOperation(
  operationId: BackendOperationId,
): BackendOperationDefinition {
  const registered = Object.values(BACKEND_OPERATIONS).find(
    (definition) => definition.operationId === operationId,
  );
  if (!registered) throw new Error("operationNotRegistered");
  return registered;
}

export function isRegisteredOperation(
  definition: BackendOperationDefinition,
): boolean {
  const registered = registeredOperation(definition.operationId);
  return registered === definition;
}

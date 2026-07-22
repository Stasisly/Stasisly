# Stasisly Foundation

## FOUNDATION-019B Supabase CLI isolation

FOUNDATION-019B is `IMPLEMENTED_LOCALLY`: ignored remote-link metadata has been
isolated without recording its values, local Supabase remains functional and a
read-only/no-network preflight blocks recurrence. See [ADR-F022](adr/ADR-F022-supabase-cli-remote-context-isolation.md)
and the [implementation record](implementation/FOUNDATION-019B_SUPABASE_CLI_REMOTE_CONTEXT_ISOLATION.md).
FOUNDATION-018 is only `READY_TO_RETRY`; no remote operation is authorized.

Run the local safety gate before local-only Supabase work:

```bash
dart run tool/check_supabase_remote_context.dart
```

## FOUNDATION-017 post-activation hardening

FOUNDATION-017 is `IMPLEMENTED_LOCALLY`: canonical Product Conversation now
uses closed local-safe outcome observability with a runtime NoOp sink, hardened
partial failures/races and locally audited accessibility/responsive behavior.
ADR-F020 and the [implementation record](implementation/FOUNDATION-017_PRODUCT_CONVERSATION_POST_ACTIVATION_HARDENING.md)
are authoritative. Remote telemetry, staging, production, AI and Engine remain
unauthorized/unimplemented.

## FOUNDATION-016-R1 physical legacy retirement

FOUNDATION-016 is `IMPLEMENTED_LOCALLY`: `lib/features/chat/**`, the dead
`OrchestratorChatPage` consumer and `/chat/:id` registration are physically
removed. Canonical Conversation is the sole Product architecture;
`chat_sessions`/`chat_messages` remain encapsulated transitional transport and
`/orchestrator*` remains blocked. See [ADR-F019](adr/ADR-F019-physical-legacy-chat-removal-and-reference-eradication.md)
and the [implementation record](implementation/FOUNDATION-016_PHYSICAL_LEGACY_CHAT_REMOVAL_AND_REFERENCE_ERADICATION.md).

## FOUNDATION-015-R1 controlled Product activation

FOUNDATION-015 is `IMPLEMENTED_LOCALLY`: `/stasis`, `/conversations` and
`/conversations/:conversationId` are canonical authenticated Product routes in
local/development only. ADR-F018 and the [implementation record](implementation/FOUNDATION-015-R1_CONTROLLED_PRODUCT_CONVERSATION_ROUTE_AND_SCREEN_ACTIVATION.md)
are authoritative. Legacy routes remain blocked; AI, Stasis Engine, specialist
responses, remote, staging and production remain unavailable.

## FOUNDATION-014-R1 Product consumer retirement

FOUNDATION-014 is resumed and `IMPLEMENTED_LOCALLY`: the four Product area CTAs
no longer use `agent.id`, `/chat/:id` or any conversation action. Because their
legacy display source has no verified `selectableSpecialistId`, they render a
shared non-actionable unavailable state. The canonical inactive composition is
the sole approved Product Conversation composition at that package boundary;
FOUNDATION-015-R1 subsequently activates its canonical Product routes. See the
[implementation record](implementation/FOUNDATION-014-R1_PRODUCT_CTA_MIGRATION_AND_LEGACY_WIRING_RETIREMENT.md)
and [ADR-F017](adr/ADR-F017-product-consumer-migration-and-legacy-wiring-retirement.md).

## FOUNDATION-013F canonical application composition

`FOUNDATION-013F` is `IMPLEMENTED_LOCALLY`: seven canonical use cases, typed
application state, pure-Dart controllers, local/development fail-closed
providers and `InactiveConversationFeatureHost` now form an executable local
validation boundary. That package introduced no route, shell, backend or remote
activation; FOUNDATION-015-R1 later activates only the local Product route and
screen layer. See the [implementation record](implementation/FOUNDATION-013F_CANONICAL_CONVERSATION_APPLICATION_AND_INACTIVE_COMPOSITION.md)
and [ADR-F016](adr/ADR-F016-canonical-conversation-application-and-inactive-composition.md).

## FOUNDATION-013F-R1 idempotent attempts

`FOUNDATION-013F-R1` adopts the provider-neutral `OperationAttemptId` contract
and explicit create/send propagation through canonical inputs, transitional
repositories/adapters and local HTTP headers. Datasource-owned generation is
removed. FOUNDATION-013F later consumed this contract locally; Product routes
and remote remain blocked. See the [implementation record](implementation/FOUNDATION-013F-R1_IDEMPOTENT_OPERATION_ATTEMPT_PROPAGATION.md)
and [ADR-F015](adr/ADR-F015-idempotent-operation-attempt-propagation.md).

## FOUNDATION-013E presentation boundary

`FOUNDATION-013E` adopts provider-neutral Conversation presentation primitives,
a fail-closed canonical Message view mapper and a content-only inert composer.
Legacy chat is centrally marked `DEPRECATED_AND_BLOCKED`, guarded against new
consumers and retained for later removal. No Product screen, route, provider,
backend or remote connection is implemented. See the [implementation record](implementation/FOUNDATION-013E_LEGACY_UI_EXTRACTION_FREEZE_AND_RETIREMENT_PREPARATION.md)
and [ADR-F014](adr/ADR-F014-legacy-chat-ui-extraction-and-freeze.md).

## FOUNDATION-013D message boundary

`FOUNDATION-013D` adopts locally the canonical Message author, provenance and
visibility contracts, backend-controlled user metadata and SQL-before-limit
visibility filtering. See the [implementation record](implementation/FOUNDATION-013D_CANONICAL_MESSAGE_AUTHOR_PROVENANCE_VISIBILITY.md)
and [ADR-F013](adr/ADR-F013-canonical-message-author-provenance-and-visibility.md).
Stasis/specialist messages, Engine traces, Product routes and remote remain
unimplemented.

## Estado

Índice Foundation activo. `FOUNDATION-001` congeló e inventarió el baseline;
`FOUNDATION-002` estableció la autoridad documental inicial y archivó
Descubrimiento; `FOUNDATION-003` estableció la Constitución y el gobierno
global; `FOUNDATION-004` definió la arquitectura técnica objetivo;
`FOUNDATION-005` auditó la implementación heredada frente a esa arquitectura;
y `FOUNDATION-005-R1` cerró localmente su P0 de tablas públicas legacy.
`FOUNDATION-006` establece la estrategia y secuencia maestra de reconstrucción;
`FOUNDATION-007` define el modelo conceptual de autorización; y
`FOUNDATION-008` implementa localmente los contratos propios de identidad,
sesión y contexto API con Supabase Auth confinado como adapter actual.
`FOUNDATION-009` adopta contratos tipados de autorización, puertos PDP/PEP y
una política local deny-by-default con integración focal de perfil propio; y
`FOUNDATION-010` implementa y valida localmente fronteras tipadas de surface y
entorno en rutas y providers focales, bloqueando chat/orchestrator legacy y
manteniendo Administration, Platform, remoto y producción sin activar.

La documentación Foundation registra decisiones y evidencia según su nivel de
autoridad. No demuestra por sí sola que una capacidad esté implementada.

## Baseline congelado

- Commit: `7f747e0 test: validate session creation by selectable specialist`.
- Tag anotado: `discovery-final-baseline`.
- Significado: estado final validado antes del inicio de Foundation.

## Documentos de FOUNDATION-001

- [Transición Foundation](FOUNDATION_TRANSITION.md)
- [Inventario del repositorio](REPOSITORY_INVENTORY.md)
- [Clasificación de activos](ASSET_CLASSIFICATION.md)
- [Inventario de proveedores y costes](VENDOR_AND_COST_INVENTORY.md)
- [Borrador de roadmap Foundation](FOUNDATION_ROADMAP_DRAFT.md)

## Gobierno y operación documental

- [Gobierno documental](DOCUMENTATION_GOVERNANCE.md)
- [Workflow de cambio y aprobación](CHANGE_AND_APPROVAL_WORKFLOW.md)
- [Registro de autoridad](DOCUMENT_AUTHORITY_REGISTER.md)
- [Índice del archivo Discovery](archive_index/DISCOVERY_ARCHIVE_INDEX.md)
- [Tracker de sesiones Foundation](implementation/FOUNDATION_SESSION_TRACKER.md)

## Constitución y gobierno global

- [Constitución Global](00_GLOBAL_CONSTITUTION.md)
- [Gobierno y Autoridad](01_GOVERNANCE_AND_AUTHORITY.md)
- [Surfaces y Acceso](02_SURFACES_AND_ACCESS.md)
- [Frontera de Stasis Engine](03_STASIS_ENGINE_BOUNDARY.md)
- [Gobierno del Roadmap](04_ROADMAP_GOVERNANCE.md)
- [ADR-F001 — Gobierno global, Founder, Nexus y surfaces](adr/ADR-F001-global-governance-founder-nexus-surfaces.md)

La estructura vigente es Founder sobre Nexus, con Stasis, Rector y Gerendi como
coordinadores exclusivos de Product Surface, Development Surface y
Administration Surface. Authority no concede Access; ninguna identidad hereda
Founder Authority ni acceso total.

## Arquitectura técnica global

- [Arquitectura Técnica Global](05_GLOBAL_TECHNICAL_ARCHITECTURE.md)
- [Fronteras de API y Servicios](06_API_AND_SERVICE_BOUNDARIES.md)
- [Portabilidad de Infraestructura](07_INFRASTRUCTURE_PORTABILITY.md)
- [Arquitectura Conceptual de Stasis Engine](08_STASIS_ENGINE_ARCHITECTURE.md)
- [Datos, Memoria y Eventos](09_DATA_MEMORY_AND_EVENTS.md)
- [Entornos y Trust Boundaries](10_ENVIRONMENTS_AND_TRUST_BOUNDARIES.md)
- [Preclasificación técnica de Descubrimiento](audits/DISCOVERY_TECHNICAL_ASSET_PRECLASSIFICATION.md)
- [ADR-F002 — Arquitectura técnica global y portabilidad](adr/ADR-F002-global-technical-architecture-and-portability.md)

PostgreSQL es la plataforma relacional canónica donde corresponda. Supabase es
un proveedor managed inicial, no la identidad del backend. Los clientes deben
preferir contratos propiedad de Stasisly y toda capacidad aquí descrita sigue
sin implementación Foundation.

## Auditoría de conformidad técnica

- [Auditoría técnica FOUNDATION-005](audits/FOUNDATION-005_TECHNICAL_CONFORMANCE_AUDIT.md)
- [Matriz de clasificación](audits/FOUNDATION-005_ASSET_CLASSIFICATION_MATRIX.md)
- [Scorecard de conformidad](audits/FOUNDATION-005_CONFORMANCE_SCORECARD.md)
- [Backlog de remediación](audits/FOUNDATION-005_REMEDIATION_BACKLOG.md)
- [Evidencia de tests](audits/FOUNDATION-005_TEST_EVIDENCE.md)
- [Cierre local FOUNDATION-005-R1](implementation/FOUNDATION-005-R1_LEGACY_PUBLIC_TABLES_DENY_ALL.md)

## Plan maestro de reconstrucción

- [Plan maestro de remediación](planning/FOUNDATION_MASTER_REMEDIATION_PLAN.md)
- [Mapa de paquetes ejecutables](planning/FOUNDATION_EXECUTION_PACKAGE_MAP.md)
- [Mapa de dependencias y gates](planning/FOUNDATION_DEPENDENCY_AND_GATE_MAP.md)
- [Plan de adopción de activos](planning/FOUNDATION_ASSET_ADOPTION_PLAN.md)
- [Registro de riesgos y deuda](planning/FOUNDATION_RISK_AND_DEBT_REGISTER.md)
- [Gates de decisión del Founder](planning/FOUNDATION_FOUNDER_DECISION_GATES.md)
- [ADR-F003 — Estrategia de reconstrucción](adr/ADR-F003-foundation-reconstruction-strategy.md)

## Seguridad y autorización técnica

- [Threat model Foundation](security/FOUNDATION_THREAT_MODEL.md)
- [Modelo técnico de autorización](security/TECHNICAL_AUTHORIZATION_MODEL.md)
- [Acceso y elevación Founder](security/FOUNDER_ACCESS_AND_ELEVATION_MODEL.md)
- [Identidades de servicios y agentes](security/SERVICE_AND_AGENT_IDENTITY_MODEL.md)
- [Matriz conceptual de decisiones](security/AUTHORIZATION_DECISION_MATRIX.md)
- [Matriz de amenazas y controles](security/THREAT_CONTROL_MATRIX.md)
- [Abuse cases de seguridad](security/SECURITY_ABUSE_CASES.md)
- [ADR-F004 — Autorización y threat model](adr/ADR-F004-technical-authorization-and-threat-model.md)

FOUNDATION-007 aprueba conceptualmente deny-by-default, RBAC+ABAC, contextos de
surface/entorno, ownership backend, JIT, niveles Founder, identidades técnicas,
PDP/PEP, auditoría y revocación. No implementa ninguno de esos controles.

## Identidad, sesión y contexto API

- [Implementación FOUNDATION-008](implementation/FOUNDATION-008_OWNED_IDENTITY_SESSION_API_CONTRACTS.md)
- [ADR-F005 — Contratos propios de identidad, sesión y API](adr/ADR-F005-owned-identity-session-and-api-contracts.md)

FOUNDATION-008 adopta localmente `StasislyIdentity`, `StasislySession`, estados
y errores neutrales, `IdentityProvider` y `ApiIdentityContext`. Supabase Auth es
`ADAPT / CURRENT_PROVIDER_ADAPTER`; la feature auth completa queda parcialmente
adaptada.

## Contexto y política de autorización

- [Implementación FOUNDATION-009](implementation/FOUNDATION-009_AUTHORIZATION_CONTEXT_AND_POLICY_CONTRACTS.md)
- [ADR-F006 — Contexto y decisiones PDP/PEP](adr/ADR-F006-authorization-context-and-policy-contracts.md)

FOUNDATION-009 adopta localmente `AuthorizationContext`, decisiones tipadas y
puertos PDP/PEP/audit. El PDP local solo valida el caso existente de lectura de
perfil propio en local/development. El enforcement global sigue parcial;
RBAC/ABAC persistente, Founder elevation, remoto y producción no se implementan.

## Fronteras de surface y entorno

- [Implementación FOUNDATION-010](implementation/FOUNDATION-010_SURFACE_AND_ENVIRONMENT_ENFORCEMENT.md)
- [ADR-F007 — Enforcement de surface y entorno](adr/ADR-F007-surface-and-environment-enforcement-boundaries.md)

FOUNDATION-010 adopta localmente `SurfaceBoundary`, `EnvironmentBoundary`,
metadata tipada por entry point y decisiones fail-closed. Product queda limitado a
local/development, Development solo a local/development, y las rutas heredadas
de chat/orchestrator no construyen capacidad. Backend sigue siendo autoridad.

## Autorización backend y API propia

- [Implementación FOUNDATION-011](implementation/FOUNDATION-011_BACKEND_AUTHORIZATION_CONTEXT_AND_OWNED_API_ENFORCEMENT.md)
- [ADR-F008 — Contexto backend y owned API](adr/ADR-F008-backend-authorization-context-and-owned-api-enforcement.md)

FOUNDATION-011 adopta localmente `BackendRequestContext`, un registro inmutable
de seis operaciones Product y contratos PDP/PEP fail-closed. Identidad y owner
se derivan de JWT validado y datos confiables; el cliente no aporta autoridad.
Solo local/development están permitidos. Remoto, producción, RBAC/ABAC
persistente, Founder access y nuevas capacidades Product siguen cerrados.

## Arquitectura Product de conversaciones

- [Arquitectura Product](product/PRODUCT_CONVERSATION_ARCHITECTURE.md)
- [Glosario](product/CONVERSATION_DOMAIN_GLOSSARY.md)
- [Ciclo de vida y ownership](product/CONVERSATION_LIFECYCLE_AND_OWNERSHIP.md)
- [Memoria y research](product/CONVERSATION_MEMORY_RESEARCH_BOUNDARIES.md)
- [Contratos API objetivo](product/CONVERSATION_API_TARGET_CONTRACTS.md)
- [Matriz de adopción](product/CONVERSATION_ASSET_ADOPTION_MATRIX.md)
- [Retirada del chat legacy](product/LEGACY_CHAT_RETIREMENT_PLAN.md)
- [ADR-F009](adr/ADR-F009-product-conversation-architecture-and-legacy-chat-retirement.md)
- [Implementación FOUNDATION-013A](implementation/FOUNDATION-013A_CANONICAL_CONVERSATION_CONTRACTS_AND_ADAPTERS.md)
- [ADR-F010](adr/ADR-F010-canonical-conversation-contracts-and-transitional-adapters.md)
- [Implementación FOUNDATION-013B](implementation/FOUNDATION-013B_TRANSACTIONAL_CONVERSATION_CREATION_AND_IDEMPOTENCY.md)
- [ADR-F011](adr/ADR-F011-transactional-conversation-creation-and-idempotency.md)
- [Implementación FOUNDATION-013C](implementation/FOUNDATION-013C_CANONICAL_CONVERSATION_READ_LIST_ARCHIVE_RESTORE.md)
- [ADR-F012](adr/ADR-F012-canonical-conversation-read-and-lifecycle-boundary.md)

FOUNDATION-012 aprueba `Conversation` como agregado Product y reserva
`ExecutionSession` al futuro runtime. Stasis coordina Product; historial,
ejecución, memoria, research y trazas permanecen separados. El chat legacy queda
`DEPRECATED_AND_BLOCKED`; FOUNDATION-015-R1 implementa después las rutas
`/stasis` y `/conversations` solo en local/development. Los activos modernos se
adaptan mediante FOUNDATION-013A-015-R1.

FOUNDATION-013A adopta localmente `Conversation`, `ConversationId`,
`ConversationMessage`, inputs/resultados provider-neutral y
`ConversationRepository`. Los adapters transitorios componen los repositorios
seguros actuales sin cambiar DTOs, backend, schema, rutas ni UI. El owner se
deriva exclusivamente de identidad autenticada confiable y los autores
ambiguos fallan cerrados.

FOUNDATION-013B adopta localmente la creación transaccional y la idempotencia
server-enforced de create/send. Elegibilidad e inserción comparten transacción;
los reintentos producen un efecto y los conflictos fallan cerrados. El esquema
físico sigue siendo transitorio y no se autoriza remoto, rutas ni producto.

FOUNDATION-013C adopta localmente list/read/archive/restore owner-scoped,
paginación estable acotada y lectura de historia archivada. Archive y restore
son transiciones atómicas naturalmente idempotentes; los endpoints y tablas
físicos siguen siendo transitorios y no se activan rutas, UI ni remoto.

La auditoría identificó componentes modernos reutilizables, deuda legacy y un
P0 en diez tablas públicas. R1 lo remedia en el estado PostgreSQL local definido
por el repositorio: RLS activo, cero policies y cero grants cliente en las diez
tablas. El P0 queda `CLOSED_LOCALLY`; esto no afirma el estado remoto ni resuelve
la deuda P1-P4.

## Autoridad

La jerarquía vigente se define en `DOCUMENTATION_GOVERNANCE.md`: constitución y
gobierno aprobados, ADR Foundation, documentos normativos de dominio, contratos
y estándares, planes aprobados, evidencia/trackers y, en último lugar, archivo
de Descubrimiento sin autoridad normativa.

Estados canónicos:

```text
DRAFT | PROPOSED | APPROVED | ACTIVE | SUPERSEDED
ARCHIVED | REJECTED | DEPRECATED | UNKNOWN
```

El Fundador es la autoridad humana final. Los responsables y agentes presentan
propuestas; ninguna recomendación se autoaprueba.

## Archivo de Descubrimiento

La documentación histórica se conserva en
[`docs/archive/discovery/`](../archive/discovery/README.md). Sus prompts, planes
y orquestadores no son ejecutables y sus decisiones no gobiernan Foundation sin
adopción explícita.

## Reglas de uso

1. No confundir una decisión conceptual con una capacidad implementada.
2. No mover, eliminar ni reescribir activos de Descubrimiento sin paquete
   aprobado.
3. Consultar el tag de congelación para reconstruir el estado histórico exacto.
4. Mantener secretos, tokens, credenciales y datos reales fuera de Git.
5. Exigir ADR Foundation para decisiones estructurales pendientes.
6. Aplicar cambios pequeños, reversibles, verificables y con propietario.

## Regla de evidencia

```text
La documentación demuestra decisiones.
El código y las pruebas demuestran implementación.
```

## Estado operativo actual

FOUNDATION-018 adopta localmente el contrato de Development, los inventarios de
configuración y secretos por nombre, el manifest no aprobado y el preflight sin
red. La preparación puede quedar `READY_FOR_EXPLICIT_REMOTE_AUTHORIZATION`, pero
no identifica proyecto, no autoriza remoto y no inicia FOUNDATION-019A. Staging,
Production, observabilidad remota, IA y Stasis Engine permanecen bloqueados.

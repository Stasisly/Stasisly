# Surfaces Architecture

## Classification

| Layer | Coordinator | Audience | Status |
|---|---|---|---|
| Product Surface | Stasis | End users | `ARCHITECTURE_TARGET` |
| Development Surface | Rector | Technical operators | `ARCHITECTURE_TARGET` |
| Administration Surface | Gerendi | Authorized operations | `ARCHITECTURE_TARGET` |
| Founder Private Console | Nexus under Founder authority | Founder only | `ARCHITECTURE_TARGET` |
| Internal Platform | Nexus-coordinated subsystems | No public audience | `ARCHITECTURE_TARGET` |

## Product Surface

Targets iOS, Android and Web. It contains the user-facing Product capabilities.
The exact Web domain remains an infrastructure decision.

Stasis is its planned principal screen and bounded central coordinator. Salud,
Nutricion, Entrenamiento and Wellness remain independently extensible Product
areas. Product behavior must preserve safety escalation, transparent agent
participation, accessibility and inclusive interaction across all three client
platforms. Wave 4 documents these contracts but implements no Product runtime.

## Development Surface

Targets `dev.stasisly.com`. It combines technical chat, projects, agents,
tasks, plans, executions, diffs, gates, sanitized logs, documentation,
environments, Founder authorizations, audit and release status. External tools
may inspire it, but no interface is copied literally.

## Administration Surface

Targets `admin.stasisly.com`. It covers authorized operations such as users,
roles, billing, support, compliance, catalog operations, growth and incidents.
UI design follows role, use-case, risk, elevation and audit definitions.

## Founder Private Console

Provides Founder-exclusive global visibility and controlled `Standard`,
`Elevated` and `Emergency` modes. Cross-surface visibility never bypasses audit
or explicit elevation.

## Internal Platform

Contains API, Data Router, Shard Directory, Agent Registry, Model Gateway,
Stasis Engine, memory, research, authorization, audit, observability, events and
workflows. It is not a public surface.

## Boundary rules

- Separate identity, authorization and audit context per surface.
- No implicit permission transfer between surfaces.
- Versioned contracts mediate data and actions.
- Each surface can evolve or scale independently.
- A new top-level surface requires Founder approval and an ADR.
- Flutter is a Product client and contains no service credentials, cross-surface
  authorization or sensitive backend logic.
- MCP is an internal tool protocol, never the Product API.
- Internal Platform components documented here remain `NOT_IMPLEMENTED` until
  runtime evidence proves otherwise.
## Wave 5 Development contract

Development is the primary governed interface for building and evolving
Stasisly. Rector coordinates bounded technical decomposition from Founder
intent through an isolated workspace, iterative implementation and tests,
reviewable evidence, required authorization, Git and authorized promotion.

Product, Development and Administration retain independent permissions and
data boundaries. Development may expand across client, backend, data,
security, QA, delivery, reliability and documentation without becoming a
fixed list or gaining authority over another surface. The Development Surface
and its runners remain `NOT_IMPLEMENTED`.
## Wave 6 Administration boundary

Administration remains separate from Product and Development. Gerendi is its documentary coordinator; `admin.stasisly.com` is a target entry point only. Cross-surface handoffs use versioned contracts and do not transfer permissions, personal data, spending or enforcement authority. `ADMINISTRATION_SURFACE: DOCUMENTED_NOT_IMPLEMENTED`.

### Fraud-risk boundary

W7-001 adds forty documentary Administration specialists without coupling Product or Development. Signals and scores do not authorize account, payment, subscription, identity, privilege, moderation or appeal actions. Cross-surface handoffs transfer purpose-bound evidence, not permissions; `FRAUD_RUNTIME: NOT_IMPLEMENTED`.

### People, incidents and continuity boundary

W7-002 adds twenty CRITICAL documentary Administration specialists. They may assess and coordinate within scope but cannot declare emergencies, execute HR actions, interrupt production, activate continuity or recovery, or release crisis communications. Product impact routes to Stasis, technical response to Rector, Administration coordination to Gerendi, cross-surface conflict to Nexus, reserved authority to Founder and execution to authorized humans. `PEOPLE_INCIDENT_CONTINUITY_RUNTIME: NOT_IMPLEMENTED`.

### Privacy, legal and compliance boundary

W7-003 adds 45 HIGH-risk documentary Administration specialists. Rights,
consent, retention, deletion, legal interpretation, compliance evidence,
transfers, processors and automated decisions require scoped evidence and
qualified human review. No prompt executes a request, deletion, disclosure,
notification, certification or legal decision. `PRIVACY_LEGAL_COMPLIANCE_RUNTIME: NOT_IMPLEMENTED`.

### Subscriptions, billing and finance boundary

W7-004 adds 22 HIGH-risk documentary Administration specialists. Financial
records and Product entitlements remain separate; analysis transfers bounded
evidence, never payment, refund, payout, ledger, balance, provider or entitlement
authority. `SUBSCRIPTIONS_BILLING_FINANCE_RUNTIME: NOT_IMPLEMENTED`.

### DevOps, SRE and observability incident-command boundary

W7-005 adds ten CRITICAL documentary Development specialists. They may analyze
incident evidence and coordinate bounded handoffs but cannot declare or close
incidents, execute commands, deploy, rollback, mutate infrastructure, suppress
telemetry or issue external communications. `INCIDENT_COMMAND_RUNTIME: NOT_IMPLEMENTED`.

### Integrations, commerce and stores payment-engineering boundary

W7-006 adds seven HIGH documentary Development specialists. They may design
provider-independent payment contracts but cannot execute payments, mutate
ledgers or commerce state, access credentials, approve providers, submit store
actions or acquire Product/Administration authority.
`PAYMENTS_ENGINEERING_RUNTIME: NOT_IMPLEMENTED`.

### Security and privacy boundary

W7-007 adds 100 CRITICAL documentary Development specialists. They may analyze
bounded security and privacy evidence but cannot exploit systems, access
credentials or keys, change permissions, mutate production, decide privacy
rights, attribute attackers, command incidents or disclose externally.
`SECURITY_PRIVACY_RUNTIME: NOT_IMPLEMENTED`.

### Product health and clinical-safety boundary

W7-008 adds 90 HIGH/CRITICAL documentary Product health specialists. They may
organize minimized evidence, explain general concepts, prepare consultation
questions and identify red flags, but cannot diagnose, prescribe, select
treatment, replace care, mutate records or production, or act as emergency
responders. `PRODUCT_HEALTH_RUNTIME: NOT_IMPLEMENTED`.

### Product health extended specialty boundary

W7-009 adds 90 HIGH documentary specialists while preserving Product surface
isolation. Gastroenterology, geriatrics, gynecology, health education, health
monitoring and hematology guidance cannot acquire clinical, record, emergency,
production or cross-surface authority. `PRODUCT_HEALTH_RUNTIME: NOT_IMPLEMENTED`.

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

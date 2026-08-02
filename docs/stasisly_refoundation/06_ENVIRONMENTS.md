# Environments

| Environment | Purpose | Remote state under this package |
|---|---|---|
| Local | Development and deterministic verification | Available |
| Development | Controlled integration | Existing project is legacy candidate |
| Staging | Pre-production validation | Not authorized |
| Production | User operation | Not authorized |

Each environment requires separate credentials, authorization, data policy,
observability and deployment gates. Environment names never grant permission.

## Current and clean Development

The current Supabase project is `DISCOVERY_LEGACY`, `READ_ONLY_CANDIDATE` and
`NON_NORMATIVE`. It is not deleted or reused automatically.

`Stasisly Development Clean Baseline` is planned and not created. Its future
creation requires new credentials, clean Auth and Storage, migration history
from `00001`, synthetic-only seeds, explicit RLS and explicit surface access.

No remote action, deployment, secret mutation or project creation is authorized
by this document.

Each environment begins with one principal PostgreSQL database. Any future
replication, partitioning, sharding or extraction requires environment-specific
metrics, authorization, migration evidence, rollback and a dedicated ADR.
## Wave 5 promotion contract

Environment promotion is never inferred from a passing local test or an
approved prompt. Development, staging and production retain separate targets,
credentials and authorization. Remote link, migration, secret update, deploy
and release require exact project, commit, operator, manifest, gates, rollback
and approval. Wave 5 creates no runner, pipeline, environment or deployment.
## Wave 6 environment status

The Wave 6 package is documentary and local. Administration Surface, billing providers, payment runtime, CRM, campaign systems, advertising providers, live analytics and Growth experiment runtime are not configured in Development, Staging or Production.
## Documentary critical-agent boundary

W7-002 prompt approval changes no environment. Development, Staging and Production receive no agent runtime, incident provider, people provider, communications provider, credentials, tools, memory, continuity automation or Emergency authorization. Production shutdown, failover and recovery remain separately authorized operational actions.

## W7-004 environment status

Prompt approval configures no payment processor, billing provider, ledger,
financial credential, webhook, settlement service, runtime agent, tool or
memory in Development, Staging or Production. Operational actions remain `0`.

## W7-005 environment status

Prompt approval configures no incident runtime, telemetry provider, credential,
production access, deployment, rollback, infrastructure tool, agent or memory
in any environment. Development documentation confers no staging or production
authority; operational actions remain `0`.

## W7-006 environment status

Prompt approval configures no payment processor, merchant or store account,
credential, webhook endpoint, ledger, reconciliation service, runtime agent,
tool or memory in any environment. Payment and commerce operations remain `0`.

## W7-007 environment status

Prompt approval configures no scanner, security provider, privacy workflow,
secret store, cryptographic key, privileged credential, incident runtime,
production access, agent, tool or memory in any environment. Security and
privacy operations remain `0`.

## W7-008 environment status

Prompt approval configures no clinical provider, diagnostic system, emergency
integration, health-record service, credential, runtime agent, tool, memory or
model in any environment. Medical, health-data, record and production
operations remain `0`.

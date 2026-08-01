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

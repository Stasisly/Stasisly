# STASISLY-AGENTS-006: Wave 5 Development Core and Engineering Operations Prompts

## Objective and scope

Establish the exact 60-agent Wave 5 Development documentary baseline assigned in `AGENT_WAVE_ASSIGNMENTS_v1`, without changing assignments, historical sources, product code, infrastructure or runtime. The package migrates ten historical prompts and creates fifty new prompts; reclassifications are zero.

Artifacts comprise 60 prompts, 60 evaluation suites and 17 reports. Every prompt has 32 canonical sections and seven policy layers. Catalog state becomes 172 `DOCUMENTED_ONLY`, 177 `PROMPT_CREATED`, 2,828 `NOT_IMPLEMENTED`, 2,823 `NOT_CREATED` and 3,000 `NOT_AVAILABLE`.

## Engineering contract

Development is a governed interface coordinated by Rector. Future tasks bind repository, base SHA, explicit scope, isolated workspace, iterative tests, reviewable diff, rollback and authorization. Git is canonical. Product, Development and Administration retain independent boundaries.

The baseline covers technical direction, Flutter and client engineering, backend/API/data, PostgreSQL/Supabase/RLS, jobs/events/workflows/cache/search, security and dependencies, QA/testing, CI/CD, DevOps/SRE, observability, performance, releases and technical documentation. Coverage reports distinguish `COVERED`, `PARTIALLY_COVERED` and `DEFERRED`; no total operational coverage is claimed.

## Safety and evaluation

Clients do not exclusively own sensitive logic. Secrets, `.env`, service-role credentials and production data are excluded. RLS, grants, environment promotion, destructive data changes, deployment and Git history fail closed or require exact authorization.

The 60 suites provide 1,920 canonical sections, 900 P0-P14 documentary passes and 300 designed adversarial cases. P15 runtime configuration, P16 runtime testing and P17 availability are not executed. Test failures must be diagnosed and corrected without weakening assertions or gates.

## State and evidence

```text
DOCUMENTARY_PROMPTS_IMPLEMENTED
DEVELOPMENT_SURFACE_NOT_IMPLEMENTED
RUNNERS_NOT_IMPLEMENTED
RUNTIME_NOT_IMPLEMENTED
AGENTS_NOT_AVAILABLE
Remote actions: 0
```

Verification completed with 61/61 focused and cumulative guards, 1,062 Flutter passes and 5 approved skips, 0 analyzer errors or warnings with 36 inherited infos, 86/86 Deno tests, 62 Deno-formatted files, and 740/740 local SQL tests after a no-seed reset. Remote-context preflight was `SAFE`; remote actions were zero.

The next bounded package is `STASISLY-AGENTS-007` Wave 6 Administration Core. It is not executed here.

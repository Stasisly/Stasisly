# Wave 5 Capability Coverage v1

| Capability | Coverage | Evidence and limitation |
|---|---|---|
| Technical direction, architecture and engineering documentation | COVERED | Direct assigned roles and shared Development contract. |
| Flutter core, frontend features and reusable components | COVERED | Historical specialists migrated with bounded client ownership. |
| Backend, Supabase, QA, DevOps, observability, performance and store release | COVERED | Direct historical specialists migrated. Runtime remains absent. |
| Native iOS, Android, Web and design systems | PARTIALLY_COVERED | General and client-engineering roles cover governance; no claim of every dedicated runtime specialist. |
| API, PostgreSQL, RLS, jobs, events, workflows, cache and search | PARTIALLY_COVERED | Backend/data/security roles define contracts and controls; implementation and operational proof are absent. |
| Application security, dependency security and supply chain | PARTIALLY_COVERED | Shared deny-by-default contract and assigned engineering roles; independent security runtime is absent. |
| Unit, widget, integration, SQL, contract, accessibility and adversarial testing | PARTIALLY_COVERED | QA/test planning is covered; real environments and runtime execution are deferred. |
| CI/CD, release engineering, SRE, incident response and environment promotion | PARTIALLY_COVERED | Governance and gates are specified; pipelines, runners and sustained operations are not implemented. |
| External infrastructure, production operations and autonomous engineering execution | DEFERRED | Requires separate authorization, ToolBindings, environments, runtime and evaluations P15-P17. |

This matrix intentionally makes no total-coverage claim. `COVERED` means documentary role coverage inside Wave 5, not implemented capability or availability.

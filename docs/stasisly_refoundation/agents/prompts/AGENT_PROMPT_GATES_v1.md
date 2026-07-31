# Agent Prompt Gates v1

| Gate | Evidence | Blocking condition |
|---|---|---|
| P0 Catalog mapping | Stable ID and exact catalog row | Missing or ambiguous mapping |
| P1 Mission and scope | Differentiated mission and exclusions | Overlap or unbounded scope |
| P2 Authority and prohibitions | Authority matrix and refusals | Implicit enforcement or escalation |
| P3 Data and privacy | Data class, purpose and minimization | Unbounded or unjustified data |
| P4 Tools | Tool class and proposed bindings | Undeclared or excessive tools |
| P5 Memory | Scope, provenance, retention and deletion | Global or indefinite memory |
| P6 Coordination | Parent, handoffs and conflict path | Unknown parent or cycle |
| P7 Human escalation | Triggers and safe stopped state | Missing critical escalation |
| P8 Founder controls | Founder-only decisions isolated | Agent impersonates Founder |
| P9 Security | Threat review and fail-closed behavior | Critical unresolved threat |
| P10 Traceability | Sources, versions and decision evidence | Opaque conclusions |
| P11 Evaluation design | Versioned synthetic evaluation plan | Uncovered critical behavior |
| P12 Adversarial review | Injection, abuse and spoofing cases | Critical adversarial failure |
| P13 Documentation parity | Catalog, prompt and ADR consistency | Contradictory source of truth |
| P14 Approval | Required reviewers and evidence | Missing or self-approval |
| P15 Runtime configuration | External versioned bindings | Missing or unauthorized binding |
| P16 Testing | Evaluation suite executed | Blocking failure or stale tuple |
| P17 Availability | Release and operational gates | Any prerequisite incomplete |

P0-P14 govern documentary design and approval. P15-P17 require later packages.
No prompt audited in STASISLY-AGENTS-001 has passed P0-P14.

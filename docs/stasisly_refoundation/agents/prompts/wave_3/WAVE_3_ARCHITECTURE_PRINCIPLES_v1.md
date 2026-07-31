# Wave 3 Architecture Principles v1

- PostgreSQL is canonical; Supabase is the initial replaceable provider.
- Product clients use a versioned API. MCP is not the Product API.
- Flutter contains no service credentials, cross-surface authorization or sensitive backend logic.
- One principal database per environment is the initial proportional design.
- Future partitioning, sharding or service extraction requires measured need and an ADR; fixed 1000-user blocks are forbidden.
- Data Router, Shard Directory, Agent Registry, Model Gateway and Stasis Engine are `NOT_IMPLEMENTED`.
- Git is canonical. Documented architecture is not runtime implementation.
- Global design and proportional implementation apply together.

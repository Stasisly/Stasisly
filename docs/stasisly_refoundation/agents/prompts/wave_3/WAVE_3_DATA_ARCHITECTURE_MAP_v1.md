# Wave 3 Data Architecture Map v1

`Flutter -> versioned Product API -> authorization/PDP-PEP -> domain application -> PostgreSQL adapter`.

PostgreSQL is canonical and Supabase is replaceable. Data Router and Shard Directory are future internal contracts, both `NOT_IMPLEMENTED`. Every growing collection requires bounded queries, pagination, retention, provenance, deletion and portable export. Cross-surface sharing requires an explicit contract; memory, RAG indexes and research evidence remain distinct stores and lifecycles.

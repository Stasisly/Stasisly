# STASISLY-AGENTS-004 - Wave 3 Architecture, Data and Multi-Agent Prompts

Status: `APPROVED_DOCUMENTARY_BASELINE`

## Scope

This package migrates 13 historical Development prompts and creates 27 new catalog prompts: exactly 40 Wave 3 agents. Historical sources remain byte-identical. Wave 1 and Wave 2 prompts remain unchanged.

## Architecture baseline

- PostgreSQL is canonical; Supabase is the initial replaceable provider.
- Product uses a versioned API; MCP is not the Product API.
- Flutter contains no service credentials or sensitive backend authorization logic.
- One principal database per environment is the proportional starting point.
- Scaling requires metrics, bounded queries, retention, portability and an ADR; fixed user blocks are forbidden.
- Data Router, Shard Directory, Agent Registry, Model Gateway and Stasis Engine are `NOT_IMPLEMENTED`.
- Stasis Engine is an internal subsystem.
- Git remains the canonical source of versioned contracts.

The governing principle is **Global design, proportional implementation**.

## Multi-agent and data boundaries

Catalog identity, prompt, runtime configuration, model, tool, memory, retrieval and evaluation bindings are independent. Memory, RAG, research evidence and evaluation have separate provenance and retention. Cross-surface access remains deny by default and contract-bound.

## Evidence

Forty prompts contain 32 canonical sections each (`1280/1280`). Forty evaluation suites contain 16 categories plus five adversarial cases (`200`). P0-P14 record `600/600 PASS`; P15-P17 are `NOT_EXECUTED`.

## State

```text
PROMPTS: APPROVED_DOCUMENTARY_BASELINE
IMPLEMENTATION: DOCUMENTED_ONLY
RUNTIME: NOT_IMPLEMENTED
AGENTS_AVAILABLE: 0
AGENTS_ACTIVE: 0
TOOLS_PROVISIONED: 0
MEMORIES_PROVISIONED: 0
PRIVILEGED_ACCESS: 0
```

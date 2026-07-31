# Agent Prompt Shared Layers v1

## Rule

Global, surface, domain and family policies are versioned once and referenced by
ID. Agent prompts contain only differentiated role instructions. Copying long
constitutional or security text into thousands of files is forbidden because
it creates drift and inconsistent fixes.

## Layer registry contract

Each shared layer records `layer_id`, `layer_type`, `version`, `owner`, scope,
dependencies, compatibility, content hash, approval evidence and supersession.
The effective composition records exact references.

## Separation

- Constitutional policy defines Founder authority, global prohibitions and
  product identity.
- Surface policy defines Product, Development, Administration or Transversal
  boundaries.
- Domain/family policy defines shared expertise, safety and output contracts.
- Agent prompt defines identity, mission, scope and differentiated behavior.
- Runtime configuration binds actual models, tools, data and memory externally.
- Evaluation suite tests the complete version tuple independently.

## Change impact

Changing a shared layer triggers dependency analysis and targeted re-evaluation
of affected prompts. It does not rewrite agent files or imply automatic
approval. Major expansion to a new top-level surface requires Founder approval.

## Security

Shared layers contain policy, never secrets. Runtime resolvers fail closed on
missing, incompatible, cyclic or unapproved references and never permit a later
layer to weaken an earlier one.

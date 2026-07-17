# Conversation Domain Glossary

## FOUNDATION-013D terms

- **MessageAuthor**: Product display author backed by evidence.
- **MessageProvenance**: verifiable origin, distinct from author.
- **MessageVisibility**: Product access category; unknown/internal fail closed.
- **Redacted Message**: visible record with no original content.
- **Execution record**: internal artifact that is never a Message by default.

## Metadata

```text
Status: APPROVED
Implementation: NOT IMPLEMENTED
Owner: Product Architecture under Stasis
Approver: Founder
```

| Term | Canonical meaning | Explicit exclusion |
|---|---|---|
| Conversation | Persistent Product aggregate visible and manageable by its owner | Provider thread, runtime execution or memory |
| Conversation ID | Public Stasisly identifier of a Conversation | `agentId`, provider ID or authorization proof |
| Chat session | Transitional current persistence/API concept to be adapted | Permanent Foundation term |
| Session ID | Transitional current identifier accepted by existing APIs | It is not an `ExecutionSession` and is not guaranteed to be a future `conversationId` |
| ExecutionSession | Temporary internal runtime context for one bounded Engine execution | User-visible Conversation |
| Thread | Provider-specific or adapter-internal grouping only | Product domain term or public ID |
| Message | Persistent Product-visible communication in a Conversation | Tool call, scratchpad or raw model output by default |
| Turn | Product/application interaction beginning with accepted user input and ending in a visible outcome or safe failure | Storage identity or authorization scope |
| Participant | Product-visible actor associated with a Conversation | Every internal contributor |
| Internal contributor | Agent/specialist/tool involved in execution but not automatically Product-visible | Conversation participant by inference |
| Specialist catalog item | Sanitized Product selection option identified currently by `selectableSpecialistId` | Runtime agent, prompt or roster identity |
| Specialist definition | Approved functional definition linked privately from catalog | Provider/model execution identity |
| Agent runtime identity | Technical identity/version executable by Stasis Engine | Catalog ID or organizational authority |
| Organizational roster entry | Governance position in the multiagent organization | Runtime credential or Product participant |
| Prompt version | Reviewed instruction artifact used by an approved runtime definition | Authorization or secret |
| Model execution | One bounded provider/model invocation | Product Message without consolidation and visibility decision |
| Stasis | Product coordinator and primary conversational entry point | Stasis Engine, owner, policy engine or universal memory |
| Stasis Engine | Future technical platform executing Stasis and agents | Product surface or orchestrator prototype |
| Product history | Ordered visible Messages and lifecycle events | Security audit, telemetry or full execution trace |
| Conversation summary | Derived, versioned Product aid with provenance | User memory by default |
| Memory proposal | Candidate datum requiring policy and, where applicable, user approval | Automatic permanent extraction |
| Research request | Explicit request to initiate governed research | Ordinary Message alone |
| Research execution | Internal bounded research workflow | Product history or private reasoning disclosure |
| Research artifact | Separately governed consultable result with sources and provenance | Raw trace or Conversation Message |
| Trace | Minimized authorized technical/execution evidence | Private chain-of-thought or Product content store |
| Attachment | Separately secured content referenced from Product | Inline ungoverned blob or trusted content by default |
| Correlation ID | Non-authoritative diagnostic link across operations | Product ID, ownership or access token |

## Naming rules

1. Product APIs and routes use `conversationId` after the versioned migration.
2. Existing `sessionId` remains explicit only in compatibility contracts.
3. Runtime code must spell `ExecutionSession`; bare `Session` is insufficient
   where Conversation confusion is possible.
4. `agentId` never identifies a Product Conversation or specialist catalog item.
5. `assistant`, `system` and `tool` are current storage roles, not the final
   Product author taxonomy.
6. Memory, research, trace and history are separate concepts and stores even if
   they reference the same Conversation.

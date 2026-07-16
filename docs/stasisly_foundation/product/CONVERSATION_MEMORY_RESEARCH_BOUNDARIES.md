# Conversation, Memory and Research Boundaries

## Metadata

```text
Status: APPROVED conceptually
Implementation: NOT IMPLEMENTED
Owner: Product + Data/Memory + Research Governance
Approver: Founder
```

## Separate data domains

```text
conversation history
conversation summary
user memory
specialist memory
domain memory
authorized Stasis global memory
research memory
runtime context
```

These domains may reference one another through minimized, authorized IDs and
provenance. They are not aliases and do not automatically share retention or
access policy.

## Memory decision

A Conversation never becomes permanent memory automatically. Content may
produce a `MemoryProposalReference` only when a future policy defines purpose,
scope, sensitivity, provenance, expiry and required user control.

The memory flow is conceptually:

```text
eligible Product fact
-> minimized memory proposal
-> policy and consent/approval when applicable
-> adopted/rejected outcome
-> view, correction, revocation and deletion controls
```

Adopted memory records source Conversation/Message provenance without copying
unnecessary history. Summaries are versioned derived Product aids, not implicit
memory. Runtime context is ephemeral and receives only the minimum authorized
history/memory needed for one execution.

## Research decision

Conversations may explicitly request quick, deep or strategic research in a
future package. The model separates:

```text
conversation Message
research request
research execution
research artifact
research summary
sources and provenance
```

A research artifact is separately owned, authorized, versioned, retained and
consultable. A Product Message may announce or summarize it and hold a safe
reference. Raw model/tool traces and private chain-of-thought are not artifacts
and are never exposed merely for transparency.

Authorized transparency may show participant summaries, approved contributions,
sources, versions, timestamps and the decision path needed to understand a
result. It must minimize personal data, secrets, prompts and internal reasoning.

## Attachments and future content

Images, documents, audio, wearable data, health records, links, structured forms
and tool results are not implemented. Every future attachment requires:

```text
backend-derived ownership
content-type allowlist
bounded size/count
malware and unsafe-content handling
sensitivity classification
retention/deletion policy
authorized access and download
provider abstraction
provenance and integrity
```

An attachment reference is not proof that content is safe. Health/wearable data
requires additional purpose, consent and privacy controls.

## Observability boundary

Product history, execution trace, security audit, technical telemetry, cost
accounting and research provenance are distinct streams. Correlation IDs may
link minimized records but never become Product IDs or authority. No stream may
store raw credentials, unnecessary content or private chain-of-thought.

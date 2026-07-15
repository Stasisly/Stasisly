# Documentation Governance

## Metadata

| Field | Value |
|---|---|
| Title | Documentation Governance |
| Status | APPROVED |
| Authority level | 1 — Founder-approved Constitution and Governance |
| Owner | Dirección de Documentación y Conocimiento under Rector (conceptual) |
| Approver | Founder |
| Version | 1.0 |
| Effective condition/date | Effective upon approval and merge of FOUNDATION-002 |
| Supersedes | Discovery documentation authority model |
| Dependencies | FOUNDATION_TRANSITION; discovery-final-baseline |

## Purpose

This document establishes how Stasisly Foundation documentation receives,
retains and loses authority. It does not grant product, architecture, security
or prioritization authority to Documentation.

## Authority hierarchy

1. **Founder-approved Constitution and Governance**
2. **Approved Foundation ADRs**
3. **Normative domain documents**
4. **Contracts and engineering standards**
5. **Approved implementation plans**
6. **Evidence, audits and trackers**
7. **Archived Discovery material**

A lower-level document may refine a higher-level document within delegated
scope, but it must not silently modify, override or contradict it. Conflicts are
recorded and escalated before publication.

## Canonical states

| State | Meaning |
|---|---|
| DRAFT | Work in progress without decision authority |
| PROPOSED | Complete proposal awaiting the required decision |
| APPROVED | Approved but not necessarily effective or implemented |
| ACTIVE | Effective authority within its declared scope |
| SUPERSEDED | Replaced by an identified successor |
| ARCHIVED | Historical evidence with no current normative authority |
| REJECTED | Explicitly declined |
| DEPRECATED | Still present during controlled retirement |
| UNKNOWN | Authority or validity requires investigation |

Approval is not implementation. `APPROVED` records a decision; implementation
requires code, tests and validation evidence. `ACTIVE` must identify its
effective condition.

## Required metadata for normative Foundation documents

- Title.
- Status.
- Authority level.
- Owner.
- Approver.
- Version.
- Effective condition or date.
- Supersedes.
- Dependencies.

Unknown information is written as `UNKNOWN`; dates and approvals are never
invented.

## Founder authority

The Founder is Stasisly's final human authority and may approve, reject, request
changes, change priorities, exercise veto, and grant or withdraw documentary
authority.

The Founder is not required to write operational documents. Owners and agents
must present complete proposals, evidence, alternatives, risks and requested
decisions. An agent recommendation never constitutes approval by itself.

## Documentation organization under Rector

Conceptual organization:

```text
Rector
└── Dirección de Documentación y Conocimiento
```

Its functions are to coordinate, normalize, register, version, publish,
archive, audit, maintain indexes and links, maintain ADR and trackers, and
record the roadmap.

It cannot decide product value, architecture, security acceptance, privacy,
technical implementation or roadmap priorities. Those authorities remain with
their approved owners and the Founder.

Rector and this Directorate are conceptual in FOUNDATION-002. No agent, prompt,
runtime permission or technical capability is created here.

## Normative change rules

1. Identify need, owner, authority level and affected documents.
2. Gather evidence and required specialist reviews.
3. Record conflicts and supersession explicitly.
4. Obtain the approver required by authority level.
5. Use an ADR for structural decisions.
6. Publish metadata and update the authority register.
7. Archive or mark superseded material without erasing history.

## Evidence and trackers

Evidence may prove that a test, audit or command ran, but it cannot independently
change product or architecture. Trackers report progress and decisions; they do
not replace the authoritative document or implementation evidence.

## Archive policy

Archived Discovery material has authority level 7, status `ARCHIVED` and no
normative authority. It remains searchable and traceable through Git and the
archive index. Historical prompts and plans are non-executable.

## Core rule

```text
Documentation demonstrates decisions.
Code and tests demonstrate implementation.
```

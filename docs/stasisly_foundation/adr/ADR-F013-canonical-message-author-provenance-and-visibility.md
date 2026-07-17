# ADR-F013 - Canonical Message author, provenance and visibility

Decision: **APPROVED**
Implementation: **IMPLEMENTED_LOCALLY**
Remote: **NOT AUTHORIZED**

## Context

The transitional message row represented authorship only with legacy `role`.
That cannot prove Stasis, specialist, system-notice or Product visibility and
made internal records vulnerable to accidental display.

## Decision

1. Author is separate from provenance and visibility.
2. All three are backend-controlled closed contracts.
3. Unknown remains unknown and fails closed.
4. `assistant` is not Stasis and `tool` is not a specialist.
5. Product messages are separate from internal execution records.
6. Private reasoning and provider/tool traces are excluded.
7. Internal and unknown records are filtered in SQL before pagination.
8. Redacted records expose no original content.
9. `selectableSpecialistId` is the only future Product specialist identifier.
10. The transitional schema/endpoints remain locally compatible.
11. Only local/development are in scope; remote is unauthorized.

## Consequences

User sends now carry evidence-backed metadata. Historical rows without backend
evidence stay hidden rather than being retroactively attributed. Future Stasis,
specialist, notice, redaction and execution operations require independent
registered contracts and approval.

## Evidence

Migration `00012`, focal SQL/Deno/Flutter guards, two full local SQL cycles and
the zero-residue local HTTP harness are the implementation evidence. This ADR
does not assert any remote deployment.

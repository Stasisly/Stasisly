# ADR-F020 Product Conversation safe observability and hardening

```text
Decision: APPROVED
Implementation: IMPLEMENTED_LOCALLY
```

## Context

Canonical Product Conversation is active only in authenticated local and
development modes, and legacy chat is physically removed. Post-activation
evidence required outcome visibility, race/error hardening and accessibility
criteria without collecting private content or authorizing remote telemetry.

## Decision

Adopt a minimal provider-neutral `ConversationObservabilitySink` at the
application-controller and stable-route boundaries. Runtime composition uses a
NoOp sink. In-memory collection is test-only. Events and fields are closed
enums/buckets; resource/identity tracking, free-form payloads, content, drafts,
credentials, operation attempts and provider errors are unrepresentable.

Durations use monotonic local buckets. Measurements are regression baselines,
not production SLOs. Accessibility critical/high findings block readiness;
FOUNDATION-017 has zero open critical/high findings and is
`ACCESSIBILITY_AUDITED_LOCALLY`, not fully WCAG certified.

Failures preserve previously loaded list/history where safe. Duplicate sends,
pagination and lifecycle operations remain controller-coordinated, and stale
results cannot overwrite newer state.

## Rejected alternatives

- remote analytics, network/file exporters or persistent user tracking;
- widget/rebuild-level instrumentation;
- logging path parameters, ConversationId, content length or fingerprints;
- provider exceptions or stack traces in Product copy/events;
- production performance promises from local fixture tests;
- AI, Stasis Engine or remote environment activation.

## Consequences

Local tests can assert safe outcomes and race behavior without introducing a
provider. Runtime memory and network behavior remain unchanged under NoOp. A
future remote sink, staging/production activation or formal WCAG claim requires
separate threat review, data governance, approval and ADR update.

## Security and rollback

No backend, schema, DTO, dependency, platform, remote service, real data or
secret changes. Rollback is a revert of the FOUNDATION-017 commit. Reverting
does not authorize legacy chat or remote telemetry.

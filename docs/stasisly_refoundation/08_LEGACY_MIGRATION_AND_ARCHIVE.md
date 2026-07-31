# Legacy Migration and Archive

## Classification

```text
Discovery: DISCOVERY_LEGACY / READ_ONLY_REFERENCE / NON_NORMATIVE
Foundation: FOUNDATION_LEGACY / PRESERVED_EVIDENCE / NON_NORMATIVE
Re-foundation: CURRENT_NORMATIVE_BASELINE
```

No historical file, migration, runner, manifest, authorization artifact or ADR
is deleted by this package.

## Target archive structure

```text
docs/archive/
├── discovery-v1/
├── discovery-v2/
├── foundation-legacy/
└── superseded-artifacts/
```

These targets are planned. Existing files are not moved until a reviewed
inventory maps current path, status, target, action and reason.

## Controlled sequence

```text
freeze → inventory → validate references → approve mapping
→ copy/move atomically → verify links and hashes → commit → retain rollback
```

Allowed actions are `KEEP_NORMATIVE`, `MIGRATE_TO_REFOUNDATION`,
`ARCHIVE_DISCOVERY`, `ARCHIVE_FOUNDATION_LEGACY`, `SUPERSEDE`, `MERGE` and
`REVIEW_REQUIRED`. Destruction is forbidden.

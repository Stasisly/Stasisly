# Legacy chat freeze

```text
status: DEPRECATED_AND_BLOCKED
replacement: lib/features/conversations/
```

This feature is frozen evidence from the pre-Foundation implementation. It is
not a Product Conversation boundary and must never be used as fallback.

Allowed changes are limited to security fixes, retirement guards and removal
work explicitly authorized by a later package.

Prohibited changes include:

- new routes or features;
- new repository or provider consumers;
- new or expanded direct Supabase access;
- Product fallback use;
- reuse as Stasis Engine or agent authority;
- interpreting `agentId` as `sessionId` or `conversationId`.

Repositories, datasources, entities, use cases, controllers and providers in
this directory are not Foundation-adopted. Visual intent may be inspected, but
canonical reusable UI lives under `lib/features/conversations/presentation/`.

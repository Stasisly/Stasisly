# incident command family prompt

artifact_id: FAM-DEVELOPMENT-DEVOPS-SRE-OBSERVABILITY-INCIDENT-COMMAND-v1
artifact_type: FAMILY_PROMPT
version: 1.0.0
status: APPROVED_DOCUMENTARY_COMPONENT
owner: REFOUNDATION_PROMPT_GOVERNANCE
surface: DEVELOPMENT
domain: devops_sre_observability
family: incident_command
risk_compatibility: CRITICAL
dependencies: POL-CONSTITUTIONAL-FOUNDER-DENY-BY-DEFAULT-v1;POL-SURFACE-DEVELOPMENT-v1;POL-DOMAIN-DEVELOPMENT-DEVOPS-SRE-OBSERVABILITY-v1
incompatible_with: RUNTIME_AUTHORITY_ELEVATION;PRODUCTION_MUTATION;UNSCOPED_CREDENTIAL_ACCESS
supersedes: NONE

Bounded incident command analysis identifies service, environment, severity, impact, evidence, owner, decision point, stop condition and escalation. It cannot declare or close incidents, self-approve exceptions, execute commands or mutate production.

Composition rule: minimum authority and the most restrictive data, tool and memory ceiling win. Runtime and availability are not created.

content_hash: 95ab315c54a3bd761c008262460a4caedd6e8474d401b254fe0e8b370a9de928

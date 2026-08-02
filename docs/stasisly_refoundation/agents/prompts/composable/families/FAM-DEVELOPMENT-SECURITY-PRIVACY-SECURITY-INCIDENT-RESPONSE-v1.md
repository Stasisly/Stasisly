# security incident response family prompt

artifact_id: FAM-DEVELOPMENT-SECURITY-PRIVACY-SECURITY-INCIDENT-RESPONSE-v1
artifact_type: FAMILY_PROMPT
version: 1.0.0
status: APPROVED_DOCUMENTARY_COMPONENT
owner: REFOUNDATION_PROMPT_GOVERNANCE
surface: DEVELOPMENT
domain: security_privacy
family: security_incident_response
risk_compatibility: CRITICAL
dependencies: POL-CONSTITUTIONAL-FOUNDER-DENY-BY-DEFAULT-v1;POL-SURFACE-DEVELOPMENT-v1;POL-DOMAIN-DEVELOPMENT-SECURITY-PRIVACY-v1
incompatible_with: RUNTIME_AUTHORITY_ELEVATION;PRODUCTION_MUTATION;UNSCOPED_CREDENTIAL_ACCESS;SECRET_DISCLOSURE;PRIVACY_RIGHTS_BYPASS
supersedes: NONE

Bounded security incident response analysis identifies asset, subject, tenant, environment, purpose, threat, control, evidence, owner, decision point, stop condition and escalation. It cannot self-approve exceptions, exploit systems, disclose restricted data, change authorization, handle real secrets or mutate production.

Composition rule: minimum authority and the most restrictive data, tool and memory ceiling win. Runtime and availability are not created.

content_hash: 7579b7552f03f0d42f4a7fe42aa3ee81b363cdb4cff8f00cd12549f5d842f2c7

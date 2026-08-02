# Development DevOps SRE observability domain policy

artifact_id: POL-DOMAIN-DEVELOPMENT-DEVOPS-SRE-OBSERVABILITY-v1
artifact_type: DOMAIN_POLICY
version: 1.0.0
status: APPROVED_DOCUMENTARY_COMPONENT
owner: REFOUNDATION_PROMPT_GOVERNANCE
surface: DEVELOPMENT
domain: devops_sre_observability
family: NOT_APPLICABLE
risk_compatibility: CRITICAL
dependencies: POL-CONSTITUTIONAL-FOUNDER-DENY-BY-DEFAULT-v1;POL-SURFACE-DEVELOPMENT-v1
incompatible_with: RUNTIME_AUTHORITY_ELEVATION;PRODUCTION_MUTATION;UNSCOPED_CREDENTIAL_ACCESS
supersedes: NONE

Incident detection, declaration, command, diagnosis, mitigation, recovery, verification, communication and review remain distinct. Operational evidence requires provenance, environment identity and segregation of command from execution. Documentary agents never execute commands, mutate infrastructure, suppress telemetry, approve providers or exercise incident authority.

Composition rule: minimum authority and the most restrictive data, tool and memory ceiling win. Runtime and availability are not created.

content_hash: 0f23326b00c0c28d773904474010f6077e32f72c1e9df776812e5398fe408bc6

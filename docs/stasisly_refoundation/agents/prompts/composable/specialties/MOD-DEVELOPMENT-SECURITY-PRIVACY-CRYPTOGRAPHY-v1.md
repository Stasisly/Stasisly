# cryptography specialty module

artifact_id: MOD-DEVELOPMENT-SECURITY-PRIVACY-CRYPTOGRAPHY-v1
artifact_type: SPECIALTY_MODULE
version: 1.0.0
status: APPROVED_DOCUMENTARY_COMPONENT
owner: REFOUNDATION_PROMPT_GOVERNANCE
surface: DEVELOPMENT
domain: security_privacy
family: cryptography
risk_compatibility: CRITICAL
dependencies: POL-CONSTITUTIONAL-FOUNDER-DENY-BY-DEFAULT-v1;POL-SURFACE-DEVELOPMENT-v1;POL-DOMAIN-DEVELOPMENT-SECURITY-PRIVACY-v1;FAM-DEVELOPMENT-SECURITY-PRIVACY-CRYPTOGRAPHY-v1
incompatible_with: RUNTIME_AUTHORITY_ELEVATION;PRODUCTION_MUTATION;UNSCOPED_CREDENTIAL_ACCESS;SECRET_DISCLOSURE;PRIVACY_RIGHTS_BYPASS
supersedes: NONE

Adds cryptography terminology, provenance, evidence, control-effectiveness, privacy, authorization and safe-handoff checks. It may restrict behavior but never elevate authority, data, tools or memory.

Composition rule: minimum authority and the most restrictive data, tool and memory ceiling win. Runtime and availability are not created.

content_hash: cac2610f6fe13cc99fa62810bfb6a0ed5d9322f31ab34afbd2feaf35b54a442f

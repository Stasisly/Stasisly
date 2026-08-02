# dependency security specialty module

artifact_id: MOD-DEVELOPMENT-SECURITY-PRIVACY-DEPENDENCY-SECURITY-v1
artifact_type: SPECIALTY_MODULE
version: 1.0.0
status: APPROVED_DOCUMENTARY_COMPONENT
owner: REFOUNDATION_PROMPT_GOVERNANCE
surface: DEVELOPMENT
domain: security_privacy
family: dependency_security
risk_compatibility: CRITICAL
dependencies: POL-CONSTITUTIONAL-FOUNDER-DENY-BY-DEFAULT-v1;POL-SURFACE-DEVELOPMENT-v1;POL-DOMAIN-DEVELOPMENT-SECURITY-PRIVACY-v1;FAM-DEVELOPMENT-SECURITY-PRIVACY-DEPENDENCY-SECURITY-v1
incompatible_with: RUNTIME_AUTHORITY_ELEVATION;PRODUCTION_MUTATION;UNSCOPED_CREDENTIAL_ACCESS;SECRET_DISCLOSURE;PRIVACY_RIGHTS_BYPASS
supersedes: NONE

Adds dependency security terminology, provenance, evidence, control-effectiveness, privacy, authorization and safe-handoff checks. It may restrict behavior but never elevate authority, data, tools or memory.

Composition rule: minimum authority and the most restrictive data, tool and memory ceiling win. Runtime and availability are not created.

content_hash: fcf5118b798b9ade5080713ad3480fd9e633b2faced05d6ebdf96e17bfaac595

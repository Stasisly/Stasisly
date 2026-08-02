# clinical safety escalation specialty module

artifact_id: MOD-PRODUCT-HEALTH-CLINICAL-SAFETY-ESCALATION-v1
artifact_type: SPECIALTY_MODULE
version: 1.0.0
status: APPROVED_DOCUMENTARY_COMPONENT
owner: REFOUNDATION_PROMPT_GOVERNANCE
surface: PRODUCT
domain: health
family: clinical_safety_escalation
risk_compatibility: HIGH;CRITICAL
dependencies: POL-CONSTITUTIONAL-FOUNDER-DENY-BY-DEFAULT-v1;POL-SURFACE-PRODUCT-v1;POL-DOMAIN-PRODUCT-HEALTH-v1;FAM-PRODUCT-HEALTH-CLINICAL-SAFETY-ESCALATION-v1
incompatible_with: DIAGNOSIS;PRESCRIPTION;CARE_REPLACEMENT;RUNTIME_AUTHORITY_ELEVATION;UNAUTHORIZED_HEALTH_DATA_ACCESS;UNAUTHORIZED_PRODUCTION_MUTATION
supersedes: NONE

Adds clinical safety escalation terminology, evidence quality, provenance, recency, clinical uncertainty, privacy, emergency escalation and safe-handoff checks. It may restrict behavior but never elevate authority, data, tools or memory.

Composition rule: minimum authority and the most restrictive clinical safety, data, tool and memory ceiling win. Runtime and availability are not created.

content_hash: 78da707fa9bc64627372155a8ad2ee18c9151fc60932477c42621aad34a6a378

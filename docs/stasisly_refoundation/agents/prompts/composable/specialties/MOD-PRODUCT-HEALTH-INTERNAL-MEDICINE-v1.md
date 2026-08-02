# internal medicine specialty module

artifact_id: MOD-PRODUCT-HEALTH-INTERNAL-MEDICINE-v1
artifact_type: SPECIALTY_MODULE
version: 1.0.0
status: APPROVED_DOCUMENTARY_COMPONENT
owner: REFOUNDATION_PROMPT_GOVERNANCE
surface: PRODUCT
domain: health
family: internal_medicine
risk_compatibility: HIGH
dependencies: POL-CONSTITUTIONAL-FOUNDER-DENY-BY-DEFAULT-v1;POL-SURFACE-PRODUCT-v1;POL-DOMAIN-PRODUCT-HEALTH-v1;FAM-PRODUCT-HEALTH-INTERNAL-MEDICINE-v1
incompatible_with: DIAGNOSIS;PRESCRIPTION;CARE_REPLACEMENT;RUNTIME_AUTHORITY_ELEVATION;UNAUTHORIZED_HEALTH_DATA_ACCESS;UNAUTHORIZED_PRODUCTION_MUTATION
supersedes: NONE

Adds internal medicine terminology, evidence quality, provenance, recency, clinical uncertainty, privacy, emergency escalation and safe-handoff checks. It may restrict behavior but never elevate authority, data, tools or memory.

Composition rule: minimum authority and the most restrictive clinical safety, data, tool and memory ceiling win. Runtime and availability are not created.

content_hash: e6a694cff35659bbdfba05dcd7a86ecc6b9ecc02efe29160751110283ece89b7

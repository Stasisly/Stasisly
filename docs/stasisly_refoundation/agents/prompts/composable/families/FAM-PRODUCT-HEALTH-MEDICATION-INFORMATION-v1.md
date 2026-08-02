# medication information family prompt

artifact_id: FAM-PRODUCT-HEALTH-MEDICATION-INFORMATION-v1
artifact_type: FAMILY_PROMPT
version: 1.0.0
status: APPROVED_DOCUMENTARY_COMPONENT
owner: REFOUNDATION_PROMPT_GOVERNANCE
surface: PRODUCT
domain: health
family: medication_information
risk_compatibility: HIGH
dependencies: POL-CONSTITUTIONAL-FOUNDER-DENY-BY-DEFAULT-v1;POL-SURFACE-PRODUCT-v1;POL-DOMAIN-PRODUCT-HEALTH-v1
incompatible_with: DIAGNOSIS;PRESCRIPTION;CARE_REPLACEMENT;RUNTIME_AUTHORITY_ELEVATION;UNAUTHORIZED_HEALTH_DATA_ACCESS;UNAUTHORIZED_PRODUCTION_MUTATION
supersedes: NONE

Bounded medication information guidance identifies user, subject, purpose, consent, symptoms, evidence, provenance, recency, uncertainty, safety flags, responsible human, stop condition and escalation. It cannot diagnose, prescribe, replace care, disclose health data, self-approve exceptions or mutate records or production.

Composition rule: minimum authority and the most restrictive clinical safety, data, tool and memory ceiling win. Runtime and availability are not created.

content_hash: 28ada47532fafd4a2787ae4ccd5dd44217d750854e159d636dab1cc304fcc114

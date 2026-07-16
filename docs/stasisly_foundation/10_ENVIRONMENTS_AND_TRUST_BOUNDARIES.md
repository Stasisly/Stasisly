# Entornos y Trust Boundaries

## Metadatos

| Campo | Valor |
|---|---|
| Título | Entornos y Trust Boundaries |
| Estado | APPROVED conceptually |
| Nivel de autoridad | 3 — Documento normativo de dominio |
| Propietario | Seguridad y DevOps bajo Rector |
| Aprobador | Founder |
| Versión | 1.0 |
| Condición de vigencia | Decisión conceptual vigente con FOUNDATION-004 |
| Sustituye | Controles de entorno dispersos de Descubrimiento como autoridad |
| Dependencias | 05_GLOBAL_TECHNICAL_ARCHITECTURE; 02_SURFACES_AND_ACCESS; ADR-F002 |

## Estado

```text
Conceptual decision: APPROVED
Environment vocabulary: IMPLEMENTED LOCALLY
Cross-surface/environment enforcement: PARTIALLY IMPLEMENTED
Remote enforcement: NOT IMPLEMENTED
```

## Entornos mínimos

```text
local
development
staging
production
```

`demo`, `preview`, `sandbox` y `disaster recovery` son opciones futuras, no
entornos activados por este documento.

No existe fallback implícito entre entornos. Credenciales production no se usan
en entornos inferiores; fuera de production se emplean datos sintéticos por
defecto. Presupuestos, observabilidad, access gates y promoción permanecen
separados y explícitos.

Development capability no concede production authority. La promoción requiere
evidencia, gate, owner, rollback y autorización correspondientes.

## Trust boundaries

| Frontera | Identidad/autenticación | Autorización y datos | Auditoría/fallo |
|---|---|---|---|
| User device | Usuario y sesión verificable | DTO públicos mínimos | Fallo cerrado; telemetría minimizada |
| Wearable | Usuario, dispositivo y vínculo futuro | Sync acotado y datos sensibles | Offline controlado; conflicto trazable |
| Product client | Identidad Product | Sin autoridad propia; contratos Stasisly | Respuesta saneada; no secretos |
| Development client | Identidad Development | Entorno y tarea explícitos | Sin producción heredada |
| Administration client | Identidad Administration | Operación empresarial autorizada | Mutaciones auditadas y confirmables |
| API edge | Identidad, sesión y request | Validación, ownership, rate limit | Deny by default; error público seguro |
| Domain services | Service identity futura | Invariantes y scope explícito | Resultado y policy outcome auditables |
| Stasis Engine | Ejecución, agente y versión | Context, tools, modelo y budget acotados | Trace sin razonamiento privado |
| Database | Identidad de servicio | Least privilege y separación de datos | Acceso y cambios auditables |
| External provider | Credencial backend y adapter | Datos mínimos por contrato | Timeout, circuit breaker y salida |
| Operations personnel | Identidad humana reforzada | JIT según función y entorno | Motivo, duración y revocación |
| Founder elevated context | Founder y elevación reforzada | Scope crítico explícito | Confirmación, alertas y auditoría inmutable futura |

La tabla es conceptual: no crea identidades, claims, sesiones ni policies.

## Observabilidad y auditoría

Se separan observabilidad técnica, security audit, business audit, agent
traceability, cost accounting y transparencia hacia usuario. Los controles
registran participantes, tools, modelos, versiones, datos permitidos,
decisiones, coste, latencia, errores y policy outcomes con minimización y
retención apropiada.

No se almacena razonamiento interno privado de modelos. Los logs no contienen
secretos, credenciales ni datos innecesarios.

## Fail-closed

```text
deny by default
validate at trusted boundaries
sanitize public responses
no client authority
no silent fallback to demo
no cross-surface implicit access
no secret in client
no unbounded execution
no provider credential exposure
```

Los fallos de identidad, entorno, policy, presupuesto o proveedor no elevan
acceso ni convierten operaciones reales en demo.

## Founder boundary

Founder identity, session context, authority level, environment, surface,
elevation state, operation scope y audit event se evalúan separadamente. La
elevación no se propaga automáticamente entre surfaces o entornos.

## Trabajo posterior

Threat model, autenticación, RBAC/ABAC, JIT, claims, RLS, cifrado, incident
response, RPO/RTO y runbooks necesitan paquetes y revisiones especializadas.

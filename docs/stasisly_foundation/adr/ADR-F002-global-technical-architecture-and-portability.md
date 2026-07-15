# ADR-F002 — Arquitectura técnica global y portabilidad

## Metadatos

| Campo | Valor |
|---|---|
| Estado | APPROVED |
| Propietario | Arquitectura bajo Rector |
| Aprobador | Founder |
| Nivel de autoridad | 2 — ADR Foundation aprobado |
| Dependencias | ADR-F001; 05_GLOBAL_TECHNICAL_ARCHITECTURE |

## Contexto

La Constitución separa Product Surface, Development Surface y Administration
Surface, pero no define todavía su frontera técnica, el papel de la API propia,
Supabase/PostgreSQL, Stasis Engine, entornos o portabilidad. El sistema heredado
combina contratos útiles con coupling directo al proveedor y prototipos que no
deben confundirse con arquitectura Foundation implementada.

## Decisión

1. Las tres surfaces tienen fronteras técnicas, poblaciones, capacidades, APIs,
   datos, workflows, agentes, auditoría y restricciones de entorno separadas.
2. Los clientes consumen preferentemente contratos propiedad de Stasisly; el
   acceso Supabase directo es una excepción explícita, protegida y portable.
3. PostgreSQL es la plataforma relacional canónica y fuente de verdad donde
   corresponda.
4. Supabase es proveedor managed inicial, no la identidad del backend; Auth,
   Storage, Edge Functions, Realtime y gestión se evalúan separadamente.
5. Las dependencias críticas requieren contrato, exportación, migración,
   observabilidad de costes y opción de salida proporcionales al riesgo.
6. Managed services están permitidos; self-hosting es capacidad futura y las
   decisiones usan coste total de propiedad.
7. Stasis Engine es una plataforma modular que incluye Runtime, registries,
   orchestration, memory/context, gateways, evaluación, observabilidad, safety,
   coste y auditoría sin exigir microservicios iniciales.
8. Model Gateway neutraliza proveedor/modelo y Cost Controller impone budgets,
   cuotas, límites, accounting, circuit breakers y degradación controlada.
9. `local`, `development`, `staging` y `production` permanecen aislados, sin
   fallback implícito ni credenciales production en entornos inferiores.
10. La arquitectura es wearable-ready mediante contratos de dispositivo y sync,
    sin depender de wearables ni implementarlos ahora.

## Consecuencias

- Backend y API controlan autorización y contratos públicos; Flutter no es
  autoridad.
- Las surfaces comparten tecnología solo mediante límites explícitos.
- El código Supabase heredado necesita conformance audit y adaptación gradual.
- Stasis queda separado de Stasis Engine y el prototipo orchestrator no se
  adopta como Engine.
- IA, herramientas y asincronía no pueden crecer sin medición, límites y gates.
- Arquitectura aprobada no demuestra implementación.

## Alternativas descartadas

- Supabase como identidad pública del backend: aumenta coupling y dispersa
  autorización.
- Microservicios completos desde el inicio: complejidad desproporcionada.
- Self-hosting inmediato por principio: coste y riesgo operativo no demostrados.
- Una sesión Founder universal: propagación de privilegios crítica.
- Event-driven para toda operación: coste y complejidad sin necesidad.

## Estado de implementación

```text
Conceptual decision: APPROVED
Implementation: NOT IMPLEMENTED
```

No se modifican código, datos, infraestructura, RLS, agentes, prompts,
proveedores, entornos ni remoto.

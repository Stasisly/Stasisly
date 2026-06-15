# ADR-001: API propia, MCP Server y Stasis Engine

## Estado

Aceptado conceptualmente, pendiente de auditoría técnica e implementación.

## Contexto

Stasisly necesita operar usuarios, chats, agentes, memorias, investigaciones,
permisos, pagos, archivos, auditoría y administración. Esta lógica requiere una
frontera backend controlada y no debe residir íntegramente en Flutter.

Supabase puede cubrir Postgres, Auth si se aprueba, RLS, Storage, Realtime,
funciones y Edge Functions. MCP puede ofrecer herramientas a agentes IA, Codex,
Antigravity e integraciones. Son responsabilidades distintas.

## Decisión

Stasisly tendrá una **API propia o capa backend propia** como interfaz operativa
de la aplicación.

El **MCP Server no sustituirá a la API**. Será una interfaz especializada para
agentes IA, herramientas internas e integraciones autorizadas.

La aplicación Flutter utilizará la API o capa backend para sus funciones
esenciales y no dependerá del MCP Server.

Se define **Stasis Engine** como el subsistema de orquestación inteligente de
Stasis: coordinación multiagente, investigaciones, memoria federada, llamadas a
LLMs, control de costes y trazabilidad.

En el MVP, la API y una versión parcial de Stasis Engine podrán implementarse
mediante Supabase, RLS, funciones y Edge Functions. La separación en servicios
independientes se evaluará progresivamente con drivers técnicos verificados.

```text
Flutter App / Panel Admin
    -> Stasisly API / Backend
    -> Supabase / Storage / LLMs / Pagos / Servicios

Codex / Antigravity / Agentes IA
    -> MCP Server
    -> Docs / Repo / API autorizada / Logs / Herramientas internas
```

## Consecuencias positivas

- Frontera operativa clara para el producto.
- Lógica sensible centralizada, protegida y auditable.
- Flutter desacoplado de secretos, proveedores y herramientas internas.
- API y MCP pueden evolucionar sin confundirse.
- Stasis Engine obtiene responsabilidades y límites explícitos.
- Mejora autorización, observabilidad, trazabilidad y control de costes.
- Permite aprovechar Supabase y evolucionar según evidencia.

## Consecuencias negativas o costes

- Debe diseñarse y mantenerse una frontera backend explícita.
- Aumenta la necesidad de contratos, identidades, versionado y pruebas.
- Stasis Engine añade una responsabilidad arquitectónica.
- Un MCP Server futuro requerirá operación y seguridad propias.
- Existe riesgo de duplicación o sobreingeniería si se separa prematuramente.

## Alternativas consideradas

### Solo Supabase directo desde Flutter

Reduce esfuerzo inicial, pero puede trasladar lógica crítica al cliente y
dificultar autorización, auditoría y protección de proveedores.

**Decisión:** rechazado como estrategia general. Solo podrán exponerse
operaciones simples, aprobadas y protegidas mediante RLS.

### MCP como sustituto de API

Confunde herramientas para agentes con operaciones de producto, acopla Flutter
a MCP y amplía permisos y superficie de ataque.

**Decisión:** rechazado.

### Backend propio completo desde el día 1

Ofrece control máximo, pero aumenta coste, tiempo y riesgo de sobreingeniería
antes de validar el producto.

**Decisión:** no recomendado para el MVP salvo necesidad demostrada.

### API progresiva mediante Supabase y Edge Functions

Establece una frontera backend sin desplegar prematuramente múltiples servicios
y permite extraer Stasis Engine cuando existan drivers reales.

**Decisión:** alternativa recomendada para el MVP, pendiente de auditoría.

## Decisión recomendada por fase

### MVP

- API mínima o capa backend controlada.
- Supabase, RLS y Edge Functions donde resulte adecuado.
- Lógica sensible fuera de Flutter.
- Chats, catálogo, investigaciones iniciales, participantes visibles,
  membresía, Panel Admin básico y auditoría base.
- Stasis Engine parcial dentro de la capa backend.
- Sin dependencia obligatoria de MCP Server de producción.

### Fase 2

- API más robusta, investigaciones y memoria federada real.
- Mayor separación interna de Stasis Engine.
- Procesamiento de archivos, costes IA y observabilidad ampliados.
- Herramientas MCP controladas si existe necesidad.

### Fase 3

- Evaluar Stasis Engine como servicio independiente.
- Orquestación multiagente avanzada e investigaciones estratégicas.
- Integraciones externas y MCP Server si existe un caso aprobado.

### Futuro

- MCP Server de producción para integraciones autorizadas.
- Blockchain solo si aporta valor real y nunca para datos sensibles.
- Pagos cripto solo mediante proveedor regulado y revisión especializada.

## Agentes que deben revisar

- Arquitecto Principal.
- Arquitecto Backend.
- Arquitecto Multiagente.
- Especialista MCP.
- Especialista en Seguridad y Privacidad.
- Especialista AppSec / Ciberseguridad.
- Backend/Supabase Developer.
- DevOps / Infraestructura / Release Engineering.
- QA Engineer.
- Especialista en Costes IA y Optimización de Tokens.
- Especialista en Datos y Memoria.

Product Owner y Revisor de Coherencia también deben validar fase, valor y
consistencia con la visión.

## Criterios para desbloquear implementación

- Auditoría técnica completada.
- Alcance MVP de API y Stasis Engine aprobado.
- Responsabilidades de Supabase y Edge Functions definidas.
- Identidad, autorización, RLS y datos revisados.
- Threat model, privacidad y costes evaluados.
- Contratos, pruebas, observabilidad y rollback especificados.
- Aprobación explícita del cliente.

## Decisiones pendientes

- Contratos concretos de la API mínima.
- Componentes exactos de Stasis Engine para el MVP.
- Distribución entre Postgres, Edge Functions y futuros servicios.
- Modelo de identidad para apps, administradores, agentes y MCP.
- Modelo de memoria federada e investigaciones.
- Proveedores de LLM, pagos y procesamiento de archivos.
- Necesidad, alcance y fecha de un MCP Server de producción.

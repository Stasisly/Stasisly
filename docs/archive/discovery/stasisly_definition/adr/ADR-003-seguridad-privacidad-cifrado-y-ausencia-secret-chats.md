# ADR-003: Seguridad, privacidad, cifrado y ausencia de secret chats

## Estado

Aceptado conceptualmente, pendiente de auditoría técnica e implementación.

## Contexto

Stasisly podrá tratar chats, memoria, investigaciones, datos de salud y wellness,
archivos, pagos, administración y contenido procesado por IA. Crear un modo
separado de “secret chats” como flujo principal podría transmitir que el resto
del producto no está suficientemente protegido y fragmentaría el modelo de
seguridad.

La protección debe ser transversal, comprensible, auditable y aplicada según la
sensibilidad de los datos.

## Decisión

Stasisly no utilizará un modo separado tipo “secret chats” como flujo principal.
La seguridad y privacidad se aplicarán por diseño a la experiencia base.

El modelo conceptual incluye:

- cifrado fuerte en tránsito;
- cifrado en reposo;
- RLS estricta cuando se use Supabase con datos sensibles;
- autorización determinista y mínimo privilegio;
- cifrado de columnas sensibles cuando aplique;
- separación de claves por usuario o dominio cuando aplique;
- gestión, rotación, recuperación y revocación de claves;
- clasificación de sensibilidad;
- minimización y políticas de retención;
- consentimiento y transparencia;
- auditoría de acciones sensibles;
- corrección y borrado de memoria;
- protección contra prompt injection y contenido no confiable;
- respuesta a incidentes.

No se afirmará que existe cifrado extremo a extremo, aislamiento criptográfico,
borrado verificable u otra garantía concreta sin diseño aprobado, auditoría y
evidencia técnica.

## Consecuencias positivas

- Evita una falsa división entre conversaciones seguras e inseguras.
- Aplica protección coherente a chats, memoria e investigaciones.
- Reduce claims de seguridad ambiguos.
- Integra privacidad, AppSec, LLM security y gestión de claves.
- Facilita auditoría y respuesta a incidentes.

## Consecuencias negativas o costes

- Requiere clasificación de datos y controles por dominio.
- La gestión de claves y cifrado de columnas puede aumentar complejidad.
- RLS, autorización y borrado necesitan pruebas especializadas.
- Deben controlarse cuidadosamente logs, backups y proveedores externos.

## Alternativas consideradas

### Secret chats como flujo separado principal

Rechazada porque puede degradar la confianza en el flujo normal, fragmentar la
experiencia y no sustituye una arquitectura segura.

### Confiar únicamente en cifrado del proveedor

Rechazada como estrategia suficiente. El cifrado de infraestructura no sustituye
autorización, RLS, minimización, gestión de claves ni auditoría.

### Proteger solo datos identificados como médicos

Rechazada porque chats, wellness, memoria, investigaciones y metadatos también
pueden ser sensibles.

## Decisión por fases

### MVP

- Clasificación inicial de sensibilidad.
- Cifrado en tránsito y reposo mediante capacidades aprobadas.
- RLS/autorización estrictas.
- Auditoría base, consentimiento y respuesta inicial a incidentes.
- Protección mínima contra prompt injection.

### Fase 2

- Cifrado de columnas y separación de claves donde el riesgo lo justifique.
- Controles ampliados de retención, borrado, backups y proveedores.
- Pruebas de seguridad y privacidad más profundas.

### Fase 3 y Futuro

- Evolución criptográfica y operativa según threat model, cumplimiento y escala.
- Evaluación de garantías adicionales solo con necesidad y diseño verificables.

## Agentes y comités revisores

- Especialista en Seguridad y Privacidad.
- Especialista AppSec / Ciberseguridad.
- Especialista en Criptografía Aplicada y Gestión de Claves.
- Especialista en Seguridad LLM / Prompt Injection.
- Especialista en Datos y Memoria.
- Arquitecto Principal y Arquitecto Backend.
- Backend/Supabase Developer.
- QA Engineer y DevOps / Infraestructura / Release Engineering.
- Revisor de Coherencia del Producto.
- Comités de Arquitectura Técnica, IA y Implementación.

## Criterios para desbloquear implementación

- Auditoría técnica del estado real completada.
- Inventario y clasificación de datos definidos.
- Threat model aprobado.
- Modelo de identidad, autorización y RLS definido.
- Estrategia de cifrado y gestión de claves revisada.
- Políticas de consentimiento, retención, borrado y backups definidas.
- Plan de seguridad LLM y prompt injection aprobado.
- Plan de pruebas, observabilidad, respuesta a incidentes y rollback definido.
- Aprobación explícita del cliente.

## Decisiones pendientes

- Datos y columnas que requieren cifrado adicional.
- Modelo concreto de separación y custodia de claves.
- Requisitos regulatorios aplicables.
- Políticas de logs, backups y retención.
- Proveedores y garantías técnicas aceptables.
- Procedimientos concretos de incident response.

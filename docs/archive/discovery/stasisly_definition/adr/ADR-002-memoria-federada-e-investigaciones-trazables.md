# ADR-002: Memoria federada e investigaciones trazables

## Estado

Aceptado conceptualmente, pendiente de auditoría técnica e implementación.

## Contexto

Stasisly necesita conservar contexto útil sin crear una memoria global
indiscriminada ni opaca. Stasis coordina agentes especializados e
investigaciones, pero cada dato debe mantener propósito, procedencia, permisos,
sensibilidad y capacidad de control por parte del usuario.

Las conclusiones relevantes deben ser transparentes: el usuario debe poder saber
quién participó y abrir la investigación que explica la ruta de decisión, sin
exponer secretos, datos de terceros ni razonamiento interno sensible.

## Decisión

Stasisly utilizará memoria federada por niveles:

1. Memoria de especialista.
2. Memoria de subcategoría.
3. Memoria de rama.
4. Memoria global de Stasis.
5. Memoria de investigaciones.

Cada memoria deberá registrar como mínimo:

- propósito y nivel;
- propietario;
- procedencia;
- permisos y sensibilidad;
- fecha y caducidad;
- versión;
- auditoría;
- mecanismos de corrección y borrado.

La promoción de memoria entre niveles no será automática salvo que exista una
regla aprobada, verificable y auditable.

Stasisly soportará tres tipos conceptuales de investigación:

- rápida: problema concreto y participación limitada;
- profunda: participación de varias subcategorías o áreas;
- estratégica: revisión amplia, periódica o bajo demanda.

Cada investigación deberá registrar objetivo, tipo, participantes, fuentes,
aportaciones relevantes, conflictos, conclusión, nivel de confianza,
limitaciones, procedencia y ruta de decisión.

La interfaz podrá mostrar al usuario participantes y explicación de la
conclusión, pero no expondrá razonamiento interno sensible, secretos, prompts del
sistema ni datos de terceros.

## Consecuencias positivas

- Mantiene contexto sin centralización indiscriminada.
- Permite trazabilidad, corrección, borrado y auditoría.
- Mejora confianza y transparencia.
- Reduce contaminación entre especialistas y áreas.
- Permite aplicar mínimo privilegio y minimización.

## Consecuencias negativas o costes

- Requiere modelos de datos, permisos y políticas de retención explícitos.
- Aumenta complejidad de auditoría, versionado y borrado.
- Exige definir cuidadosamente qué información puede promocionarse.
- La transparencia debe equilibrarse con privacidad y seguridad.

## Alternativas consideradas

### Memoria global única

Rechazada por riesgo de exposición, contaminación, falta de propósito y
dificultad de borrado selectivo.

### Memoria aislada sin promoción

No adoptada como estrategia general porque impediría a Stasis sintetizar contexto
útil entre niveles autorizados.

### Mostrar razonamiento interno completo

Rechazada por riesgos de seguridad, privacidad, propiedad intelectual y
confusión. Se mostrará una explicación trazable y segura.

## Decisión por fases

### MVP

- Investigaciones iniciales con participantes visibles.
- Procedencia y ruta de decisión mínimas.
- Definición de contratos y permisos antes de persistir memoria sensible.

### Fase 2

- Memoria federada real.
- Corrección, borrado, caducidad, versionado y auditoría.
- Investigaciones profundas más robustas.

### Fase 3

- Investigaciones estratégicas.
- Promoción avanzada entre niveles bajo reglas auditables.
- Orquestación multiagente avanzada.

### Futuro

- Evolución basada en evidencia, cumplimiento y necesidades verificadas.

## Agentes y comités revisores

- Product Owner.
- Revisor de Coherencia del Producto.
- Arquitecto Principal.
- Arquitecto Multiagente.
- Especialista en Datos y Memoria.
- Especialista en Seguridad y Privacidad.
- Especialista AppSec / Ciberseguridad.
- Especialista en Criptografía Aplicada y Gestión de Claves.
- Ingeniero LLM y Testing de LLMs.
- Comités de Arquitectura Técnica e IA, LLMs y Agentes.

## Criterios para desbloquear implementación

- Auditoría técnica del estado real completada.
- Modelo de datos y contratos aprobados.
- Matriz de permisos, sensibilidad y retención definida.
- Estrategia de corrección, borrado, caducidad y versionado definida.
- Threat model y revisión de privacidad completados.
- Contrato de trazabilidad de investigaciones aprobado.
- Pruebas, observabilidad, costes y rollback especificados.
- Aprobación explícita del cliente.

## Decisiones pendientes

- Esquema concreto de memoria e investigaciones.
- Reglas exactas de promoción entre niveles.
- Políticas de retención y caducidad.
- Límites de visibilidad para usuario, administradores y agentes.
- Estrategia de borrado verificable y recuperación.
- Métricas de calidad, confianza y coste.

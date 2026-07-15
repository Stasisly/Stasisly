# Transición de Descubrimiento a Stasisly Foundation

## Estado

Registro de transición creado por `FOUNDATION-001`. Las decisiones
fundacionales aquí recogidas están aprobadas conceptualmente y pendientes de
formalización mediante ADR Foundation cuando corresponda.

## Fase de Descubrimiento

La Fase de Descubrimiento produjo definición de producto, gobierno del equipo
AAA, ADR, prototipos Flutter, contratos fail-closed, migraciones locales,
fronteras Supabase, Edge Functions y una base amplia de pruebas. Su objetivo fue
reducir incertidumbre y validar límites, no entregar todavía la plataforma
productiva completa.

Su cierre verificable es:

```text
commit: 7f747e0 test: validate session creation by selectable specialist
tag: discovery-final-baseline
```

El tag es inmutable: preserva código, documentación y pruebas del final de
Descubrimiento sin obligar a adoptar cada decisión en Foundation.

## Por qué se inicia Foundation

La exploración acumuló decisiones útiles, pero también nomenclatura transitoria,
documentación repetida, ADR excesivamente extensos, contratos legacy y piezas
local-safe que no deben confundirse con arquitectura productiva. Foundation
convierte la evidencia obtenida en una base normativa y técnica coherente,
portable, segura y preparada para crecer de forma proporcional.

## Qué se conserva

- Historial Git completo y tag de congelación.
- Documentación, ADR, planes y tracker como evidencia de Descubrimiento.
- Código Flutter, migraciones, Edge Functions y pruebas existentes.
- Contratos fail-closed, separación de IDs y controles de seguridad validados.
- Aprendizajes sobre catálogo Product, sesiones, mensajes, identidad y RLS.
- Equipo AAA de 43 agentes como material de referencia de Development.

Conservar no equivale a adoptar. Cada activo requiere clasificación y gate.

## Qué no adquiere autoridad Foundation automáticamente

- Nombres antiguos como `Wizard/Development Surface` o `Admin/Engine Surface`.
- Categorías `fisico` y `mental` como taxonomía definitiva de producto.
- Rutas legacy, chat heredado, mocks, fixtures o shells dev-only.
- Decisiones históricas incrustadas en ADR acumulativos sin consolidación.
- Suposiciones sobre IA, memoria, investigaciones, pagos o agentes no
  implementados.
- Dependencias de proveedor sin evaluación de portabilidad y salida.

Desde FOUNDATION-002, la documentación de Descubrimiento se conserva físicamente
bajo `docs/archive/discovery/`, sin autoridad normativa. Su antigua jerarquía
operativa queda reemplazada por el gobierno documental Foundation, y sus
propuestas no se promueven por defecto a norma Foundation.

## Qué es Stasisly Foundation

Foundation es la etapa que establece constitución, vocabulario, arquitectura
global, límites de las surfaces, seguridad, portabilidad, gobierno de agentes y
estándares de ingeniería antes de reconstruir o ampliar producto.

No es un borrado ni un reinicio ciego. Es una adopción selectiva basada en
evidencia.

## Principios aprobados conceptualmente

### Autoridad y coordinación

- El Fundador conserva la autoridad humana final.
- Nexus coordina las tres surfaces y está subordinado al Fundador.
- Stasis coordina exclusivamente Product Surface.
- Rector coordina exclusivamente Development Surface.
- Gerendi coordina exclusivamente Administration Surface.
- Nexus no es una cuarta surface ni hereda acceso total.

### Surfaces y acceso

Las surfaces son Product, Development y Administration. Los accesos futuros se
diseñarán con RBAC, ABAC, mínimo privilegio, gates de entorno, elevación temporal,
auditoría y revocación. Ningún rol obtiene acceso total por herencia.

### Stasis Engine

Stasis Engine es una plataforma interna de inteligencia, orquestación y
ejecución; no es una surface. Product consume capacidades autorizadas,
Development construye y modifica, y Administration opera únicamente lo
permitido.

### Escala, wearables y soberanía

- Arquitectura preparada para hiperescala; implementación proporcional.
- `WEARABLE_READY`, no `WEARABLE_DEPENDENT`.
- Control propio sobre datos, contratos, dominio, agentes, prompts, memoria,
  migraciones, costes y planes de salida.
- Supabase puede ser infraestructura inicial, no dependencia irreversible.

### Agentes y consumo de IA

- Los agentes serán operados por Stasisly y sus claves permanecerán en backend.
- La ejecución será bajo demanda y especializada.
- Stasis Engine usará un Model Gateway con medición, presupuestos, cuotas, rate
  limits, circuit breakers, routing, caché y detección de abuso.
- BYOK queda como opción futura; OAuth conecta servicios externos y no sustituye
  el modelo de consumo de IA.

### Roadmap

Stasis, Rector, Gerendi, Nexus, Product Owner y Program Management proponen el
roadmap. El Fundador aprueba, rechaza, devuelve, prioriza o veta.

## Límites de FOUNDATION-001

Este paquete solo congela, inventaría, clasifica y propone. No mueve documentos,
no reescribe ADR, no cambia código, no crea agentes, no activa surfaces, no
conecta remoto y no implementa Stasis Engine, MCP, wearables ni IA.

## Relación con Git

El tag `discovery-final-baseline` permite comparar cualquier trabajo Foundation
contra el cierre exacto de Descubrimiento. Los cambios Foundation se realizan en
commits posteriores y nunca alteran el tag.

## Siguiente fase

`FOUNDATION-002` ejecuta el archivo documental controlado de Descubrimiento y
establece la autoridad documental inicial de Foundation. El siguiente gate
propuesto es `FOUNDATION-003`, que debe definir constitución, gobernanza global y
modelo de decisión sin convertir roles conceptuales en agentes activos.

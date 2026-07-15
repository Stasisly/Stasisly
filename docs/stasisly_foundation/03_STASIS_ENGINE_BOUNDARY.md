# Frontera de Stasis Engine

## Metadatos

| Campo | Valor |
|---|---|
| Título | Frontera de Stasis Engine |
| Estado | APPROVED conceptually, detailed architecture pending |
| Nivel de autoridad | 1 — Constitución y gobierno aprobados por Founder |
| Propietario | Arquitectura bajo Rector; coordinación global de Nexus |
| Aprobador | Founder |
| Versión | 1.0 |
| Condición de vigencia | Decisión conceptual vigente con FOUNDATION-003 |
| Sustituye | Fusión histórica entre Administration y Engine |
| Dependencias | 00_GLOBAL_CONSTITUTION; 02_SURFACES_AND_ACCESS |

## Estado de implementación

```text
Conceptual decision: APPROVED
Detailed technical architecture: NOT IMPLEMENTED
```

## Definición

Stasis Engine es la plataforma interna de inteligencia, orquestación y
ejecución de Stasisly. No es una surface, no es Stasis y no posee autoridad
organizativa propia.

## Relación con el sistema

```text
Product Surface consume capacidades autorizadas de Stasis Engine.
Development Surface construye, mantiene y valida Stasis Engine.
Administration Surface opera capacidades autorizadas de Stasis Engine.
Nexus coordina su uso global.
Founder conserva la autoridad final.
```

Ninguna de estas relaciones concede acceso total por herencia. Las operaciones
se someterán a autorización técnica, gates de entorno, mínimo privilegio y
auditoría según su riesgo.

## Componentes conceptuales futuros

- Agent Runtime.
- Agent Registry.
- Prompt Registry.
- Orchestration.
- Routing.
- Memory.
- Context.
- Tool Gateway.
- Model Gateway.
- Cost Controller.
- Evaluation.
- Observability.
- Safety Controls.

La lista preserva fronteras de diseño; no selecciona arquitectura, proveedor,
modelo, API, runtime ni mecanismo de despliegue.

## Agentes, credenciales y consumo

Stasisly opera los agentes. El usuario normal no aporta API key. Las
credenciales permanecen en backend, los agentes se ejecutan bajo demanda y no
todos se activan por consulta. El consumo se mide y limita. BYOK puede evaluarse
como opción futura y OAuth conecta servicios externos; ninguno se implementa
en este paquete.

Model Gateway y Cost Controller requieren un ADR posterior. No se selecciona
proveedor de IA ni se registran precios.

## Soberanía tecnológica

Stasisly debe conservar control, portabilidad y capacidad de salida sobre
datos, contratos, lógica de negocio, agentes, prompts, memoria, modelos,
infraestructura y proveedores. Los servicios managed están permitidos cuando
sean convenientes; el lock-in irreversible no puede adoptarse silenciosamente.
Esto no obliga a self-hosting inmediato.

## Escala y dispositivos

El diseño debe permitir expansión global e hiperescala sin activar complejidad
prematura, cientos de agentes innecesarios ni infraestructura
sobredimensionada. Debe mantener rutas de crecimiento y sustitución.

Stasisly es `WEARABLE_READY` y no `WEARABLE_DEPENDENT`. Apple Watch, Wear OS,
Garmin, otros wearables, sensores y dispositivos propios son extensiones
futuras; aquí no se diseñan ni implementan integraciones.

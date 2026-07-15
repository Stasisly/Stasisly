# ADR-F001 — Gobierno global, Founder, Nexus y surfaces

## Metadatos

| Campo | Valor |
|---|---|
| Estado | APPROVED |
| Fecha | No registrada |
| Propietario | Founder; Program Management para el registro |
| Aprobador | Founder |
| Nivel de autoridad | 2 — ADR Foundation aprobado |
| Dependencias | 00_GLOBAL_CONSTITUTION; FOUNDATION_TRANSITION |

## Contexto

Descubrimiento produjo definiciones útiles, pero mantuvo nomenclaturas y
fronteras transitorias. Foundation necesita una autoridad humana inequívoca,
coordinación global sin concentración automática de permisos, tres surfaces
separadas y un flujo de roadmap que no convierta a Founder en redactor
operativo.

## Decisión

1. Founder es la autoridad humana final y conserva en exclusiva la posibilidad
   de acceso total protegido mediante Founder Standard Authority, Founder
   Elevated Authority y Founder Emergency Authority.
2. Ninguna identidad hereda Founder Authority ni acceso total. Delegar una
   tarea no transfiere autoridad reservada.
3. Nexus coordina inteligencia, coherencia, dependencias y roadmap global; no es
   una cuarta surface, no actúa como Founder y no concentra permisos por
   defecto.
4. Stasis, Rector y Gerendi coordinan exclusivamente Product Surface,
   Development Surface y Administration Surface, respectivamente.
5. Las únicas surfaces globales vigentes son Product Surface, Development
   Surface y Administration Surface.
6. Authority y Access son dimensiones distintas. La implementación futura
   combinará RBAC, ABAC, environment gates, least privilege, just-in-time
   elevation, audit trail y revocation.
7. Stasis Engine es una plataforma interna, no una surface ni Stasis.
8. Stasis, Rector y Gerendi proponen roadmaps de surface; Program Management y
   Product Owner estructuran; Nexus consolida; Founder decide.
9. F0–F12 queda aprobado como marco inicial, mientras calendario, capacidad,
   costes, asignaciones y orden interno detallado siguen `PROPOSED`.

## Consecuencias

- La autoridad global y las fronteras organizativas quedan definidas sin crear
  agentes, prompts, usuarios ni permisos técnicos.
- Las decisiones reservadas no pueden cerrarse por consenso de agentes.
- El acceso a producción, secretos y datos críticos requerirá diseños técnicos
  posteriores y controles reforzados.
- `Wizard Surface`, `Admin/Engine Surface`, Stasis como coordinador global y
  Panel Admin dentro de Product quedan reemplazados como nomenclatura vigente.
- Las arquitecturas de autorización, Stasis Engine y Model Gateway requieren
  ADR y paquetes posteriores.

## Alternativas descartadas

- Un `super_admin` ordinario para Founder: protección insuficiente para una
  autoridad raíz.
- Nexus con acceso total heredado: viola mínimo privilegio y separación de
  autoridad y acceso.
- Stasis Engine como cuarta surface: mezcla plataforma interna con fronteras de
  experiencia y operación.
- Founder como autor operativo del roadmap: concentra trabajo sin mejorar la
  autoridad de decisión.

## Implementación

```text
Conceptual decision: APPROVED
Technical implementation: NOT IMPLEMENTED
```

Este ADR no crea prompts, rosters, claims, roles, RLS, credenciales, runtime,
integraciones, proveedores ni acceso remoto.

# ADR-012 — Jerarquia de agentes Product y Admin/Engine

## Estado

Aprobada conceptualmente / Pendiente de implementacion.

## Contexto

ADR-009 separa Product Surface, Wizard/Development Surface y Admin/Engine
Surface. ADR-010 define el catalogo producto de especialistas conversables y
ADR-011 define guards y contratos para protegerlo antes de implementar schema,
seeds, catalogo real o `/conversations`.

Antes de implementar tests, guards reales o cualquier catalogo, Stasisly debe
cerrar una regla estructural: las superficies que contengan agentes internos o
conversables no deben organizarse como listas planas. La app ya define una
jerarquia conceptual de producto alrededor de Stasis, jefes de rama, jefes de
subcategoria y especialistas. El equipo de desarrollo AAA tambien usa una
estructura con coordinacion central, comites, responsables y especialistas.

AG99 es documental. No implementa codigo, no crea tests, no toca Supabase, no
ejecuta SQL, no crea migraciones, no crea seeds, no puebla
`specialist_catalog`, no crea agentes reales, no registra `/conversations`, no
usa datos reales y no activa staging ni production.

## Decision

Toda superficie de Stasisly que tenga agentes internos, operativos o
conversables debe evitar estructuras planas.

Product Surface y Admin/Engine Surface deben organizar sus agentes en
jerarquias con coordinador principal, jefes de departamento o rama y agentes
especialistas bajo cada departamento. El patron conceptual replica la logica
del equipo de desarrollo: coordinacion central, departamentos, jefes de rama,
especialistas, responsabilidades explicitas, capacidad de bloqueo, escalado y
trazabilidad.

Esta decision no reutiliza agentes internos de desarrollo como especialistas
producto ni como agentes Admin/Engine. Se replica el patron jerarquico; las
familias de agentes permanecen separadas.

## Principio jerarquico comun

Las superficies con agentes deben estructurarse como minimo con:

1. coordinador principal de superficie;
2. jefes de departamento, rama o area;
3. agentes especialistas dentro de cada departamento;
4. limites de responsabilidad por nivel;
5. trazabilidad de decisiones, intervenciones y escalados;
6. capacidad de escalado;
7. capacidad de bloqueo segun rol, riesgo y permiso.

Ninguna familia de agentes debe convertirse en una lista plana sin autoridad,
limites, ownership operacional ni ruta de escalado.

## Relacion con el equipo de desarrollo

El equipo AAA de desarrollo funciona como patron conceptual de gobierno:

- direccion central;
- comites o departamentos;
- responsables por area;
- especialistas;
- criterios de intervencion;
- revision cruzada;
- capacidad de bloqueo por seguridad, calidad o coherencia;
- documentacion y trazabilidad.

Product Surface y Admin/Engine Surface deben heredar esta logica estructural,
pero no sus agentes concretos.

Esto no significa:

- exponer agentes internos de desarrollo al usuario final;
- copiar prompts internos del equipo AAA al producto;
- convertir comites tecnicos en especialistas producto;
- permitir agentes Admin/Engine en Product Surface;
- permitir especialistas producto en Admin/Engine como operadores internos.

## Jerarquia Product Surface

La jerarquia conceptual inicial de Product Surface queda organizada asi:

```text
Stasis — Coordinador producto principal

Salud
  -> Jefe/a de Salud
      -> Especialistas de Salud

Nutricion
  -> Jefe/a de Nutricion
      -> Especialistas de Nutricion

Entrenamiento
  -> Jefe/a de Entrenamiento
      -> Especialistas de Entrenamiento

Wellness
  -> Jefe/a de Wellness
      -> Especialistas Wellness
      -> Subareas futuras: Descanso/Sueno, Mindfulness, habitos, estres,
         recuperacion y bienestar diario
```

Estos nombres son estructura conceptual, no registros reales. No cierran
nombres definitivos, no pueblan `specialist_catalog`, no crean especialistas
producto y no autorizan que los jefes sean conversables.

La decision sobre si un jefe de rama producto sera visible, conversable,
coordinador interno no visible o ambas cosas requiere ADR o paquete posterior.

## Jerarquia Admin/Engine Surface

La jerarquia conceptual inicial de Admin/Engine Surface queda organizada asi:

```text
Admin/Engine — Coordinador operativo principal

Datos & Analytics
  -> Jefe/a de Datos & Analytics
      -> Agentes analistas de datos, cohortes, metricas y anomalias

Usuarios & Soporte
  -> Jefe/a de Usuarios & Soporte
      -> Agentes de soporte, satisfaccion, incidencias y feedback

Suscripciones & Negocio
  -> Jefe/a de Suscripciones & Negocio
      -> Agentes de retencion, conversion, planes, ingresos y reporting

Riesgo, Calidad & Compliance
  -> Jefe/a de Riesgo/Calidad/Compliance
      -> Agentes de auditoria, abuso, seguridad operativa, calidad y
         cumplimiento

Operaciones Stasis Engine
  -> Jefe/a de Operaciones Engine
      -> Agentes de monitorizacion, rendimiento, reporting operativo y salud
         del sistema
```

Estos departamentos son conceptuales. No crean agentes Admin/Engine reales, no
crean panel Admin/Engine, no otorgan permisos reales, no acceden a datos reales
y no autorizan acciones administrativas.

## Coordinadores principales

Cada superficie con agentes debe tener un coordinador principal conceptual.

Product Surface:

- Stasis actua como coordinador producto principal.
- Coordina areas, jefes de rama y especialistas producto.
- Debe preservar transparencia, trazabilidad, memoria federada y seguridad.

Admin/Engine Surface:

- Admin/Engine Coordinator actua como coordinador operativo principal futuro.
- Coordina departamentos operativos, analitica, soporte, riesgo y operaciones
  del Stasis Engine.
- Debe operar bajo permisos, auditoria, minimizacion y supervision humana
  cuando corresponda.

Ser coordinador no implica acceso ilimitado, `service_role`, bypass de RLS ni
capacidad de ejecutar acciones sensibles sin backend, permisos y auditoria.

## Jefes de departamento/rama

Los jefes de departamento o rama:

- coordinan especialistas de su area;
- consolidan respuestas, analisis o recomendaciones de especialistas;
- escalan al coordinador de superficie cuando el caso excede su area;
- pueden bloquear acciones inseguras dentro de su departamento;
- deben exigir trazabilidad y criterios de aceptacion cuando corresponda;
- no pueden saltarse permisos backend;
- no pueden acceder a datos fuera de su superficie;
- no pueden exponer informacion interna al usuario final;
- no sustituyen revision humana en acciones sensibles.

Un jefe de departamento no implica acceso total. Sus permisos deben ser
minimos, auditables y definidos por backend/politicas.

## Agentes especialistas

Los agentes especialistas:

- operan dentro de un departamento concreto;
- tienen alcance limitado y explicito;
- no actuan como jefes salvo configuracion posterior aprobada;
- no cruzan superficies;
- no acceden a datos no autorizados;
- no exponen prompts internos;
- no ejecutan acciones sensibles sin validacion y permisos;
- escalan al jefe de departamento cuando el caso excede su alcance;
- deben dejar trazabilidad de su intervencion cuando participen en una
  decision relevante.

## Reglas de escalado

Regla general:

```text
Especialista -> Jefe de departamento -> Coordinador de superficie ->
revision humana o sistema superior si procede
```

Product Surface:

```text
Especialista producto -> Jefe de area producto -> Stasis coordinador producto
-> usuario/revision humana si aplica
```

Admin/Engine Surface:

```text
Agente Admin/Engine -> Jefe de departamento Admin/Engine ->
Coordinador operativo Admin/Engine -> administrador humano
```

El escalado no autoriza automaticamente datos, permisos, acciones sensibles ni
exposicion de informacion interna. Solo define ruta de responsabilidad.

## Reglas de bloqueo

Los coordinadores, jefes o especialistas pueden bloquear, segun su rol y
alcance:

- acciones inseguras;
- mezcla de superficies;
- exposicion de campos prohibidos;
- uso de agentes internos de desarrollo en Product Surface;
- uso de agentes Admin/Engine en Product Surface;
- uso de especialistas producto como agentes Admin/Engine sin decision
  posterior;
- catalogo roto;
- datos no autorizados;
- acciones sensibles sin aprobacion;
- intentos de saltar permisos, RLS, backend o auditoria;
- exposicion de prompts internos, tokens, fixtures o datos reales no
  autorizados.

Todo bloqueo debe indicar motivo, riesgo, superficie afectada, responsable de
resolverlo y condicion concreta de desbloqueo.

## Permisos por nivel

Los permisos deben ser minimos y por rol.

Reglas:

- ser especialista no implica poder acceder a toda el area;
- ser jefe de departamento no implica acceso total;
- ser coordinador no implica `service_role` ni acceso ilimitado;
- la autoridad visible en UI no sustituye autorizacion backend;
- toda accion sensible depende de backend, roles, politicas, auditoria y
  validacion humana cuando corresponda;
- el frontend no decide permisos finales;
- Admin/Engine no puede convertirse en superusuario informal;
- Product Surface no puede exponer permisos internos.

## Trazabilidad y auditoria

Toda familia de agentes debe registrar de forma proporcional:

- quien intervino;
- superficie;
- departamento o rama;
- rol;
- accion o recomendacion;
- datos usados o fuente autorizada;
- decision tomada;
- escalado realizado;
- bloqueo aplicado;
- resultado;
- timestamp o correlacion auditada cuando exista backend real.

La trazabilidad debe explicar participacion y ruta de decision sin exponer
prompts internos, secretos, chain of thought, datos de terceros ni informacion
sensible innecesaria.

## Relacion con specialist_catalog

`specialist_catalog` producto solo puede contener entidades Product Surface
autorizadas.

Puede representar jerarquia producto si se aprueba en un paquete posterior,
pero nunca agentes internos de desarrollo ni agentes Admin/Engine.

Los jefes de departamento producto podrian ser entidades producto conversables,
entidades producto no conversables, coordinadores internos no visibles o una
combinacion controlada. Esta ADR no decide esa implementacion.

No se debe poblar `specialist_catalog` hasta aprobar schema, guards, datos y
paquete especifico.

## Relacion con diseño de migracion 2B-AG110

AG110 prepara el diseño documental de la futura migracion del catalogo producto:

```text
docs/stasisly_definition/implementation_plans/2B-AG110-product-catalog-migration-design.md
```

Ese diseño propone que `specialist_catalog` pueda representar jerarquia Product
mediante campos como `hierarchy_level` y `parent_catalog_id`, sin mezclar
agentes internos de desarrollo ni agentes Admin/Engine.

AG110 no decide todavia que jefes de rama sean conversables, no crea agentes
reales, no puebla `specialist_catalog`, no registra `/conversations`, no toca
Supabase y no ejecuta SQL.

## Relacion con /conversations

Product `/conversations` podra usar especialistas producto autorizados por
backend.

La participacion de jefes de departamento en conversaciones requiere decision
posterior:

- visibles al usuario;
- no visibles pero coordinadores internos;
- conversables;
- no conversables;
- escalado interno;
- trazabilidad mostrada al usuario.

Esta ADR no registra `/conversations`, no modifica rutas y no autoriza
implementacion.

## Relacion con Admin/Engine agents

Los agentes Admin/Engine deben seguir jerarquia por departamentos.

Reglas:

- no son especialistas producto;
- no aparecen en `specialist_catalog` producto;
- no conversan con usuarios finales;
- no aparecen en Product Surface;
- asisten al administrador bajo permisos, auditoria y trazabilidad;
- no pueden saltarse RLS, backend, minimizacion ni revision humana cuando
  corresponda.

## Relacion con wearables

Wearables futuros no alteran la jerarquia.

Si algun dia Apple Watch, Wear OS o Garmin interactuan con especialistas
producto, heredaran las reglas de Product Surface y requeriran ADR o paquete
especifico.

Wearables no pueden exponer agentes Admin/Engine, agentes internos de
desarrollo, prompts internos, permisos internos ni datos no autorizados.

## Alcance autorizado

AG99 autoriza solo documentacion:

- crear esta ADR;
- anadir referencias breves en ADR-009, ADR-010, ADR-011, arquitectura,
  definicion de proyecto y tracker;
- registrar el cierre formal de AG98 y la preparacion de AG99.

## Alcance no autorizado

AG99 no autoriza:

- codigo;
- tests;
- cambios en `supabase/`;
- SQL;
- migraciones;
- seeds;
- fixtures;
- poblar `specialist_catalog`;
- crear especialistas reales;
- crear agentes reales;
- registrar `/conversations`;
- conectar producto;
- usar datos reales;
- staging;
- production;
- deploy;
- push.

## Riesgos

Riesgos altos:

- convertir `specialist_catalog` en una lista plana sin coordinacion;
- exponer agentes internos de desarrollo como producto;
- exponer agentes Admin/Engine como producto;
- convertir Admin/Engine en superusuario informal;
- permitir que jefes de departamento impliquen acceso total.

Riesgos medios:

- definir demasiados nombres antes de validar producto;
- mezclar coordinacion interna con entidades conversables visibles;
- duplicar jerarquias entre Product y Admin/Engine sin contratos comunes;
- no registrar escalados o bloqueos.

Riesgos bajos:

- sobre-documentar antes de implementar;
- requerir renombres cuando se cierre el catalogo real.

## Relacion con ADR-009

ADR-009 separa Product Surface, Wizard/Development Surface y Admin/Engine
Surface. ADR-012 anade una regla estructural: las superficies con agentes deben
usar jerarquia, no listas planas.

## Relacion con ADR-010

ADR-010 define el catalogo producto de especialistas conversables. ADR-012
aclara que ese catalogo puede representar una jerarquia producto futura, pero
solo con entidades Product Surface autorizadas y sin mezclar agentes internos o
Admin/Engine.

## Relacion con ADR-011

ADR-011 define guards y contratos del catalogo producto. ADR-012 anade que esos
guards deben proteger tambien la jerarquia: coordinadores, jefes y
especialistas no pueden saltarse allowlists, permisos, superficies ni contratos
publicos.

## Revision 2B-AG100

AG100 revisa y aprueba conceptualmente esta ADR con ajustes menores
documentales.

La decision central no cambia: Product Surface y Admin/Engine Surface deben
organizar agentes mediante jerarquias, no listas planas. La revision confirma:

- se replica el patron jerarquico del equipo de desarrollo, no sus agentes;
- los agentes internos de desarrollo no se convierten en especialistas
  producto ni en agentes Admin/Engine;
- Product Surface mantiene Stasis como coordinador producto principal;
- Admin/Engine Surface mantiene coordinacion operativa separada;
- los jefes de departamento son conceptuales y no implican acceso total;
- los especialistas tienen alcance limitado y no cruzan superficies;
- los permisos por nivel dependen de backend, politicas, auditoria y revision
  humana cuando corresponda;
- `specialist_catalog` producto sigue protegido y no se puebla;
- no se decide todavia si los jefes producto seran conversables;
- `/conversations` sigue sin implementarse;
- wearables futuros heredan reglas de Product Surface si algun dia interactuan
  con especialistas producto;
- ADR-012 no contradice ADR-009, ADR-010 ni ADR-011.

Resultado de revision:

- decision: ADR-012 aprobada con ajustes menores;
- readiness: `AGENT HIERARCHY ADR APPROVED WITH MINOR CHANGES`;
- estado actualizado a `Aprobada conceptualmente / Pendiente de implementacion`;
- no se implementa codigo;
- no se crean tests;
- no se toca Supabase;
- no se ejecuta SQL;
- no se crean migraciones, seeds ni fixtures;
- no se puebla `specialist_catalog`;
- no se crean agentes reales ni especialistas reales;
- no se registra `/conversations`;
- no se usan datos reales, staging ni production.

## Estado de implementacion

No implementado.

No existe autorizacion en esta ADR para modificar codigo, crear tests, tocar
Supabase, ejecutar SQL, crear migraciones, crear seeds, poblar
`specialist_catalog`, crear especialistas reales, crear agentes reales,
registrar `/conversations`, usar datos reales, activar staging, activar
production, desplegar cambios ni hacer push.

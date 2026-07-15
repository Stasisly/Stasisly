# ADR-009 — Superficies operativas Stasisly: Product, Wizard/Dev y Admin/Engine

## Estado

Aprobada conceptualmente / Pendiente de implementación.

## Contexto

Stasisly no puede gobernarse solo mediante entornos técnicos como local,
development, staging o production. El proyecto necesita separar tambien las
superficies operativas desde las que se usa, construye, administra y audita el
sistema.

Esta decisión es previa a cualquier consolidación o implementación productiva
de `/conversations`, porque afecta a rutas, permisos, roles, agentes,
especialistas producto, catálogo, datos, métricas, administración, Stasis
Engine, seguridad, auditoría, staging, production y desarrollo.

AG84 pausa el baseline/commit previamente recomendado para el plan
`/conversations` de AG83. Antes de consolidar o implementar esa ruta debe
quedar documentada la frontera entre Product Surface, Wizard/Development
Surface y Admin/Engine Surface.

## Decisión

Stasisly se organizará mediante tres superficies operativas separadas:

1. Product Surface: app cliente para usuarios finales, staging comercial y
   production.
2. Wizard/Development Surface: superficie superior de desarrollo, control,
   validación, auditoría y construcción.
3. Admin/Engine Surface: superficie de gestión operativa, administración,
   datos, métricas, soporte, analítica y operaciones del Stasis Engine.

Cada superficie tiene propósito, usuarios, permisos, rutas, datos, agentes y
límites propios. Ninguna superficie puede absorber informalmente las
responsabilidades de otra.

## Superficie 1 — Product / Staging / Production

Product Surface es la app que el cliente final descarga y utiliza. Incluye la
futura app en staging y production cuando esos entornos estén definidos y
aprobados.

Está orientada al usuario final y solo puede exponer funcionalidades producto.

Puede incluir:

- onboarding de usuario;
- Home/Stasis;
- Salud;
- Nutrición;
- Entrenamiento;
- Wellness;
- especialistas producto;
- conversaciones producto;
- perfil de usuario;
- suscripción;
- ajustes;
- experiencia cliente final.

No puede incluir:

- agentes internos AAA de desarrollo;
- agentes Admin/Engine;
- comités técnicos;
- herramientas de auditoría interna;
- panel admin;
- métricas globales internas;
- gestión de usuarios;
- datos de otros usuarios;
- fixtures sintéticos;
- debug tools;
- dev-shell;
- `service_role`;
- rutas heredadas inseguras.

Reglas obligatorias:

- solo puede usar especialistas producto sanitizados;
- no puede exponer agentes internos de desarrollo;
- no puede exponer agentes Admin/Engine;
- no puede exponer herramientas admin;
- no puede exponer métricas internas;
- no puede usar fixtures development;
- no puede usar tokens sintéticos;
- no puede usar `service_role` en cliente;
- no puede acceder a datos de otros usuarios.

## Superficie 2 — Wizard / Dev / Development

Wizard/Development Surface es la superficie superior de desarrollo, control,
construcción, validación y auditoría del proyecto.

No es producto. No es descargable por clientes. Sirve al equipo autorizado para
desarrollar Stasisly, probar flujos, auditar decisiones, validar arquitectura,
revisar fixtures, diagnosticar errores y gobernar el proyecto.

Puede incluir:

- herramientas dev;
- diagnósticos;
- fixtures sintéticos;
- dev-shell;
- validación de backend;
- validación de Flutter;
- guards;
- feature flags;
- auditoría técnica;
- agentes internos del equipo de desarrollo;
- comités técnicos;
- herramientas de revisión de arquitectura;
- herramientas de QA;
- herramientas de pruebas.

Wizard/Dev puede tener acceso ampliado y privilegiado, pero nunca acceso
ilimitado informal. Todo acceso debe estar controlado por permisos explícitos,
trazabilidad, auditoría, separación de entornos y bloqueo frente a clientes
finales.

No puede confundirse con:

- Product Surface;
- Admin/Engine Surface;
- app cliente final;
- staging comercial;
- production;
- datos reales sin política explícita posterior;
- panel de explotación de usuarios.

## Superficie 3 — Admin / Engine

Admin/Engine Surface es la superficie operativa para gestión, administración,
métricas, estadísticas, datos permitidos, soporte, moderación, analítica,
reporting, gobierno interno de la app y operaciones del Stasis Engine.

No es la app cliente. No es el Wizard de desarrollo. Debe tener roles
granulares, permisos, logs de auditoría y políticas de acceso a datos.

Puede incluir:

- gestión de usuarios;
- gestión de suscripciones;
- gestión de datos permitidos;
- métricas;
- estadísticas;
- analítica;
- moderación;
- soporte;
- auditoría de acciones;
- paneles internos;
- operaciones del Stasis Engine;
- observabilidad;
- reporting;
- alertas;
- calidad;
- riesgo;
- abuso;
- cohortes;
- retención.

No puede ser:

- superusuario informal;
- acceso sin auditoría;
- panel mezclado con app cliente;
- dev-shell;
- lugar para probar fixtures sin control;
- vía para saltarse RLS o políticas de datos;
- sustituto de la API segura.

## Equipo IA Admin/Engine

Admin/Engine Surface puede incluir un equipo propio de agentes IA especializados
en gestión, datos, métricas y toma de decisiones operativas.

Estos agentes son una tercera familia separada:

1. Agentes internos de desarrollo: Wizard/Development Surface.
2. Especialistas producto: Product Surface.
3. Agentes Admin/Engine: Admin/Engine Surface.

Los agentes Admin/Engine son agentes IA internos orientados a ayudar al
administrador y al equipo operativo a gestionar usuarios, analizar datos,
revisar métricas, detectar anomalías, evaluar calidad, preparar informes y
apoyar decisiones de negocio u operación.

Ejemplos futuros no cerrados:

- Data Analyst Agent;
- User Insights Agent;
- Retention Analyst Agent;
- Subscription Analyst Agent;
- Metrics & KPI Agent;
- Anomaly Detection Agent;
- Compliance Monitoring Agent;
- Support Intelligence Agent;
- Quality Auditor Agent;
- Risk & Abuse Detection Agent;
- Admin Decision Assistant;
- Operations Intelligence Agent.

AG84 no define el equipo Admin/Engine final. Solo documenta la categoría,
propósito, límites y ejemplos.

### Límites de agentes Admin/Engine

Los agentes Admin/Engine:

- no son especialistas producto;
- no aparecen en `specialist_catalog` producto;
- no conversan con usuarios finales;
- no aparecen en onboarding;
- no forman parte de Product Surface;
- no son agentes de desarrollo;
- no sustituyen permisos, auditoría ni revisión humana;
- no pueden saltarse RLS ni políticas de datos;
- no pueden acceder a datos no autorizados por rol;
- no pueden ejecutar acciones destructivas sin autorización explícita;
- no pueden exponer datos personales innecesarios.

### Capacidades permitidas de agentes Admin/Engine

Pueden ayudar con:

- métricas;
- estadísticas;
- analítica;
- cohortes;
- retención;
- suscripciones;
- uso de la app;
- detección de anomalías;
- calidad de respuestas;
- moderación;
- soporte;
- auditoría;
- informes;
- alertas;
- decisiones operativas;
- gobierno de datos.

Toda acción de agentes Admin/Engine debe estar limitada por rol, permiso,
auditoría, trazabilidad y principio de mínimo privilegio.

Las recomendaciones de estos agentes no deben convertirse automáticamente en
acciones destructivas o sensibles sin confirmación humana y registro de
auditoría.

## Superficies vs entornos

Las superficies no son lo mismo que los entornos.

Una superficie define propósito, usuarios, permisos y capacidades. Un entorno
define dónde se ejecuta técnicamente.

Ejemplos:

- Product Surface: staging y production.
- Wizard/Development Surface: local, development e internal testing.
- Admin/Engine Surface: admin development, admin staging y admin production.

Un mismo entorno no puede justificar mezclar superficies. Un entorno production
de Product Surface no debe contener dev-shell. Un entorno development no debe
usar datos reales sin política explícita. Un admin production no debe actuar
como bypass informal de RLS, auditoría o API segura.

## Extensión futura — Wearables / Smartwatch Companion Apps

Stasisly contempla a futuro una extensión companion para relojes inteligentes,
incluyendo Apple Watch, Android/Wear OS y Garmin.

Esta extensión no sustituye Product Surface, Wizard/Development Surface ni
Admin/Engine Surface. No se considera una cuarta superficie operativa principal
en esta fase. Debe entenderse como una extensión futura y limitada de Product
Surface orientada al usuario final.

Capacidades futuras posibles, sin cerrar alcance final:

- consultar métricas personales permitidas;
- recibir alertas o recordatorios;
- registrar hábitos simples;
- acompañar entrenamientos;
- acompañar wellness;
- acompañar descanso o sueño;
- mostrar estados resumidos;
- sincronizar señales permitidas con la app principal.

La extensión wearable no debe:

- contener lógica sensible crítica;
- acceder directamente a Supabase;
- usar `service_role`;
- exponer Admin/Engine;
- exponer Wizard/Development;
- exponer agentes internos de desarrollo;
- exponer agentes Admin/Engine;
- mostrar datos de otros usuarios;
- saltarse permisos de Product Surface;
- sustituir la app principal;
- convertirse en superficie admin;
- convertirse en superficie de desarrollo;
- usar datos reales sin política específica;
- activar sensores o permisos de salud sin ADR específica.

Las futuras apps de reloj deberán depender de contratos backend seguros,
permisos de Product Surface, sincronización controlada y políticas específicas
de privacidad, especialmente si se usan datos de salud, entrenamiento, sueño o
wellness.

La extensión wearable no puede acceder a Wizard/Development Surface ni a
Admin/Engine Surface.

Solo podría interactuar con especialistas producto autorizados si una ADR
futura lo aprueba. No puede exponer agentes internos de desarrollo, no puede
exponer agentes Admin/Engine y no puede usar `specialist_catalog` fuera de las
reglas de Product Surface.

Wearables no autorizan una implementación de `/conversations` en reloj.
Cualquier conversación, notificación o interacción conversacional desde reloj
requerirá ADR o paquete específico posterior.

## Relación con agentes internos, especialistas producto y agentes Admin/Engine

Agentes internos de desarrollo:

- viven en Wizard/Development Surface;
- son para construir, auditar, revisar, bloquear y gobernar el proyecto;
- no aparecen en Product Surface;
- no aparecen en `specialist_catalog` producto;
- no abren conversaciones con usuarios finales.

Especialistas producto:

- viven en Product Surface;
- pueden aparecer en `specialist_catalog` producto si están sanitizados,
  publicados y autorizados;
- pueden participar en `/conversations` producto mediante backend seguro.

Agentes Admin/Engine:

- viven en Admin/Engine Surface;
- ayudan al administrador con datos, métricas, usuarios, soporte, auditoría,
  calidad, riesgo y decisiones operativas;
- no son especialistas producto;
- no son agentes de desarrollo;
- no aparecen en la app cliente final.

Los tres grupos no se mezclan. Mover un agente de una familia a otra requiere
decisión documental, revisión de seguridad, permisos, datos y trazabilidad.

## Relación con /conversations

`/conversations` cambia de significado según superficie:

- Product Surface: conversaciones usuario final con especialistas producto
  autorizados.
- Wizard/Development Surface: flujos dev, pruebas, fixtures, validaciones
  internas y diagnósticos. No es producto.
- Admin/Engine Surface: revisión, soporte, auditoría, métricas,
  administración o análisis si se autoriza. No debe confundirse con una
  conversación cliente normal.

AG84 no registra `/conversations`, no crea rutas y no autoriza implementación.
Solo documenta que cualquier plan de `/conversations` debe indicar a qué
superficie pertenece.

Product `/conversations` no puede reutilizar dev-shell, `/chat/:id` heredado,
`/orchestrator/chat` heredado, fixtures, tokens sintéticos, agentes internos de
desarrollo ni agentes Admin/Engine.

## Relación con specialist_catalog

`specialist_catalog` producto pertenece a Product Surface.

Solo debe contener especialistas producto sanitizados.

La frontera documental del catálogo producto de especialistas conversables se
define en:

```text
docs/stasisly_definition/adr/ADR-010-product-specialists-catalog.md
```

ADR-010 no puebla catálogo ni autoriza implementación; concreta qué puede y no
puede entrar en `specialist_catalog` producto antes de `/conversations`.

Los guards y contratos que protegen esa frontera antes de schema, seeds o
implementación se documentan en:

```text
docs/stasisly_definition/adr/ADR-011-product-specialists-catalog-guards-contracts.md
```

ADR-011 no implementa catálogo; traduce la separación Product/Wizard/Admin a
reglas verificables para `specialist_catalog`.

La jerarquía normativa de agentes Product y Admin/Engine queda propuesta en:

```text
docs/stasisly_definition/adr/ADR-012-agent-hierarchy-product-admin-engine.md
```

ADR-012 no implementa agentes, catálogo ni rutas. Define que Product Surface y
Admin/Engine Surface deben organizar sus agentes mediante coordinador, jefes de
departamento/rama y especialistas, evitando listas planas y manteniendo la
separación entre superficies.

No debe contener:

- agentes internos del equipo de desarrollo;
- agentes Admin/Engine;
- roles admin/engine;
- comités técnicos;
- prompts internos;
- fixtures development;
- nombres de archivos internos;
- identificadores sensibles.

Wizard/Dev puede tener su propio registro interno o documentación de agentes,
pero no debe contaminar el catálogo producto.

Admin/Engine puede tener paneles de gestión de especialistas y agentes admin,
pero no convierte automáticamente roles admin en especialistas producto.

## Datos y permisos

Principios por superficie:

Product Surface:

- solo datos propios del usuario;
- sin acceso cruzado;
- sin herramientas internas;
- permisos mínimos;
- backend seguro;
- RLS y ownership obligatorios cuando aplique.

Wizard/Development Surface:

- datos sintéticos y development;
- acceso ampliado bajo control;
- no datos reales salvo política explícita posterior;
- trazabilidad de pruebas;
- separación frente a cliente final.

Admin/Engine Surface:

- acceso a datos permitidos por rol;
- auditoría obligatoria;
- mínimo privilegio;
- trazabilidad;
- logs de acciones;
- separación de permisos;
- datos agregados o minimizados por defecto cuando sea posible.

## Seguridad

Queda prohibido:

- `service_role` en cliente;
- Flutter directo a tablas para producto;
- mezclar fixtures con producto;
- usar datos reales en development sin política;
- exponer agentes internos al usuario final;
- exponer agentes Admin/Engine al usuario final;
- usar Admin/Engine como vía sin auditoría;
- usar Wizard/Dev como production;
- registrar rutas producto desde dev-shell;
- reutilizar `/chat/:id` heredado;
- reutilizar `/orchestrator/chat` heredado;
- fallback demo ante errores reales.

Las tres superficies deben aplicar:

- mínimo privilegio;
- autorización explícita;
- separación de responsabilidades;
- logs de auditoría;
- trazabilidad;
- rollback;
- revisión de seguridad;
- protección de datos sensibles.

## Alcance autorizado

AG84 autoriza solo documentación:

- crear esta ADR;
- actualizar referencias breves en documentación principal;
- registrar en el tracker la pausa del AG84 anterior y la creación de ADR-009;
- revisar coherencia con ADR-008.

## Alcance no autorizado

AG84 no autoriza:

- código;
- tests;
- cambios en `supabase/`;
- rutas;
- registro de `/conversations`;
- SQL;
- deploy;
- migraciones;
- cleanup adicional;
- datos reales;
- staging;
- production;
- push.

## Consecuencias

Consecuencias positivas:

- evita mezclar producto, desarrollo y administración;
- protege `specialist_catalog` producto;
- evita que agentes internos o Admin/Engine aparezcan como especialistas
  producto;
- clarifica que `/conversations` debe diseñarse por superficie;
- reduce riesgo de usar dev-shell como producto;
- prepara mejor la futura arquitectura de admin, métricas y Stasis Engine.

Costes:

- retrasa el commit o implementación directa del plan `/conversations`;
- exige decisiones posteriores por superficie;
- obliga a diseñar permisos y auditoría de Admin/Engine antes de uso real;
- aumenta el rigor documental antes de construir rutas visibles.

## Riesgos

Riesgos altos:

- mezclar Product Surface con Wizard/Dev;
- convertir Admin/Engine en superusuario informal;
- exponer agentes internos o Admin/Engine al usuario final;
- contaminar `specialist_catalog` producto;
- usar `/chat/:id` heredado como ruta segura.

Riesgos medios:

- duplicar lógica entre superficies;
- crear rutas parecidas con semántica ambigua;
- usar datos development como si fueran producto;
- convertir recomendaciones IA Admin/Engine en acciones sin revisión humana.

Riesgos bajos:

- sobre-documentar antes de implementar;
- necesitar renombrar futuras rutas internas si cambian las superficies.

## Relación con ADR anteriores

ADR-005 define estabilización, modo demo explícito y bloqueo de backend real sin
paquete controlado.

ADR-006 define identidad, autorización, RLS, ownership, entornos y criterios de
seguridad para backend real.

ADR-007 define catálogo sanitizado y frontera backend para especialistas.

ADR-008 define la futura ruta producto `/conversations` y separa producto de
dev-shell. ADR-009 no contradice ADR-008: la eleva a una separación más amplia
por superficies operativas.

## Revisión 2B-AG85

ADR-009 queda aprobada con ajustes menores documentales.

La revisión confirma:

- Product Surface queda protegida como app cliente final;
- Wizard/Development Surface queda separada como superficie de construcción,
  validación y auditoría;
- Admin/Engine Surface queda separada como superficie operativa con roles,
  permisos, trazabilidad y auditoría;
- las tres familias de agentes no se mezclan;
- `specialist_catalog` producto queda protegido frente a agentes internos de
  desarrollo y agentes Admin/Engine;
- `/conversations` debe planificarse por superficie;
- Admin/Engine no se convierte en superusuario informal;
- esta ADR no autoriza implementación, rutas, SQL, Supabase, datos reales,
  staging, production ni push.

## Estado de implementación

No implementado.

No existe autorización en esta ADR para registrar `/conversations`, modificar
rutas, tocar código, tocar Supabase, ejecutar SQL, crear datos, limpiar datos,
usar datos reales, activar staging, activar production, hacer deploy,
ejecutar migraciones ni hacer push.

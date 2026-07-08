# ADR-008 — Ruta producto /conversations

## Estado

Aprobada conceptualmente / Pendiente de implementacion.

Esta ADR prepara la decision normativa para una futura ruta producto
`/conversations`. No autoriza implementacion inmediata, registro de ruta,
conexion de producto, uso de datos reales, staging, production, cleanup ni
cambios en Supabase.

## Contexto

La fase 2B dev-only ha dejado un frente tecnico validado para sesiones y
mensajes con estas propiedades:

- backend remoto development E2E completado con datos sinteticos;
- Flutter dev-only read/write completado;
- UX dev-only remota validada;
- hardening dev-only completado;
- baseline 2B publicado en Git;
- producto cerrado;
- `/conversations` no registrado;
- fixture sintetico development retenido;
- staging y production no autorizados;
- datos reales no usados.

La ruta producto `/conversations` seria la primera entrada de usuario final
para conversaciones propias. Por tanto, no puede tratarse como simple traslado
de la dev-shell existente. Debe existir una frontera normativa clara antes de
implementar routing, UI productiva, auth real, datos reales o promocion a
staging.

## Decision

La ruta `/conversations` podra abrirse solo como ruta producto futura,
separada de la dev-shell, despues de cumplir criterios de autenticacion de
producto, politica de datos reales, staging, rollback, observabilidad,
ownership backend/RLS y decision explicita sobre retention o cleanup del
fixture sintetico development.

Esta ADR no registra `/conversations`, no conecta producto y no habilita datos
reales. La implementacion debe aprobarse en un paquete posterior.

## Alcance autorizado

Queda autorizado exclusivamente:

- documentar el contrato normativo de `/conversations`;
- definir los criterios minimos previos a implementacion;
- definir no-alcances y bloqueos;
- decidir que la dev-shell no es producto;
- mantener el fixture sintetico retenido durante la ADR;
- diferir cleanup, staging y producto a decisiones posteriores.

## Alcance explicitamente no autorizado

Esta ADR no autoriza:

- registrar `/conversations`;
- modificar rutas Flutter;
- conectar UI productiva;
- usar `/chat/:id` como `sessionId`;
- usar `/orchestrator/chat`;
- reactivar el chat heredado como ruta de producto;
- usar `SupabaseChatDataSource` heredado;
- usar `service_role` en cliente;
- acceder a tablas directamente desde Flutter para operaciones sensibles;
- depender de `SYNTHETIC_ACCESS_TOKEN`;
- usar fixture development como dato de producto;
- hacer cleanup del fixture;
- activar staging o production;
- usar datos reales;
- ejecutar SQL, migraciones, deploys o `secrets set`.

## Diferencia dev-shell vs producto

La dev-shell existe para validar comportamiento tecnico de forma visible,
controlada y reversible. Sus rutas y hosts dev-only pueden usar datos
sinteticos retenidos y controles especiales de development.

`/conversations` debe ser producto. Por tanto:

- no debe depender de rutas `/dev/chat/composed` ni
  `/dev/chat/session/:sessionId`;
- no debe mostrarse como demo ni caer a demo ante errores reales;
- no debe leer tokens sinteticos de development;
- no debe exponer controles internos de testing;
- no debe asumir que un fixture es contenido real de usuario;
- no debe quedar disponible en release hasta completar gates de producto.

## Autenticacion y autorizacion producto

La ruta producto requiere una sesion autenticada real y segura. Antes de
implementarla debe existir decision aprobada sobre:

- fuente de verdad de identidad;
- provider real de sesion;
- refresh y expiracion de token;
- estado `unauthenticated`, `expired`, `backendBlocked` y `misconfigured`;
- tratamiento visible de errores de auth;
- ausencia de fallback demo ante error real;
- no uso de `userMetadata` como autoridad;
- no envio de `userId`, `ownerUserId`, `role` o permisos desde UI.

La autorizacion efectiva debe validarse en backend/RLS. Flutter no decide
ownership ni privilegios.

## Politica de datos reales

`/conversations` no puede usar datos reales hasta que exista una politica
explicita que cubra:

- finalidad del dato;
- minimizacion;
- consentimiento o base de uso;
- borrado y retencion;
- auditoria;
- logs seguros;
- separacion de datos sinteticos y reales;
- prohibicion de datos de salud/wellness reales sin autorizacion adicional;
- criterios de QA para evitar mezclar fixture, demo y producto.

## Staging antes de production

Staging debe definirse antes de production. No se puede saltar de development a
production.

Antes de activar `/conversations` fuera de development debe existir:

- entorno staging separado;
- secrets staging separados;
- auth staging separada;
- datos staging no reales o expresamente autorizados;
- plan de promocion;
- checklist de rollback;
- evidencia de que production permanece intacto.

## Fixture sintetico development

Decision de esta ADR: retener el fixture durante la preparacion de la ADR y
decidir cleanup/retention en un paquete posterior antes de activar producto
real.

El fixture:

- pertenece solo a development;
- no es producto;
- no debe aparecer como dato real;
- no debe usarse en staging;
- no debe usarse en production;
- debe quedar claramente etiquetado como sintetico;
- debe tener plan de cleanup con conteos previos/posteriores si se elimina.

## Contrato frontend/backend

Contrato producto minimo esperado para `/conversations`:

- listar conversaciones propias;
- abrir detalle de conversacion por `sessionId` propio;
- enviar mensaje mediante backend seguro;
- archivar o restaurar solo si se autoriza explicitamente;
- mostrar errores auth/backend visibles;
- no fallback demo;
- no exponer IDs internos;
- no enviar `userId`, `ownerUserId`, `specialistId` interno ni `role` desde UI;
- usar `selectableSpecialistId` como contrato publico cuando una operacion de
  producto requiera seleccionar especialista;
- validar ownership en backend;
- mapear errores sin filtrar existencia de sesiones ajenas;
- tratar contadores y timestamps server-managed como server-managed.

## Routing Flutter

La futura ruta producto debe definirse por separado. Reglas:

- `/conversations` no queda registrada por esta ADR;
- la implementacion requiere paquete posterior;
- no usar `/chat/:id` como `sessionId`, porque `:id` es `agentId` heredado;
- no conectar `/orchestrator/chat`;
- no reutilizar chat heredado para enviar `role` desde Flutter;
- no conectar `SupabaseChatDataSource`;
- no abrir ruta en release sin guards, tests y aprobacion.

## Rutas heredadas bloqueadas

Permanecen bloqueadas para el flujo seguro:

- `/chat/:id` como entrada a mensajes propios;
- `/orchestrator/chat`;
- rutas dev-only como producto;
- cualquier ruta que acepte `agentId` o `id` ambiguo como `sessionId`;
- cualquier ruta que use chat heredado para crear/enviar mensajes reales.

## Seguridad y RLS

Antes de implementar `/conversations` debe auditarse:

- RLS y ownership real de `public.users`, `chat_sessions` y `messages`;
- grants cliente;
- ausencia de policies permisivas no revisadas;
- Edge Functions como frontera operativa;
- RPCs autorizadas y grants de RPC;
- ausencia de `service_role` en Flutter;
- ausencia de writes directos desde Flutter a tablas sensibles;
- logs sin tokens, contenido sensible o IDs internos innecesarios;
- errores opacos para sesiones ajenas.

## Observabilidad minima

La ruta producto necesita observabilidad minima antes de salir de development:

- errores de auth;
- errores backend;
- latencia de llamadas;
- fallos de ownership;
- fallos de contrato;
- conteo de operaciones sensibles sin registrar contenido sensible;
- correlacion tecnica sin exponer tokens ni IDs internos al cliente.

## Rollback

Rollback minimo esperado para implementacion futura:

- feature flag o gate para desactivar `/conversations`;
- revert de ruta Flutter;
- mantener dev-shell separada;
- no tocar datos reales como rollback primario;
- si hubo cambios backend, rollback con migraciones o scripts aprobados;
- si hubo deploy de funciones, plan de redeploy anterior;
- documentar postcondiciones.

## Criterios minimos antes de implementacion

Antes de implementar `/conversations` debe cumplirse:

1. ADR-008 aprobada.
2. Auth producto definida.
3. Staging definido antes de production.
4. Politica de datos reales definida.
5. Fixture retention/cleanup decidido.
6. Rutas heredadas bloqueadas por tests.
7. Tests de route guards producto definidos.
8. Rollback definido.
9. Observabilidad minima definida.
10. RLS/backend ownership auditado.
11. Sin dependencia de dev-only flags.
12. Sin dependencia de token sintetico.
13. Sin fallback demo.
14. Sin `SupabaseChatDataSource` heredado.
15. Sin `/chat/:id` como `sessionId`.
16. Sin `/orchestrator/chat`.
17. Sin `service_role` cliente.
18. Sin Flutter directo a tablas sensibles.

## Consecuencias

Consecuencias positivas:

- evita abrir producto con una ruta heredada o ambigua;
- protege la separacion entre dev-shell y producto;
- mantiene trazabilidad de decisiones antes de usar datos reales;
- reduce riesgo de mezclar fixture, demo, staging y production;
- preserva rollback.

Costes:

- retrasa la implementacion productiva de conversaciones;
- exige un paquete posterior de aprobacion e implementacion;
- obliga a decidir cleanup/retention y staging antes de producto real.

## Riesgos

Riesgos que esta ADR intenta bloquear:

- abrir `/conversations` sin auth producto;
- usar `SYNTHETIC_ACCESS_TOKEN` en producto;
- confundir fixture con dato real;
- usar `/chat/:id` como `sessionId`;
- reactivar `SupabaseChatDataSource`;
- exponer `service_role` o secretos en cliente;
- usar Flutter directo contra tablas sensibles;
- convertir errores reales en demo;
- abrir staging/production sin politica de datos;
- filtrar existencia de sesiones ajenas.

## Relacion con ADR anteriores

- ADR-005 mantiene estabilizacion, modo demo explicito y bloqueo de backend
  real/productivo hasta autorizacion posterior.
- ADR-006 define identidad, autorizacion, RLS, ownership, bloqueos de auth real
  y criterios previos para rutas de conversaciones.
- ADR-007 define catalogo sanitizado, frontera backend y prohibicion de exponer
  IDs internos, prompts o autoridad desde Flutter.

ADR-008 no sustituye ADR-006 ni ADR-007. Las especializa para la futura ruta
producto `/conversations`.

## Estado de implementacion

No implementado.

No existe autorizacion en esta ADR para registrar `/conversations`, modificar
rutas, conectar producto, limpiar fixture, tocar Supabase, usar datos reales,
activar staging, activar production ni desplegar cambios.

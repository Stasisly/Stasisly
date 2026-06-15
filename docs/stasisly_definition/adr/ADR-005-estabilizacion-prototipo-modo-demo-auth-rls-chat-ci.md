# ADR-005: Estabilización del prototipo, modo demo, auth, RLS, chat y CI

## Estado

Aceptado. Paquete 1 implementado, verificado y cerrado.

## Contexto

La auditoría técnica real confirmó que Stasisly es actualmente un prototipo
Flutter navegable con arquitectura parcial, pantallas y contratos iniciales,
pero no un MVP backend seguro ni preparado para datos reales.

Estado real verificado mediante lectura estática:

- autenticación anulada mediante un bypass temporal;
- inicialización de Supabase con URL y clave dummy;
- ausencia total de RLS y políticas en la migración disponible;
- acceso directo desde Flutter a tablas de chat;
- fallback mock silencioso cuando falla Supabase;
- usuario de chat fijo y respuestas LLM simuladas;
- Stasis, dashboard y catálogo de agentes hardcodeados;
- ausencia de Stasis Engine, memoria federada e investigaciones;
- CI sin ejecución de tests;
- un único test de plantilla no representativo;
- archivos `.g.dart` requeridos presentes localmente, ignorados por Git y sin
  generación explícita en CI;
- datos ficticios mostrados como si fueran datos personales reales.

La auditoría fue estática. No se ejecutaron builds, tests, migraciones ni
conexiones remotas. Antes de nuevas funcionalidades debe estabilizarse la base y
separarse inequívocamente demo de backend real y producción.

## Riesgos detectados

### Críticos

- Conectar Supabase real sin RLS permitiría exposición o modificación indebida
  de datos entre usuarios.
- El bypass de autenticación elimina garantías de identidad y autorización.
- El fallback silencioso convierte fallos reales en aparentes éxitos mock.
- Datos sensibles podrían tratarse sin autorización, auditoría ni pruebas.

### Altos

- Flutter escribe directamente en tablas sin una frontera backend controlada.
- El checkout limpio puede no ser reproducible por la política actual de
  `.g.dart`.
- CI no demuestra que el proyecto compile ni que sus flujos mínimos funcionen.
- La interfaz presenta métricas, tareas y respuestas ficticias sin indicar
  claramente que son demo.

## Decisión

### No conectar datos reales todavía

Stasisly permanecerá sin usuarios, chats, datos de salud, archivos o información
personal real hasta que exista autorización, RLS revisada, auditoría y pruebas
aprobadas.

No se ejecutará la migración actual contra un entorno con datos reales ni se
configurarán credenciales reales durante el Paquete 1.

### Separación obligatoria de modos

Se definirán tres modos explícitos:

1. **Modo demo local**
   - Solo datos ficticios identificados como demo.
   - No depende de Supabase real.
   - No simula que operaciones remotas han tenido éxito.

2. **Modo backend real**
   - Solo para entorno controlado y no productivo.
   - Requiere configuración válida, autenticación restaurada, contratos
     definidos, RLS revisada y pruebas.
   - Los errores remotos se muestran como errores reales.

3. **Modo producción**
   - Queda bloqueado hasta completar revisiones de seguridad, privacidad,
     AppSec, QA, observabilidad, release y stores.
   - Requiere aprobación explícita independiente.

Cada ejecución debe poder identificar de forma técnica y visible el modo activo.
El modo demo nunca debe presentarse como backend real o producción.

### Eliminación de fallbacks silenciosos

Los errores de Supabase, autenticación, autorización, red o contratos no podrán
convertirse silenciosamente en éxito mock.

El modo demo podrá usar repositorios mock explícitos. El modo backend real deberá
propagar fallos tipados, observables y comprobables.

### Restauración controlada de autenticación

La autenticación no se restaurará mediante cambios aislados o improvisados. Se
preparará para un paquete posterior controlado que incluya identidad,
autorización, navegación, sesión, errores, pruebas y revisión de seguridad.

El Paquete 1 solo preparará contratos, criterios y pruebas requeridas. No
conectará usuarios reales ni activará autenticación real.

### Supabase y RLS

No se utilizará Supabase real con datos de usuario hasta que:

- todas las tablas sensibles tengan RLS habilitada;
- existan políticas explícitas y revisadas;
- identidad y autorización estén definidas;
- los contratos usados por Flutter estén documentados;
- existan pruebas de aislamiento entre usuarios;
- exista auditoría y rollback;
- Seguridad, Privacidad, AppSec, Backend/Supabase y QA aprueben el alcance.

El Paquete 1 preparará la estrategia futura de RLS, pero no modificará esquema,
migraciones ni políticas.

### Datos de salud y chats

No se utilizarán datos reales de salud, wellness, chats, memoria, investigaciones
o archivos sin autorización, RLS, auditoría, minimización, retención, borrado y
pruebas aprobadas.

Todos los datos visibles durante el Paquete 1 deberán ser ficticios y estar
etiquetados como demo.

### Checkout limpio reproducible

El repositorio deberá disponer de una política única y documentada para código
generado:

- versionar los `.g.dart`; o
- generarlos de forma determinista antes de analizar, probar y compilar.

La decisión concreta se tomará durante la preparación del Paquete 1. Un checkout
limpio deberá poder instalar dependencias, generar lo necesario, analizar y
ejecutar tests mínimos sin depender de archivos locales no documentados.

### CI y tests antes de nuevas features

Antes de desarrollar nuevas funcionalidades, CI deberá comprobar como mínimo:

- generación de código cuando corresponda;
- análisis estático;
- tests mínimos de arranque;
- tests de rutas;
- tests de repositorios demo y manejo de errores.

No se consideran aprobadas nuevas features mientras esta base no sea
reproducible y verificable.

## Paquete 1 — Estabilización técnica y modo demo explícito

### Objetivo

Convertir el prototipo actual en una base demo inequívoca, reproducible y
verificable, sin conectarlo a datos reales ni ampliar funcionalidades.

### Alcance autorizado propuesto

1. Aclarar visual y técnicamente cuándo la aplicación está en modo demo.
2. Separar contratos y selección de repositorios para demo local y futuro
   backend real.
3. Impedir que errores de Supabase se presenten como éxito real.
4. Definir política de configuración de entorno y validación por modo.
5. Definir y aplicar una política reproducible de generación de `.g.dart`.
6. Definir CI mínimo para generación, análisis y tests permitidos.
7. Crear tests mínimos de arranque, rutas y repositorios.
8. Preparar criterios y contratos para restaurar autenticación en un paquete
   posterior.
9. Preparar estrategia futura de RLS, sin crear ni modificar políticas.
10. Bloquear técnicamente y documentalmente el uso de datos reales hasta que
    existan RLS y autorización aprobadas.

### Archivos potencialmente afectados

La lista exacta deberá definirse y aprobarse antes de implementar. Podría incluir
archivos acotados de:

- configuración de modo de ejecución;
- inicialización de aplicación;
- selección de repositorios;
- manejo de errores;
- rutas;
- tests;
- CI;
- documentación.

No se autoriza ningún cambio por la mera aceptación conceptual de este ADR.

### Criterios de aceptación

- La aplicación identifica claramente el modo demo.
- Ningún fallo remoto se convierte silenciosamente en éxito mock.
- El modo demo funciona sin credenciales ni backend real.
- El modo backend real queda bloqueado si falta configuración válida.
- Ningún dato ficticio se presenta como dato real del usuario.
- Un checkout limpio puede generar, analizar y ejecutar los tests mínimos
  definidos.
- CI ejecuta generación, análisis y tests mínimos.
- Existen criterios documentados para restaurar auth y diseñar RLS después.
- No se han conectado datos o usuarios reales.
- No se han modificado esquema, migraciones ni RLS.

### Verificación prevista

- revisión estática de modos y contratos;
- análisis estático;
- tests de arranque por modo;
- tests de rutas;
- tests de repositorios demo;
- tests de propagación de errores;
- ejecución de CI en checkout limpio;
- revisión cruzada de Arquitectura, Seguridad, AppSec y QA.

### Rollback

El paquete deberá dividirse en cambios pequeños y reversibles. Cada cambio deberá
conservar una ruta de retorno al prototipo demo anterior sin tocar datos reales,
migraciones ni infraestructura remota.

## Fuera de alcance

Queda explícitamente fuera del Paquete 1:

- memoria federada;
- investigaciones rápidas, profundas o estratégicas;
- pagos, membresías, trials, IAP o Stripe;
- Stasis Engine;
- MCP;
- migración de Mental a Wellness;
- cambios de esquema, tablas, migraciones o RLS;
- nuevas features;
- procesamiento real de archivos, PDFs o imágenes;
- conexión a usuarios, chats o datos reales;
- restauración efectiva de autenticación;
- despliegues, publicación o configuración de stores;
- proveedores LLM reales;
- Panel Admin;
- refactors amplios.

## Consecuencias positivas

- Reduce el riesgo de mezclar demo con producto real.
- Evita exposición prematura de datos.
- Hace visibles los errores reales.
- Prepara una base reproducible para cambios posteriores.
- Permite restaurar auth y diseñar RLS con contratos y pruebas.
- Evita construir nuevas features sobre una base no verificable.

## Consecuencias negativas o costes

- Retrasa temporalmente nuevas funcionalidades.
- Requiere trabajo de estabilización sin valor visual inmediato.
- Mantiene auth, RLS y backend real pendientes durante el Paquete 1.
- Exige decidir y mantener una política de generación y CI.

## Alternativas consideradas

### Continuar añadiendo features sobre el prototipo

Rechazada porque ampliaría deuda, ambigüedad y riesgo de seguridad.

### Conectar Supabase real y corregir después

Rechazada por ausencia de RLS, autorización, auditoría y pruebas.

### Mantener fallbacks silenciosos para mejorar la demo

Rechazada porque oculta fallos y presenta comportamiento ficticio como éxito
real.

### Restaurar auth y RLS dentro del mismo Paquete 1

Rechazada para mantener el primer cambio pequeño. El Paquete 1 prepara los
contratos y bloqueos; la implementación real requiere un paquete posterior
aprobado.

## Agentes y comités revisores

### Responsables principales

- Director de Proyecto.
- Product Owner.
- Revisor de Coherencia del Producto.
- Arquitecto Principal.
- Arquitecto Flutter.
- Arquitecto Backend.
- Backend/Supabase Developer.
- QA Engineer.
- DevOps / Infraestructura / Release Engineering.

### Revisión obligatoria

- Especialista en Seguridad y Privacidad.
- Especialista AppSec / Ciberseguridad.
- Especialista en Datos y Memoria.
- Documentador Técnico.
- Comité de Arquitectura Técnica.
- Comité de Implementación.
- Comité de Dirección, Gobierno y Coherencia.

## Condiciones para aprobar implementación del Paquete 1

- Alcance exacto y archivos permitidos aprobados.
- Archivos prohibidos declarados.
- Decisión sobre política de `.g.dart` aprobada.
- Diseño de modos demo/backend/producción aprobado.
- Contrato de errores y eliminación de fallbacks silenciosos aprobado.
- CI mínimo y matriz de tests definidos.
- Criterios de bloqueo de datos reales aprobados.
- Plan de rollback definido.
- Confirmación de que no se tocarán migraciones, RLS, datos reales ni auth real.
- Aprobación explícita del cliente.

## Decisiones pendientes

- Alcance del paquete posterior para restaurar autenticación.
- Diseño y ADR posterior de identidad, autorización y RLS.
- Decisión futura sobre migración Mental a Wellness.

## Resultado de implementación del Paquete 1

Fecha de implementación y verificación: 2026-06-11.

### Decisiones concretadas

- El modo seguro por defecto es `demo`; no requiere credenciales ni inicializa
  Supabase.
- La aplicación muestra globalmente `MODO DEMO · DATOS FICTICIOS` en toda
  ejecución no productiva de demo.
- Los modos `backendReal` y `production` existen como configuración explícita,
  pero quedan bloqueados técnicamente por ADR-005 aunque se proporcionen
  credenciales.
- El chat demo usa un repositorio local explícito. El repositorio backend
  propaga fallos y no genera respuestas mock ni éxitos silenciosos.
- Los `.g.dart` continúan ignorados por Git y se generan determinísticamente
  mediante `build_runner` antes de analizar, probar o construir en CI.
- Se retiraron del `pubspec.yaml` referencias a carpetas de assets vacías y no
  versionadas que impedían garantizar un checkout limpio reproducible.
- CI ejecuta instalación de dependencias, generación, análisis estático y
  tests. Los workflows de build generan código antes de construir.

### Evidencia verificada

- `dart run build_runner build --delete-conflicting-outputs`: completado.
- `flutter analyze --no-fatal-infos`: completado sin errores ni warnings; quedan
  47 avisos informativos de deuda total.
- `flutter test`: 7 tests superados.
- Tests añadidos para configuración y bloqueo de modos, repositorio demo,
  propagación de errores backend, arranque visible en demo y ruta de Salud.
- No se ejecutaron builds, migraciones ni conexiones a servicios reales.
- No se modificaron auth real, RLS, esquemas, datos, plataformas ni stores.

### Riesgos residuales y cierre pendiente

- El análisis mantiene 47 avisos informativos, principalmente APIs Riverpod
  generadas deprecadas y reglas de estilo; no bloquean este paquete, pero deben
  planificarse sin mezclarlos con nuevas features.
- `build_runner` avisa de una diferencia entre la versión de lenguaje del SDK y
  la soportada por `analyzer`; actualizar dependencias queda fuera de alcance.
- La ejecución del workflow en infraestructura remota queda pendiente de que
  GitHub Actions procese estos cambios.
- Backend real, producción, autenticación y RLS siguen bloqueados hasta un
  paquete posterior aprobado y revisado por Seguridad, AppSec, Backend y QA.

## Cierre aprobado

El cliente aprobó el cierre del Paquete 1 el 2026-06-11.

La aprobación confirma la estabilización del modo demo, pero no autoriza
backend real, producción, autenticación real, RLS, migraciones ni datos reales.
La preparación de identidad, autorización y RLS continúa documentalmente en
ADR-006.

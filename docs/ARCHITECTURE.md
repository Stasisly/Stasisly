# Arquitectura de Stasisly

Stasisly sigue una **Arquitectura Hexagonal** (Ports and Adapters) combinada con **Clean Architecture** y el patrón **MVVM** en la capa de presentación. 
El manejo de dependencias y el estado global reactivo se implementan con **Riverpod**.

## Principios Fundamentales

1. **Separación de Responsabilidades (SoC):** Cada capa tiene un propósito único.
2. **Regla de Dependencia:** Las dependencias siempre apuntan hacia adentro, hacia la capa de Dominio.
3. **Inyección de Dependencias (DI):** Todos los componentes (ViewModels, Casos de uso, Repositorios, DataSources) se inyectan a través de providers de Riverpod.
4. **Programación Funcional para Errores:** Uso de `Either<Failure, T>` de la librería `dartz` para un manejo de errores explícito y sin excepciones en la UI.

## Capas

### 1. Capa de Dominio (Domain)
El corazón de la aplicación. No depende de **nada** externo (ni de Flutter, ni de Supabase, ni de JSON).
- **Entities:** Modelos de negocio puros (ej. `UserEntity`, `ChatSessionEntity`).
- **Repositories (Ports):** Interfaces (clases abstractas) que definen cómo se obtienen o guardan los datos.
- **Use Cases:** La lógica de negocio orquestada. Cada caso de uso tiene un único propósito público (método `call`). Retornan `Future<Either<Failure, T>>`.

### 2. Capa de Datos (Data)
Implementa los puertos (interfaces) de la capa de Dominio.
- **Models:** Clases de datos que extienden de las Entities o las implementan, agregando serialización (JSON/Freezed).
- **DataSources:** Los adaptadores que hablan directamente con el mundo exterior (Supabase, APIs, SharedPreferences, File System).
  - Lanzan `AppException` (ej. `ServerException`, `AuthException`).
- **Repositories (Adapters):** Implementan los repositorios de dominio. Su trabajo principal es coordinar los DataSources, atrapar las `AppException` y convertirlas en `Failure` para devolver un `Either`.

### 3. Capa de Presentación (Presentation) - MVVM
La interfaz de usuario construida con Flutter.
- **ViewModels (Riverpod StateNotifiers / AsyncNotifiers):** Manejan el estado de la UI. Dependen de los Casos de Uso. No conocen de Widgets.
- **Pages/Widgets:** Componentes puramente visuales (UI declarativa). Escuchan a los ViewModels a través de `ref.watch()`.
- **Navegación:** Manejada por `go_router` de forma declarativa.

### 4. Capa Core (Shared)
Elementos compartidos transversalmente:
- **Design System:** `app_theme.dart`, `app_colors.dart`, `app_typography.dart`, `app_spacing.dart`.
- **Configuración:** `env.dart` (variables de entorno), `app_config.dart`.
- **Error Handling:** Definiciones de `Failure` y `AppException`.

## Flujo de Datos

1. La **UI (Page)** llama a un método en el **ViewModel**.
2. El **ViewModel** llama a un **Use Case**.
3. El **Use Case** llama a un **Repository (Interface)** en Domain.
4. El **Repository Implementation** en Data llama a uno o más **DataSources**.
5. El **DataSource** realiza la petición (ej. Supabase) y devuelve un **Model**.
6. El **Repository Implementation** mapea el Model a **Entity** (si es necesario) y lo envuelve en un `Right` de `Either` (o un `Left(Failure)` si el DataSource lanzó una excepción).
7. El **Use Case** devuelve el `Either` al **ViewModel**.
8. El **ViewModel** actualiza su estado (ej. de `Loading` a `Data`).
9. La **UI** se reconstruye automáticamente al escuchar el cambio de estado mediante Riverpod.

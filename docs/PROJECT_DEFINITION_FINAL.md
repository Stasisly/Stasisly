# PROYECTO STASISLY - DEFINICIÓN FINAL

**Versión:** 2.0  
**Fecha:** Abril 2025 (Ref. Mayo 2026)  
**Equipo:** 34 agentes IA (31 técnicos + 3 Customer Success) – todos con 20+ años de experiencia en empresas e instituciones de élite mundial.  
**Entorno de desarrollo:** Google Antigravity (VSCode + MCP)

---

## Índice

1. Resumen ejecutivo  
2. Visión y alcance  
3. Requisitos funcionales detallados  
4. Requisitos no funcionales  
5. Wireframes y flujos de usuario  
6. Modelo de datos definitivo (Supabase + SQL)  
7. Arquitectura de software (hexagonal + clean + MVVM + Riverpod)  
8. Infraestructura (Docker, Kubernetes, procesamiento de archivos)  
9. Metodología de trabajo y session tracker  
10. Jerarquía de agentes IA (Orquestador, Jefes de Rama, Jefes de Subcategoría, Especialistas)  
11. Catálogo de especialistas y generación automática de prompts  
12. Customer Success y QBR trimestral  
13. Plan de desarrollo (sprints)  
14. Estrategia de pruebas (100% cobertura, golden tests, contrato)  
15. Accesibilidad e internacionalización  
16. Observabilidad y monitoreo  
17. Gestión de membresías y pagos  
18. MCP (Model Context Protocol)  
19. Anexos (diagramas, convenciones, ejemplos)

---

## 1. Resumen ejecutivo

**Stasisly** es una aplicación Flutter multiplataforma (Android, iOS, Web) que ofrece un catálogo jerarquizado de agentes IA especializados en **salud, nutrición, entrenamiento físico y entrenamiento mental**, más un **agente orquestador central** llamado *Stasis*. La app se financia mediante **suscripción pura** (mensual, trimestral, anual) con 7 días de prueba. Incluye un **panel de administración** para gestionar usuarios y membresías. Los usuarios pueden subir PDFs de analíticas médicas y fotos; el backend procesa y extrae los datos, elimina los originales y guarda la información cifrada.

**Arquitectura de agentes** (tres niveles):  
- **Orquestador (Stasis)**: se comunica solo con 4 Jefes de Rama (internos).  
- **Jefes de Rama**: Salud, Nutrición, Entrenamiento Físico, Entrenamiento Mental.  
- **Jefes de Subcategoría**: existen si una subcategoría tiene ≥5 especialistas; son **visibles como Consultores Senior** y pueden leer/escribir (con permiso) y desactivar especialistas (con aprobación del usuario).  
- **Especialistas**: entre 30 y 50 por rama (total 120-200), con prompts generados automáticamente mediante IA. (Se incluye **Descanso** en Entrenamiento Mental).

El desarrollo se realiza con **arquitectura hexagonal + Clean Architecture + MVVM explícito + Riverpod**, backend en **Supabase**, procesamiento de archivos en **Docker + Kubernetes**, CI/CD con **GitHub Actions** (manual durante definición), tests obligatorios con 100% de cobertura y accesibilidad WCAG 2.1 AA.

Adicionalmente, un **equipo de Customer Success** (3 agentes) realizará **QBR trimestrales** para monitorizar retención, NPS, uso y proponer mejoras al producto.

---

*(El resto del documento detalla los requerimientos especificados en los prompts iniciales. Ver `supabase/migrations/00001_initial_schema.sql` para el esquema completo y `docs/ARCHITECTURE.md` para la arquitectura).*

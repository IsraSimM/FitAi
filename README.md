# 🏋️‍♂️ FitAi — Fitness Intelligence App

> **FitAi** es una aplicación móvil Android desarrollada en **Flutter**, diseñada para mejorar el rendimiento deportivo mediante el análisis inteligente de la ejecución de ejercicios, la gestión de datos fisiológicos, y la creación de rutinas personalizadas basadas en IA y visión computacional.

---

## 📖 Descripción General

FitAi combina **visión computacional (CV)**, **machine learning (ML)** y **análisis de datos** para ofrecer una experiencia fitness integral, conectando a usuarios, entrenadores y gimnasios en un mismo ecosistema.

La aplicación identifica **patrones de ejecución de ejercicios**, analiza la técnica con la cámara del dispositivo o mediante archivos de video, y genera recomendaciones automáticas para mejorar el rendimiento, prevenir lesiones y optimizar entrenamientos.

Además, integra **dispositivos wearables** (relojes, pulseras, apps de salud) para capturar métricas fisiológicas en tiempo real, sincroniza rutinas con el calendario del usuario y permite la participación en **foros sociales** donde los gimnasios pueden crear comunidades y ofrecer servicios “Pro” a sus clientes mediante un sistema de **suscripción por organización**.

---

## 🧠 Objetivos Principales

- Analizar la **técnica de ejercicios** mediante visión computacional y ofrecer feedback inmediato.
- Registrar y optimizar los **PR (Personal Records)** y pesos recomendados.
- Generar **rutinas automáticas** personalizadas según el perfil del usuario (edad, peso, objetivos, historial).
- Integrar datos provenientes de **dispositivos externos** (smartwatches, pulseras, apps de salud).
- Permitir interacción social mediante **foros y comunidades** fitness.
- Implementar un **modelo de negocio SaaS B2B2C** donde los gimnasios pueden ofrecer FitAi Pro a sus clientes.

---

## 💡 Funcionalidades Principales

| Módulo                          | Descripción resumida                                         |
| ------------------------------- | ------------------------------------------------------------ |
| **Inicio de sesión y registro** | Autenticación por correo, teléfono, Google o Facebook, con 2FA, CAPTCHA y validación por correo/SMS. |
| **Dashboard**                   | Visualización de métricas, rutinas y recomendaciones en una interfaz limpia y sin scroll excesivo. |
| **Rutinas**                     | Gestión diaria/semanal de ejercicios, con marcadores de progreso, filtros y sincronización opcional con calendario. |
| **Técnicas (CV)**               | Análisis de postura y ritmo con IA usando la cámara o videos pregrabados. Tutoriales interactivos. |
| **Datos (perfil)**              | Registro de datos personales, objetivos, restricciones, y métricas fisiológicas. Evolución con gráficas. |
| **Ecosistemas**                 | Integración con wearables y APIs externas (Google Fit, Fitbit, etc.) para importar pasos, calorías y frecuencia cardíaca. |
| **Estadísticas & ML**           | Progreso, rachas, logros, predicciones de desempeño y gamificación. |
| **Social / Foros**              | Espacio comunitario entre usuarios y gimnasios, con foros, grupos y mensajes. |
| **Notificaciones**              | Alertas personalizables (entrenos, progreso, mensajes, novedades). |
| **Configuraciones**             | Preferencias personales: idioma, tema, notificaciones, accesibilidad, privacidad. |

---

## 🎨 Diseño y Experiencia de Usuario (UI/UX)

- Basado en **Material Design 3** (Google).
- **Interfaz adaptativa** (mobile-first, compatible con tabletas).
- **Modo claro/oscuro** con persistencia.
- Accesibilidad AA (contraste, navegación por teclado, screen readers).
- Animaciones suaves y navegación intuitiva.
- **Barra de menú global persistente**, configurable y accesible desde todas las vistas.

---

## 🧩 Arquitectura del Proyecto

**Patrón:** Modular por *features* + atomic design (components).

lib/
app/ → núcleo de app, router, shell
components/ → UI reutilizable (NavBar, Cards, Widgets)
config/ → configuración global y defaults
features/ → módulos funcionales (dashboard, routines, etc.)
i18n/ → traducciones es/en
store/ → estado global con Riverpod
theme/ → colores, tokens, tipografía
utils/ → funciones auxiliares (responsive, helpers)
main.dart → punto de entrada
assets/i18n/ → es.json, en.json


**Stack técnico:**

- Flutter (stable)
- Riverpod 3 (Notifier API)
- Easy Localization
- Shared Preferences
- Go Router
- Material 3
- Docker (para CI/CD)

---

## 🌐 Internacionalización (i18n)

- Traducciones dinámicas en tiempo real (`es` / `en`).
- Persistencia de idioma seleccionada en `SharedPreferences`.
- Diccionarios JSON simples en `assets/i18n/`.

---

## 🎨 Temas y Tokens

| Variable            | Descripción          | Ejemplo          |
| ------------------- | -------------------- | ---------------- |
| `AppTokens.seed`    | Color base de la app | Azul (`#3A7BD5`) |
| `AppTokens.radius`  | Curvatura estándar   | `16.0`           |
| `AppTokens.spacing` | Espaciado base       | `12.0`           |

---

## 🧠 Estado Global

- `AppConfig` define idioma, modo de tema y visibilidad del menú.
- `SettingsController` (Notifier) maneja persistencia local y mutaciones.
- `menuProvider` expone el estado del menú global.

Ejemplo de uso:

```dart
final cfg = ref.watch(settingsProvider);
ref.read(settingsProvider.notifier).toggleDark(true);
```

Mini pero PRO: — Flutter Dashboard + Menú Persistente + i18n + Docker + CI + IA + FireBase + QA + Docs + KanBan + TLT + Tlahuitos + NSQK + Mate + Colors + Algorithms + o_0?

## Especificación integral del producto y plataforma móvil (Flutter + Firebase)

Esta documentación define por completo el alcance funcional, técnico y operativo de la aplicación móvil **FreeT**, destinada a acompañar a usuarios en rutinas de bienestar mediante generación inteligente de ejercicios, seguimiento diario y evaluación asistida con visión por computador. Incluye requisitos exhaustivos, arquitectura modular, lineamientos de diseño, estrategia de datos, seguridad, pruebas, automatización y gobernanza operativa para garantizar una solución escalable, mantenible y con estética de alto nivel.

---

## Tabla de contenido
1. [Visión y objetivos estratégicos](#visión-y-objetivos-estratégicos)
2. [Personas y casos de uso](#personas-y-casos-de-uso)
3. [Alcance funcional detallado](#alcance-funcional-detallado)
4. [Requisitos no funcionales](#requisitos-no-funcionales)
5. [Guía de instalación y configuración](#guía-de-instalación-y-configuración)
6. [Arquitectura de la solución](#arquitectura-de-la-solución)
7. [Estructura de carpetas y módulos](#estructura-de-carpetas-y-módulos)
8. [Determinación de features](#determinación-de-features)
9. [Diseño de experiencia y UI](#diseño-de-experiencia-y-ui)
10. [Modelado de datos y sincronización](#modelado-de-datos-y-sincronización)
11. [Integraciones externas y dispositivos](#integraciones-externas-y-dispositivos)
12. [Seguridad, privacidad y cumplimiento](#seguridad-privacidad-y-cumplimiento)
13. [Rendimiento y optimización](#rendimiento-y-optimización)
14. [Machine Learning y visión por computador](#machine-learning-y-visión-por-computador)
15. [Telemetría, analítica y personalización](#telemetría-analítica-y-personalización)
16. [Estrategia de pruebas E2E](#estrategia-de-pruebas-e2e)
17. [Automatización, CI/CD y DevOps](#automatización-cicd-y-devops)
18. [Lineamientos de código y calidad](#lineamientos-de-código-y-calidad)
19. [Plan de liberación y soporte operativo](#plan-de-liberación-y-soporte-operativo)
20. [Gestión de riesgos y mitigaciones](#gestión-de-riesgos-y-mitigaciones)
21. [Anexos y recursos complementarios](#anexos-y-recursos-complementarios)

---

## Visión y objetivos estratégicos
- **Propósito**: Impulsar hábitos saludables con seguimiento preciso, rutinas personalizadas y soporte comunitario en una experiencia móvil premium.
- **Metas cuantificables**:
  - Alcanzar >70% de retención mensual gracias a rutinas automatizadas y notificaciones inteligentes.
  - Reducir 40% los abandonos de planes gracias al feedback de postura y seguimiento diario.
  - Soportar >100k usuarios activos con latencia <150 ms en operaciones críticas (registro de rutina, notificaciones).
- **KPIs clave**: rachas activas, adherencia a rutinas, calidad de ejecución detectada por ML, interacción social, conversiones a planes premium.

## Personas y casos de uso
### Personas principales
1. **Atleta autodidacta**: busca rutinas guiadas y seguimiento de progreso con personalización profunda.
2. **Entrenador/coach**: gestiona planes de varios atletas, analiza métricas y envía recomendaciones.
3. **Usuario en rehabilitación**: necesita ejercicios adaptados, recordatorios y monitoreo de postura seguro.
4. **Administrador de comunidad**: modera rankings, gestiona contenido social y verifica reportes.

### Casos de uso críticos
- Registro, autenticación social y configuración inicial (idioma, tema, objetivos, dispositivos conectados).
- Consulta de dashboard con métricas del día, progreso semanal y tips personalizados.
- Generación de rutina automática (IA) con ajustes por objetivos y disponibilidad.
- Edición manual de rutina, programación de autogeneración y compartir/exportar.
- Registro de asistencia y métricas (peso levantado, sets, repeticiones, feedback).
- Evaluación con cámara con overlays, detección de articulaciones y recomendaciones en tiempo real.
- Consulta y participación en rankings, rachas y métricas sociales.
- Gestión de dispositivos externos (pulseras, sensores, HealthKit/Google Fit).
- Configuración de preferencias (tema, idioma, notificaciones, privacidad).
- Soporte, FAQ, reportes de incidentes y cierre de sesión seguro.

## Alcance funcional detallado
### Top Bar global
- Muestra nombre, avatar (con placeholder y fallback), estado de conexión y menú contextual.
- Botón de notificaciones: contador dinámico, filtros (todos, logros, recordatorios), soporte offline.
- Botón de configuración: modal de tres pestañas (Tema, Idioma, Notificaciones) con guardado inmediato y `undo`.

### Bottom Navigation Bar
1. **Dashboard**
   - Tarjetas de resumen (progreso diario, racha, calorías). Widgets reutilizables y accesibles.
   - Registro de asistencia con CTA prominente, animaciones suaves y confirmación háptica.
   - Rutina diaria: lista de ejercicios con posibilidad de editar peso/set en línea, ver peso recomendado vs actual.
   - Estadísticas y metas: gráficos comparativos, tendencias, objetivos ajustables con `Remote Config`.
   - Tips personalizados provenientes de IA, categorizados (nutrición, descanso, técnica).
2. **Routines**
   - Biblioteca de rutinas guardadas con filtros, búsqueda y etiquetado personalizado.
   - Generación IA por periodos (semanal, mensual, personalizado) con historial y rollback.
   - Editor drag & drop, clonación, versionado (guardar como plantilla) y compartir (PDF, CSV, deep link).
   - Configuración de autogeneración con recordatorios (calendar sync, push).
   - Ajustes de enfoque con presets (Completo, Pierna, Brazo, Cardio) y plantillas del usuario.
3. **Evaluation**
   - Interfaz de cámara con overlays y guías vocales. Estados de captura: calibración, grabación, feedback.
   - Detección de articulaciones (pose detection) on-device y fallback en la nube.
   - Registro de métricas post sesión (precisión, repeticiones válidas, recomendaciones priorizadas).
4. **Social**
   - Rankings dinámicos por rachas, peso, XP, métricas personalizadas. Filtros por amigos/global.
   - Perfil social con insignias, logros, actividades compartibles.
   - Interacción social (reacciones, comentarios, reportes). Moderación asistida con reglas y ML anti-spam.
5. **More**
   - Menú expandido con acceso a Dashboard, Notificaciones, Routines, Evaluation, Social, Environment, Profile, Settings, FAQ, Log Out.
   - **Environment**: vinculación/desvinculación de wearables, estado de sincronización, calibraciones.
   - **Profile**: CRUD datos personales, historial médico, objetivos; exportación de datos.
   - **Settings**: idioma, tema, notificaciones por canal (push, email, in-app), recordatorios y privacidad.
   - **FAQ & Support**: base de conocimiento, chat soporte, envío de tickets, seguimiento de estado.
   - **Log Out**: cierre con confirmación y limpieza segura de datos locales.

### Flujos secundarios
- Onboarding progresivo: selección de idioma/tema, objetivos, conexión de dispositivos, tutorial interactivo.
- Recuperación de contraseña, verificación MFA, gestión de sesiones activas.
- Gestión de planes premium, pasarela de pago (extensible con Stripe) y facturación.

## Requisitos no funcionales
- **Disponibilidad** ≥ 99.5% en servicios críticos.
- **Escalabilidad horizontal**: Firestore + Cloud Functions con autoescalado.
- **Resiliencia**: reintentos exponenciales, circuit breakers en integraciones externas.
- **Privacidad y cumplimiento**: GDPR, CCPA, ISO 27001 alineado.
- **Accesibilidad**: WCAG 2.1 AA, soporte screen readers y tamaños de fuente dinámicos.
- **Internacionalización**: soporte pleno para cadenas, formatos, unidades métricas/imperiales.

## Guía de instalación y configuración
### Prerrequisitos del entorno
- **Flutter SDK** ≥ 3.16.0 y Dart ≥ 3.1.0 instalados con el canal `stable`.<br>Validar con `flutter doctor` que no existan issues pendientes.
- **Java 17** (para builds Android) y **Xcode 15** con Command Line Tools (para iOS/macOS).
- **Android Studio** o **VS Code** con extensiones Flutter/Dart para ejecutar emuladores.
- **Firebase CLI** (`npm install -g firebase-tools`) y **FlutterFire CLI** (`dart pub global activate flutterfire_cli`).
- Acceso a cuentas de **Apple Developer** y **Google Play Console** para la configuración de firmas y despliegues.

### Configuración inicial del proyecto
1. Clonar el repositorio y acceder al directorio raíz:
   ```bash
   git clone https://github.com/<org>/FreeT.git
   cd FreeT
   ```
2. Generar las plataformas nativas (solo la primera vez o tras limpiar la carpeta):
   ```bash
   flutter create --platforms=android,ios,web,macos,windows,linux .
   ```
3. Instalar dependencias de Dart/Flutter y generar archivos derivados:
   ```bash
   flutter pub get
   ```
4. Ajustar carpetas inexistentes:
   ```
   assets/
   ├── animations/
   ├── icons/
   ├── images/
   ```
4. Ajustar versionado uniforme en gradle:
   ```
   fitai\android\app\build.gradle.kts
   ```
   Debe tener:
   ```
   defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.freet"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // Raised to satisfy tflite_flutter's minSdk requirement.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
   ```
4. Verificar la ejecución:
   ```bash
   flutter run
   ```

### Configuración de Firebase por entorno
1. Crear el proyecto en Firebase Console e inicializar aplicaciones iOS, Android y (opcional) Web.
2. Ejecutar `flutterfire configure` seleccionando los proyectos para cada entorno (`dev`, `staging`, `prod`). El comando generará `lib/firebase_options.dart` con los identificadores correspondientes.
3. Descargar `google-services.json` (Android) y `GoogleService-Info.plist` (iOS), ubicándolos en (crear carpetas si aún no existen):
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
4. Habilitar los servicios requeridos:
   - Authentication (correo, Google, Apple, teléfono).
   - Cloud Firestore y Rules en modo restringido (usar reglas provistas en `/infra/firebase/firestore.rules`).
   - Cloud Storage (para multimedia), Remote Config, Analytics, Messaging y Functions.
5. Configurar Firestore y Functions emulators para desarrollo (cree la carpeta `infra/firebase` cuando aún no exista para versionar reglas y datos semilla):
   ```bash
   firebase login
   firebase use <project-id-dev>
   firebase emulators:start --import=./infra/firebase/emulator-data
   ```

### Variables de entorno y secretos
- Crear el directorio `env/` en la raíz con archivos por entorno:
  - `env/dev.env`
  - `env/staging.env`
  - `env/prod.env`
- Cada archivo debe exponer pares `CLAVE=valor`. Ejemplo para `dev`:
  ```env
  ENVIRONMENT=dev
  FIREBASE_PROJECT_ID=freet-dev
  SENTRY_DSN=https://example.ingest.sentry.io/123456
  MAPBOX_TOKEN=pk.test
  OPENAI_API_KEY=sk-test
  ```
- Consumir las variables utilizando el flag `--dart-define-from-file=env/<env>.env` en tiempo de ejecución/build (requiere Flutter ≥3.16).
- Gestionar secretos sensibles mediante **Google Secret Manager** o **GitHub Actions Secrets**; nunca versionarlos en el repositorio.

### Ejecución local y pruebas
- Lanzar la aplicación apuntando al entorno deseado (usa emuladores/disp. físicos). Si aún no se han creado sabores nativos, puede omitirse la bandera `--flavor`:
   ```bash
   flutter run --flavor dev --target lib/main.dart --dart-define-from-file=env/dev.env
   ```
- Ejecutar la batería de pruebas:
  ```bash
  flutter test
  flutter test integration_test -d emulator-5554 # tras levantar emulador Android
  ```
- Validar métricas de linting y análisis estático:
  ```bash
  dart analyze
  dart run dart_code_metrics:metrics analyze lib
  ```

### Preparación de builds y despliegues
- **Android**:
  1. Configurar la firma en `android/key.properties` y `android/app/build.gradle`.
  2. Generar artefacto:
     ```bash
     flutter build appbundle --flavor prod --dart-define-from-file=env/prod.env
     ```
- **iOS**:
  1. Abrir `ios/Runner.xcworkspace`, seleccionar esquema `prod` y configurar certificados.
  2. Crear build para TestFlight/App Store:
     ```bash
     flutter build ipa --flavor prod --dart-define-from-file=env/prod.env
     ```
- **Web / Desktop (opcional)**:
  ```bash
  flutter build web --release --dart-define-from-file=env/staging.env
  ```
- Automatizar deploys con los pipelines descritos en [Automatización, CI/CD y DevOps](#automatización-cicd-y-devops), asegurando la ejecución de pruebas, análisis estático y subida de artefactos firmados.

## Arquitectura de la solución
- **Framework**: Flutter 3.x estable (iOS/Android); apertura a Flutter Web para panel administración.
- **Patrón**: Limpio (Presentación, Dominio, Datos) con Riverpod 2.x para inyección y gestión de estado.
- **Capas**:
  - **Presentación**: Widgets, controllers (notifiers), routers (`go_router`).
  - **Dominio**: Entidades inmutables, casos de uso, servicios de políticas.
  - **Datos**: Repositorios abstractos, fuentes remotas (Firestore, Functions, REST), locales (Hive, SQLite), DTOs y mapeadores.
  - **Infraestructura**: Servicios cross-cutting (notificaciones, analytics, storage seguro, ML).
- **Comunicación**: `freezed` + `json_serializable` para modelos, `sealed classes` para estados.
- **Configuración**: `.env` por entorno, Remote Config para toggles, Feature Flags.
- **Entornos**: dev (emuladores Firebase), staging (preprod con datos anonimizados), prod.

## Estructura de carpetas y módulos
```
lib/
 ├── app/
 │    ├── app.dart
 │    ├── router/
 │    ├── theme/
 │    └── localization/
 ├── core/
 │    ├── constants/
 │    ├── errors/
 │    ├── utils/
 │    └── widgets/
 ├── data/
 │    ├── datasources/
 │    ├── repositories/
 │    └── dtos/
 ├── domain/
 │    ├── entities/
 │    ├── repositories/
 │    └── usecases/
 ├── features/
 │    ├── dashboard/
 │    ├── routines/
 │    ├── evaluation/
 │    ├── social/
 │    ├── more/
 │    └── onboarding/
 ├── services/
 │    ├── analytics/
 │    ├── notifications/
 │    ├── auth/
 │    ├── storage/
 │    └── devices/
 └── main.dart
```
- `test/` organizado en `unit/`, `widget/`, `integration/`, `golden/`, `performance/`.
- `assets/` con estructura modular (iconos, ilustraciones, traducciones, lottie animations).

## Determinación de features
| Feature | Submódulos | Casos de uso | Métricas de éxito |
|---------|------------|--------------|-------------------|
| Dashboard | Resumen diario, Asistencia, Estadísticas, Tips | Registrar asistencia, ver progreso, recibir recomendaciones | Tiempo en pantalla, tasa de cumplimiento |
| Routines | Biblioteca, Generación IA, Editor, Compartir | Generar, editar, compartir rutinas | Rutinas completadas, uso de IA |
| Evaluation | Cámara, Feedback, Reportes | Evaluar ejecución, recibir feedback | Sesiones evaluadas, precisión de postura |
| Social | Rankings, Perfil social, Interacciones | Competir, reaccionar, comentar | Usuarios activos en social, reportes resueltos |
| More | Environment, Profile, Settings, FAQ, Log Out | Gestionar dispositivos, datos, soporte | Dispositivos vinculados, tickets resueltos |
| Onboarding | Setup inicial, tutorial | Configurar preferencias, conectar dispositivos | Conversión onboarding, finalización tutorial |

## Diseño de experiencia y UI
- **Design System**: basado en 8pt grid, tipografía `Inter` (texto) y `Poppins` (titulares), escalas dinámicas.
- **Paleta base**:
  - Claro: `#0F172A` (texto primario), `#22C55E` (acción), `#E2E8F0` (fondo).
  - Oscuro: `#0B1120` (fondo), `#38BDF8` (acción), `#F8FAFC` (texto).
  - Personalizado: editor en vivo con validación de contraste.
- **Componentes clave**: cards de rutina, chips de enfoque, toggles, gráficos, overlays de cámara, badges.
- **Microinteracciones**: transiciones Hero, animaciones `AnimatedSwitcher`, feedback háptico.
- **Accesibilidad**: etiquetas semánticas, orden de tabulación, soporte screen readers, contraste AA.
- **Documentación visual**: integración con Figma; export de tokens de diseño (`style-dictionary`).

## Modelado de datos y sincronización
### Firestore
- `users/{userId}`
  - Campos: `displayName`, `email`, `photoUrl`, `language`, `theme`, `preferences.notifications`, `goals`, `bio`, `devices`, `metrics`.
- `users/{userId}/routines/{routineId}`
  - `name`, `focus`, `schedule`, `exercises[]` (id, nombre, sets, reps, peso objetivo, descanso), `version`, `sharedWith`, `aiMetadata`.
- `users/{userId}/workouts/{workoutId}`
  - `date`, `routineId`, `completedExercises[]`, `notes`, `weightProgress`, `duration`, `perceivedEffort`.
- `leaderboards/{type}/entries/{entryId}`
  - `userId`, `metric`, `value`, `period`, `rank`, `badges`.
- `notifications/{notificationId}`
  - `title`, `body`, `type`, `cta`, `target`, `schedule`.
- `tips/{tipId}`: contenido dinámico, segmentación, fecha expiración.

### Sincronización y almacenamiento local
- Cache cifrada con Hive (`hive_flutter`) para rutinas recientes, métricas y preferencias.
- Persistencia offline habilitada con `cloud_firestore` + control de conflictos (marca `lastUpdated`, merges determinísticos).
- Estrategias de versionado: `schemaVersion` en documentos, migraciones con `cloud_functions`.
- Backup/exportación: Cloud Functions + Cloud Storage (JSON cifrado) descargable por usuario.

### APIs y Cloud Functions
- `generateRoutine(userId, goals, timeframe)`: retorna rutina IA.
- `evaluateForm(sessionData)`: valida sesión de cámara si requiere procesamiento backend.
- `sendNotification(eventType, payload)`: orquesta notificaciones personalizadas.
- `syncWearableData(userId, devicePayload)`: procesa datos externos.

## Integraciones externas y dispositivos
- Wearables via Bluetooth LE: plugin `flutter_reactive_ble`, abstracción `DeviceRepository`.
- Apple HealthKit / Google Fit: sincronización programada, permisos explícitos, opción de revocar.
- Pasarelas de pago (Stripe/Apple Pay/Google Pay) integradas modularmente (feature flag).
- Servicios ML externos opcionales (Vertex AI) para mejoras progresivas.

## Seguridad, privacidad y cumplimiento
- Autenticación: Firebase Auth (correo, Google, Apple), MFA opcional (SMS/App), revocación de tokens.
- Almacenamiento seguro: `flutter_secure_storage` para tokens, claves y credenciales.
- Reglas Firestore: validación estricta de ownership, roles (`user`, `coach`, `admin`), verificación de esquema.
- Cifrado en tránsito (HTTPS/TLS 1.2+), en reposo (Firestore, Storage, Hive con claves derivadas).
- Gestión de consentimientos y políticas de privacidad dinámicas (Remote Config + Cloud Functions).
- Auditoría: logs estructurados, detección de anomalías, alertas de seguridad.
- Cumplimiento: procedimientos para derecho al olvido, exportación de datos, retención y eliminación segura.

## Rendimiento y optimización
- Uso de widgets `const`, memoización, `ValueListenableBuilder`/`StreamBuilder` optimizados.
- Lazy loading y paginación para listas grandes (`infinite_scroll_pagination`).
- Compresión de imágenes, uso de vectores (`SVG`), `cached_network_image`.
- Pre-carga de datos críticos durante `splash` con `Future.wait` y timeout seguro.
- Medición de FPS/memoria con `flutter_driver`/`integration_test` + `devtools`.
- Estrategias de reducción de tamaño: split per ABI, R8/Proguard, tree shaking icons, deferred components.

## Machine Learning y visión por computador
- Modelo base: pose detection (MoveNet) optimizado para móvil (`TensorFlow Lite`) con configuración `delegates` (GPU/NNAPI/Metal).
- Pipeline de entrenamiento: dataset etiquetado, augmentations (rotación, iluminación), evaluación F1, precisión.
- Clasificador de postura: red ligera que analiza ángulos y velocidad; produce feedback semántico.
- Inferencia on-device: `tflite_flutter` + `camera` con isolates para no bloquear UI.
- Fallback en la nube: función `evaluateForm` en Vertex AI cuando el dispositivo no cumple requisitos.
- Métricas: latencia de inferencia (<60 ms), precisión mínima 85% para posturas críticas.
- Privacidad: procesamiento preferente on-device, envío a nube solo con consentimiento explícito.

## Telemetría, analítica y personalización
- Firebase Analytics + BigQuery export para cohortes, embudos y LTV.
- Eventos clave: `routine_generated`, `routine_completed`, `evaluation_performed`, `tip_consumed`, `device_linked`.
- Remote Config y A/B Testing para personalizar tips, UI, secuencia de onboarding.
- Segmentación: hábitos, objetivos, comportamiento histórico, datos de dispositivos.
- Observabilidad: logs estructurados, dashboards en Data Studio/Looker.

## Estrategia de pruebas E2E
### Pirámide de pruebas
- **Unitarias**: casos de uso, validadores, repositorios (mocktail, fakes). Cobertura ≥ 85%.
- **Widgets**: golden tests para componentes clave (Top Bar, Bottom Nav, cards, modales).
- **Integración**: flujos críticos con `integration_test`, `flutter_test`, Firebase Emulator Suite.
- **E2E en dispositivos reales**: BrowserStack/Flutter Test Lab para iOS/Android.
- **Rendimiento**: escenarios de estrés (listas con >500 elementos), mediciones de FPS/memoria.
- **Accesibilidad**: chequeos automáticos (`flutter_accessibility_checker`) + QA manual.

### Plan maestro de QA
1. **Preparación**: definición de ambientes, datos seed, credenciales dummy.
2. **Ejecución continua**: pipelines automáticos por rama `main`, `develop` y PRs.
3. **Regresión**: suites de smoke + regresión completa antes de release.
4. **Aprobación**: criterios de salida (0 blockers, ≤2 menores abiertos, cobertura cumplida).
5. **Post-release**: monitoreo intensivo 48h, hotfix protocol.

## Automatización, CI/CD y DevOps
- **Repositorios**: Git monorepo (app Flutter + funciones Cloud). Branching GitFlow (main, develop, feature/*, hotfix/*).
- **CI GitHub Actions/Codemagic**:
  - Jobs: lint/format, pruebas unitarias, pruebas widget, integración (emuladores), análisis estático (Dart Code Metrics, Sonar).
  - Generación de artefactos (APK/AAB/IPA) firmados; distribución con Firebase App Distribution y TestFlight.
  - Automatización de documentación (`dart doc`, reporte cobertura, changelog semántico).
- **Infraestructura**: IaC con Terraform para recursos Firebase/Google Cloud.
- **Monitoring**: dashboards en Firebase Performance, Crashlytics, alertas Slack.
- **Backups**: rutinas programadas de Firestore (Cloud Scheduler + Functions) y almacenamiento en Cloud Storage cifrado.

## Lineamientos de código y calidad
- `Effective Dart`, `flutter_lints` personalizado, `dart_code_metrics` (>3.0) para complejidad.
- `freezed` para datos inmutables, `equatable` para comparación, `sealed unions` para estados.
- Documentar clases/métodos públicos (`///`), generar documentación automática.
- Reglas de revisión de código: 2 aprobaciones, checklists de seguridad/performance/accessibilidad.
- Convenciones de commits (`Conventional Commits`), versionado semántico.

## Plan de liberación y soporte operativo
- **Cadencia**: releases quincenales con ventanas de congelamiento.
- **Checklist release**: QA completado, métricas en verde, documentación actualizada, soporte preparado.
- **Soporte**: niveles L1-L3, acuerdos de SLA (respuesta <4h críticos), runbooks por módulo.
- **Gestión de incidencias**: creación en herramienta (Jira/Linear), etiquetado, análisis raíz y postmortems.
- **Community management**: moderación, respuesta a reportes, campañas de engagement.

## Gestión de riesgos y mitigaciones
| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|------------|
| Latencia alta en generación IA | Media | Alta | Caching, jobs programados, fallback manual |
| Fallas de detección ML | Media | Alta | Entrenamiento continuo, calibración, fallback humano |
| Saturación de Firestore | Baja | Alta | Sharding, límites, pruebas de carga |
| Pérdida de datos dispositivos externos | Media | Media | Retries, persistencia local, validación |
| Incumplimiento de privacidad | Baja | Crítico | Revisiones legales, auditorías periódicas |
| Abandono de usuarios | Media | Alta | Personalización, notificaciones inteligentes, features sociales |

## Anexos y recursos complementarios
- **Repositorio de diseño**: Figma con librería de componentes, prototipos interactivos y tokens exportables.
- **Guías de contenido**: tono motivacional, mensajes claros, traducciones validadas.
- **Documentación técnica adicional**: Postman Collection de APIs, guías de configuración de entornos, scripts de inicialización.
- **Matrices RACI**: responsabilidad por módulo (producto, diseño, ingeniería, QA, datos).
- **Roadmap referencial**: fases MVP, Beta cerrada, Beta abierta, Release público, expansión premium.

---

> Esta especificación debe mantenerse versionada y actualizada a medida que evolucionen requerimientos o integraciones, asegurando que todas las áreas (producto, diseño, ingeniería, datos y soporte) cuenten con una referencia única y confiable del sistema FreeT.

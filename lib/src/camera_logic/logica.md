# Lógica del uso de la cámara

## Versión 1 - 02/11/2025 (Subida)

Para llamar a la **función** de la cámara solo hace falta importar la clase `PoseDetector`:

```dart
import 'src/camera_logic/pose_detector_view.dart';
```

Una vez importada, solo hace falta llamar a la función que activa la cámara:

```dart
PoseDetectorView()
```

Esta versión está totalmente enfocada a la integración de ML Kit y la cámara de los dispositivos móviles, la cual incluye funcionalidades propias de una aplicación de cámara como:

- Ajustar el brillo de la escena (subir y/o bajar)
- Cambiar entre cámaras (frontal y trasera)
- Zoom digital

Además de contar con las funcionalidades de ML Kit como:

- Capturar coordenadas del cuerpo (33 puntos)
- Dibujar el esqueleto del cuerpo (pose detection)

La versión y modelo de la cámara que se usa para **ML Kit** y evitar errores es CameraX con cualquier versión disponible al momento, preferentemente la última versión.

## Próxima Versión

Para la siguiente versión (algunos aspectos se evitaron temporalmente por requerir conexiones adicionales) se realizarán varias correcciones e integraciones de funciones, como:

- **Generación de JSON** (evitada temporalmente por problemas de optimización)
    - Puntos de coordenadas del modelo de ML Kit
    - Datos base como edad, estatura, peso, deficiencia física
- **Adaptación de ML Kit a MediaPipe** para optimizar la captura de coordenadas en la ejecución de ejercicios
    - Implementación del algoritmo de Jarvis como función extra para reducir ruido en la captura de puntos
- **Integración de modelo CNNs** para el análisis del ejercicio
- **Asistente de voz** para guiar la ejecución de ejercicios
- **Sprites** (módulo de cámara) para feedback visual
- **Optimización** del uso de la cámara en dispositivos antiguos

Se analizarán las posibles mejoras que surjan con el tiempo y también la eliminación de funcionalidades que puedan considerarse innecesarias. De igual manera, se espera realizar pruebas de usabilidad de la aplicación para obtener referencias sobre mejoras y deficiencias.

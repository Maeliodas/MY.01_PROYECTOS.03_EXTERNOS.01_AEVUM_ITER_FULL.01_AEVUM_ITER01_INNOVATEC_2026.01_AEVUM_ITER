# Aevum Iter · Versión AIPROD2.3.1

> **Versión completa actual: `AIPROD2.3.1_R3_IN`** — siglas **AI** (Aevum Iter, pegadas), canal **PROD**,
> versión **2**, actualizaciones mayores **3**, actualizaciones medianas **1**,
> revisión **3**, rama **IN** (Innovatec). Edición de presentación comercial.

## Revisión R3 (actual): permiso de cámara

- `AndroidManifest.xml`: faltaba `android.permission.CAMERA` — `Tomar foto` moría en físicos. Agregado + etiqueta `Aevum Iter`.
- `custom_avatar_page.dart`: `Galería`/`Cámara` con `try/catch`, error visible en `SnackBar` y `debugPrint`.
- `pubspec.yaml` → `2.3.1+3`; `flutter analyze` limpio.

## Revisión R2: guardar y salir al mapa

- `test_page.dart`: `Guardar y Salir` (botón y gesto atrás) hacía `pop`, pero como se llega con `go('/test')` la pila está limpia y no había a dónde volver — se quedaba en el test. Ahora va a `/path-home` (mapa interactivo, tab 0). El progreso ya se autoguardaba por respuesta.
- `pubspec.yaml` → `2.3.1+2`; `flutter analyze` limpio.

## Revisión R1: retiro de pregunta abierta

- Flujo sin abierta: `test_page.dart` manda a `/thank-you` al terminar reactivos; `thank_you_page.dart` ya no exige respuesta del top 1 (fuera el bloque `needsOpen`).
- Eliminados `open_question_page.dart` y la ruta `/open-question` (+ import en `app_router.dart`).
- Capa de datos intacta a propósito (tabla `career_open_answers`, columna `open_answer`, proveedor de preguntas por departamento): sin UI, sin migración.
- README principal actualizado (tabla, diagrama y pasos sin abierta).
- `pubspec.yaml` → `2.3.1+1`; `flutter analyze` limpio.

## ✅ Resuelto en R2

- Botón de guardar progreso que regresaba al test en vez del mapa: corregido (ver sección R2).

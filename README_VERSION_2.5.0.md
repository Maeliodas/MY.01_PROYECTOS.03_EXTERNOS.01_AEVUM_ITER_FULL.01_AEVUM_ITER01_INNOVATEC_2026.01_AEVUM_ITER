# Aevum Iter · Versión AIPROD2.5.0

> **Versión completa actual: `AIPROD2.5.0_R1_IN`** — siglas **AI** (Aevum Iter, pegadas), canal **PROD**,
> versión **2**, actualizaciones mayores **5**, actualizaciones medianas **0**,
> revisión **1**, rama **IN** (Innovatec). Edición de presentación comercial.

## Revisión R1 (actual): soporte web demo

- Misma app compilada a web (`flutter build web` verificado) para exposiciones: sin APK que instalar.
- SQLite en IndexedDB (`sqflite_common_ffi_web` + `sqlite3.wasm` en `web/`, factory en `main.dart`).
- Seed por JSON (`assets/database/catalogs_seed.json`) en web; SQLite preconstruido en móvil (sin cambios).
- Fotos multiplataforma (`local_image` con import condicional; blob-URLs en web).
- Fichas de carrera en iframe web / WebView móvil (`career_site_body` condicional).
- Red con `package:http` (fuera `dart:io` de la app salvo `seed_store_io`).
- `pubspec.yaml` → `2.5.0+1`; `flutter analyze` limpio.
- Pendiente de probar en navegador real (aquí sin Chrome): arranque, seed y fichas.

# Aevum Iter · Versión AIPROD2.3.0

> **Versión completa actual: `AIPROD2.3.0_R10_IN`** — siglas **AI** (Aevum Iter, pegadas), canal **PROD**,
> versión **2**, actualizaciones mayores **3**, actualizaciones medianas **0**,
> revisión **10**, rama **IN** (Innovatec). Edición de presentación comercial.

## Revisión R10 (actual): retiro del detalle técnico del splash

- `splash_page.dart`: fuera el bloque `Detalle: <error>` y el estado `errorDetail`. El error ya no reaparece y no debe exponerse texto técnico al usuario; queda solo el `debugPrint` interno para logcat.
- `pubspec.yaml` → `2.3.0+10`; `flutter analyze` limpio.

## Revisión R9: assert ListTile + retorno de avatar

- **Excepción `ListTile background color or ink splashes may be invisible`**: los `ListTile`/`SwitchListTile` vivían dentro de `Container` con color (4 en ajustes, 3 en perfil) y el ripple quedaba oculto. Envueltos en `Material` transparente — mismo look, sin assert. Era lo que se veía al guardar test y entrar a perfil/ajustes.
- **Pérdida de datos al cambiar avatar**: `CAMBIAR AVATAR` ahora va a `/choose-avatar?return=personal-data` y el Continuar hace `pop` a la pantalla existente (conserva nombre/edad/género) en vez de crear otra vacía. Rutas y página custom propagan el retorno.
- `pubspec.yaml` → `2.3.0+9`; `flutter analyze` limpio.

## Revisión R8 (actual): diagnóstico visible del splash

- `splash_page.dart`: la pantalla de error ahora muestra el `Detalle: <error>` real bajo el mensaje + `debugPrint`. El reintento limpia el detalle.
- Red de sync auditada: `dashboard_api` con timeouts (8–12 s), `hasBackendConnection` a 3 s, sync acotado a 8 s — el fallo persistente tras cerrar no viene de red colgada sino de estado local (la BD se recupera borrando datos). Con el detalle visible se identifica en una corrida.
- `pubspec.yaml` → `2.3.0+8`.

## Revisión R7: fixes de físicos

- **Crash `Unsupported operation: read-only`** (`profile_repository.dart`): `getProfile` mutaba `results[0]` sobre el `QueryResultSet` de solo lectura al parchar escuela pendiente. Ahora copia a variable local `first`. Era el verdadero culpable del botón muerto: el guardado sí funcionaba (perfil en BD), la lectura posterior reventaba.
- **Botón de ficha por carrera**: verificado — el diálogo `Página oficial no disponible` ya no existe en el código; el detalle siempre abre `/career-site?career=<id>` con su HTML. Si aún se ve, es APK vieja: desinstalar e instalar de nuevo.
- `pubspec.yaml` → `2.3.0+7`; `flutter analyze` limpio.

## Revisión R6: fix botón Continuar

- `personal_data_page.dart`: el `onPressed` iba sin `try/catch` — cualquier excepción en `saveProfile` mataba el botón en silencio. Ahora muestra el error real en `SnackBar` (+ `debugPrint` para logcat) y tiene estado de carga anti doble-tap.
- `pubspec.yaml` → `2.3.0+6`.

## Revisión R5: limpieza visual

- Fuera dependencia `url_launcher` (cero usos tras las fichas locales) + `flutter pub get`.
- Fuera ruta `/privacy` (nadie navegaba a ella; el aviso vive como diálogo) y clase `PrivacyPage`.
- Corrección de registro: `test_progress_tree_page.dart` sí se usa (tab del home) — no se toca.
- `pubspec.yaml` → `2.3.0+5`; pie del aviso → `AIPROD2.3.0_R5_IN`; `flutter analyze` limpio.

## Revisión R4: fichas locales y limpieza

- **Fichas HTML por carrera**: 11 archivos en `assets/careers/` (diseño de prueba azul, plan/campo mock + aviso de demostración), registrados en `pubspec.yaml`.
- **Visor in-app**: `career_site_page.dart` (WebView sin JS, sin navegación externa) + ruta `/career-site?career=`; el detalle de carrera ahora siempre muestra `Ver ficha de la carrera` en vez del diálogo `Página oficial no disponible`. Dep `webview_flutter` agregada.
- **Limpieza segura**: eliminado `simple_avatar_editor_page.dart` (huérfana) y tabla muerta `avatar_configuration` (`app_database.dart`, `tables.dart`); seed con duplicados desactivados (`cbtis107`, `other_school`, respaldo en `/tmp/opencode/seed_v15_backup.db`).
- `pubspec.yaml` → `2.3.0+4`; pie del aviso → `AIPROD2.3.0_R4_IN`; `flutter analyze` limpio.

## Revisión R3: recorte comercial

- **Sugerencias**: sin UI que eliminar — no existen pantallas ni botones de sugerir lengua/escuela en la app; solo plomería dormida de backend (`catalog_sync_service.suggest/suggestSchool`, tabla `catalog_suggestion_queue`). Se deja intacta para no romper el esquema SQLite.
- **Historial**: se mantiene (`/history` + menú).
- **Avatar**: el flujo pedido ya existía y se confirmó — `choose_avatar_page.dart` (parrilla de 6 + botón `Elegir otro avatar` + `Continuar` → `/personal-data`), `custom_avatar_page.dart` (círculo + `Galería`/`Tomar foto` + `Continuar` → `/personal-data`) y `personal_data_page.dart` carga el avatar elegido vía `avatarProvider` (asset o archivo). Solo se renombró el botón a `Elegir otro avatar`.
- **Sync silencioso**: eliminada la sección `DATOS Y CATÁLOGOS` (botón manual `Actualizar catálogos`) de `settings_page.dart`; el sync sigue automático (splash acotado + en vivo). Import sin uso removido.
- **Privacidad extensa**: `privacy_page.dart` reescrito a aviso integral de 13 secciones (responsable, datos, sensibles, finalidades, consentimiento, transferencias, almacenamiento, seguridad, conservación, ARCO, menores, cambios, contacto) con marca `Aevum Iter` vía `AppConstants.appName`. Sin textos `ITTUX` en el proyecto (verificado). Subtítulo de Ayuda: `Presentación comercial`.
- **Debug**: se mantiene el `debugPrint` de `main.dart` (imprime URL y key de API al arrancar para diagnóstico; no afecta la UI).
- **Versión propagada (R3)**: `pubspec.yaml` → `2.3.0+3` (luego `2.3.0+4` en R4), título web → `Aevum Iter`, pie del aviso actualizado.
- `flutter analyze`: sin issues.

## Revisión R2: identidad

- Fuente vectorial en `~/Descargas/vectorizado_logo/` (`logo_brujula.svg`, previews 1024).
- `assets/branding/app_logo_light.png` (488×488): brújula sobre fondo blanco `#FFFFFF` (modo claro).
- `assets/branding/app_logo_dark.png` (488×488): brújula sobre fondo navy `#12305C`, igual al contenedor dark del splash (`splash_page.dart`).
- Sin cambios de código: el splash ya alternaba `app_logo_dark/light.png` según `Brightness`.

## Avatares

- `assets/avatars/avatar_01.png` (1254×1254, antes Na'vi 238×238): chica estudiante, retrato frontal simétrico estilo clay.
- `assets/avatars/avatar_06.png` (1254×1254): personaje nuevo independiente — chica de dos moños con diadema de osito rosa y sudadera rosa/blanca, retrato frontal simétrico estilo clay.
- Originales respaldados fuera del repo (`/tmp/opencode/avatar_backup/`).
- Sin cambios de código: `avatar_provider.dart`, `simple_avatar_editor_page.dart` y el default `avatar_config.dart` usan las mismas rutas.

## Tema: paleta verde → azul del logo

- `lib/app/theme/app_colors.dart`: primary `0xFF0262FC`, primaryDark `0xFF024AB8`, primaryLight `0xFFDCE8FF`, fondo `0xFFF1F5FF`.
- `lib/app/theme/app_theme.dart`: fondos y superficies dark a navy (`0xFF0A1428`, `0xFF101D33`), textos sobre primary a blanco, switches/inputs/bordes a grises azulados.
- 152 reemplazos en 21 archivos (`lib/`): títulos, iconos, botones, gradientes, chips y fondos en modo claro y oscuro.
- No se tocó: paleta RIASEC de gráficas (incluye el verde `S`), morados/cian decorativos ni rojos de error.
- `flutter analyze`: sin issues.

## Verificación

```bash
flutter analyze --no-pub   # No issues found!
```

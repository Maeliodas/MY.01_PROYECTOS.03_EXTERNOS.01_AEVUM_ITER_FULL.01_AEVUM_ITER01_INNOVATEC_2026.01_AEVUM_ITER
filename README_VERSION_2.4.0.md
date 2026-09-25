# Aevum Iter · Versión AIPROD2.4.0

> **Versión completa actual: `AIPROD2.4.0_R5_IN`** — siglas **AI** (Aevum Iter, pegadas), canal **PROD**,
> versión **2**, actualizaciones mayores **4**, actualizaciones medianas **0**,
> revisión **5**, rama **IN** (Innovatec). Edición de presentación comercial.

## Revisión R5 (actual): launcher con fondo transparente

- `mipmap-*/ic_launcher.png`: antes fondo navy completo (el launcher lo encogía sobre círculo blanco y se veía el cuadro azul). Ahora círculo blanco + brújula con exterior transparente, compone limpio en cualquier launcher y tema.
- `pubspec.yaml` → `2.4.0+5`.

## Revisión R4 (actual): icono en todas las plataformas

- Launcher Android (5 densidades, fondo navy), iconos web 192/512 + maskable + favicon, ICO de Windows y `manifest.json` con nombre, colores y descripción Aevum Iter.
- `pubspec.yaml` → `2.4.0+4`.

## Revisión R3: fuera pregunta abierta del panel y provider

- **Panel**: eliminado endpoint `PUT department-questions`, tarjeta de pregunta por departamento, query de abiertas y columna `Respuestas` (EJS+JS); fuera `departmentQuestions` del payload admin.
- **App**: eliminado provider `departmentQuestionsProvider` y sus invalidaciones (splash + vivo). Capa de datos intacta (tablas, sync, ingesta).
- `pubspec.yaml` → `2.4.0+3`; panel y app verificados (sintaxis, EJS, analyze).

## Revisión R2: fuera lenguas, escuelas y procedencia

- **App**: eliminada la sección `Procedencia académica` de editar-perfil (dropdowns estado/municipio/escuela) y el stat `ESCUELA` del perfil; fuera providers `states/municipalities/schools/languages` y sus invalidaciones; aviso de privacidad sin esos datos. Capa de datos intacta a propósito (entidad, repo, sync, BD).
- **Panel**: fuera filtros estado/municipio/escuela, gráficas de procedencia/escuelas/lenguas/idiomas, columnas de registros, tabs y 4 parciales de esos catálogos, agregados del servidor, KPI de escuelas (3 tarjetas) y secciones 6–7 + columnas del PDF. Ingesta y esquema intactos.
- `pubspec.yaml` → `2.4.0+2`; `flutter analyze` limpio; panel con sintaxis y render EJS verificados.

## Revisión R1: rebalanceo del instrumento RIASEC

Problema: Bioquímica ganaba casi siempre, incluso con el perfil ideal de otras carreras. Causas halladas por simulación del algoritmo exacto: vectores I casi idénticos en ISC/II/IBQ, códigos Holland duplicados (IRC×2, RIC×3, ESC×2) y la media ponderada premiando vectores concentrados (IBQ cosechaba C=6.4).

Solución (validada por simulación antes de tocar datos): pesos y códigos rediseñados por carrera, 11 códigos Holland únicos. Resultado contra el seed ya actualizado: **11/11 perfiles ideales ganan su carrera** (antes 6/11) y los perfiles típicos responden con sentido (I puro→IBQ/II, R puro→IEM, C puro→CP, A alto→ARQ).

- Cambios de código: `ii ICR→ICE`, `iem RIC→RIE`, `ic RIC→RCE`, `ibq IRC→ICR`, `ige ESC→EIC` (+ vectores).
- Aplicado en: seed `assets/database/aevum_iter_catalog_v15.db`, referencia `database_model/aevum_iter_sqlite_v16.db` y `sql/schema.sql` del panel (respaldo previo en `/tmp/opencode/seed_v15_pre_rebalance.db`).
- La calculadora no se tocó (idéntica a ITTUX por diseño). Instalaciones ya existentes conservan pesos viejos salvo reinstalación o sync desde panel actualizado.
- `pubspec.yaml` → `2.4.0+1`; `flutter analyze` limpio.

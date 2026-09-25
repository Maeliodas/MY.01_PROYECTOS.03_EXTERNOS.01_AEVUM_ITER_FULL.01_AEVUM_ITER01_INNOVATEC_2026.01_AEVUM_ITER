# Aevum Iter · Versión AIPROD2.4.0

> **Versión completa actual: `AIPROD2.4.0_R1_IN`** — siglas **AI** (Aevum Iter, pegadas), canal **PROD**,
> versión **2**, actualizaciones mayores **4**, actualizaciones medianas **0**,
> revisión **1**, rama **IN** (Innovatec). Edición de presentación comercial.

## Revisión R1 (actual): rebalanceo del instrumento RIASEC

Problema: Bioquímica ganaba casi siempre, incluso con el perfil ideal de otras carreras. Causas halladas por simulación del algoritmo exacto: vectores I casi idénticos en ISC/II/IBQ, códigos Holland duplicados (IRC×2, RIC×3, ESC×2) y la media ponderada premiando vectores concentrados (IBQ cosechaba C=6.4).

Solución (validada por simulación antes de tocar datos): pesos y códigos rediseñados por carrera, 11 códigos Holland únicos. Resultado contra el seed ya actualizado: **11/11 perfiles ideales ganan su carrera** (antes 6/11) y los perfiles típicos responden con sentido (I puro→IBQ/II, R puro→IEM, C puro→CP, A alto→ARQ).

- Cambios de código: `ii ICR→ICE`, `iem RIC→RIE`, `ic RIC→RCE`, `ibq IRC→ICR`, `ige ESC→EIC` (+ vectores).
- Aplicado en: seed `assets/database/aevum_iter_catalog_v15.db`, referencia `database_model/aevum_iter_sqlite_v16.db` y `sql/schema.sql` del panel (respaldo previo en `/tmp/opencode/seed_v15_pre_rebalance.db`).
- La calculadora no se tocó (idéntica a ITTUX por diseño). Instalaciones ya existentes conservan pesos viejos salvo reinstalación o sync desde panel actualizado.
- `pubspec.yaml` → `2.4.0+1`; `flutter analyze` limpio.

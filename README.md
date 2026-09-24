<div align="center">
  <img src="assets/branding/app_logo_light.png" alt="Aevum Iter" width="160"/>

  # Aevum Iter AIPROD2.3.0_R8_IN

  **Descubre tu camino** — Orientación vocacional con modelo RIASEC / Holland, operación offline-first y panel institucional en tiempo real.
  Edición de presentación comercial.

  [![release](https://img.shields.io/badge/release-AIPROD2.3.0__R8__IN-0262FC?style=for-the-badge)](README_VERSION_2.3.0.md)
  [![flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](.)
  [![dart](https://img.shields.io/badge/Dart-%5E3.2-0175C2?style=for-the-badge&logo=dart&logoColor=white)](.)
  [![node](https://img.shields.io/badge/Node.js-Express_4-339933?style=for-the-badge&logo=node.js&logoColor=white)](.)
  [![mysql](https://img.shields.io/badge/MySQL_MariaDB-utf8mb4-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](.)
  [![sqlite](https://img.shields.io/badge/SQLite-offline--first-003B57?style=for-the-badge&logo=sqlite&logoColor=white)](lib/core/database/)
  [![platforms](https://img.shields.io/badge/Android_iOS_Web_Desktop-multimedia-6E26C8?style=for-the-badge)](.)

  <p>
    <a href="#-características">Características</a> •
    <a href="#-cómo-funciona">Cómo funciona</a> •
    <a href="#-instalación">Instalación</a> •
    <a href="#-api-del-panel">API</a> •
    <a href="#-versionado">Versionado</a> •
    <a href="#-historial-de-versiones">Historial</a>
  </p>
</div>

---

## ✨ Características

| Módulo | Lo que hace |
|---|---|
| 📝 Test RIASEC | 30 reactivos offline, puntajes 0–50 por dimensión y código Holland de 3 letras |
| 🎯 Ranking de carreras | Afinidad por perfil vectorial + congruencia hexagonal Holland, top 3 |
| 💬 Pregunta abierta | Obligatoria (mín. 10 caracteres), ligada al departamento del top 1; no modifica puntaje y no se puede saltar por URL |
| 🏫 Catálogos vivos | Versionados con atajo por versión y UPSERT rápido: sync acotado en arranque, en vivo al reanudar/cada 5 min, manual en Ajustes |
| 🗣️ Lenguas e idiomas | Clasificación por tipo relacional + sugerencias ciudadanas con aprobación administrativa |
| 📴 Offline-first | SQLite local precargado, verificación contra el backend (`/health`), colas de envío con tope de reintentos |
| 🖥️ Panel web | CRUD de catálogos, dashboard en vivo (Socket.IO), filtros, revisión de sugerencias, reportes PDF y endpoint ligero de versión |
| 🔒 Datos | UTF-8/utf8mb4 integral, bajas lógicas (`active=0`) que no rompen históricos, IDs de resultado UUID |

<div align="center">
  <img src="assets/avatars/avatar_01.png" width="64"/>
  <img src="assets/avatars/avatar_02.png" width="64"/>
  <img src="assets/avatars/avatar_03.png" width="64"/>
  <img src="assets/avatars/avatar_04.png" width="64"/>
  <img src="assets/avatars/avatar_05.png" width="64"/>
  <img src="assets/avatars/avatar_06.png" width="64"/>
  <br/>
  <em>Avatares incluidos + editor con galería y cámara</em>
</div>

## 🧭 Cómo funciona

```mermaid
flowchart LR
    E[Estudiante] --> A[App Flutter<br/>offline-first]
    A -->|1. Reactivos| C{Cálculo RIASEC}
    C -->|2. Top 1| P[Pregunta abierta<br/>por departamento]
    P -->|3. Respuesta| R[Resultado + Holland]
    R -->|4. Cola sync| N[Panel Node/Express]
    N --> M[(MySQL / MariaDB)]
    M --> D[Dashboard + PDF]
    N -->|5. Versión ligera<br/>+ snapshot| A
```

1. El splash sincroniza catálogos (acotado) **antes** de navegar: los datos nuevos se ven desde la 1ª apertura.
2. El test se responde **sin internet** contra el SQLite local, con progreso reanudable.
3. Al terminar reactivos se calcula el ranking y se exige la pregunta abierta del departamento ganador.
4. El resultado (Holland, RIASEC, top 1, abierta, género, edad, escuela, lenguas) se envía o encola con reintentos acotados.
5. Con red, la app revisa la versión del panel al reanudar y cada 5 min; sin red, lo pendiente entra en el siguiente arranque.

## 🛠️ Stack

| Capa | Tecnología |
|---|---|
| App | Flutter 3, Riverpod, go_router, sqflite |
| Panel | Node.js, Express 4, EJS, Socket.IO, PDFKit |
| Datos | MySQL/MariaDB (maestro) → SQLite (copia local) |
| Auth ingesta | `Authorization: Bearer API_INGEST_KEY` |

## 📁 Estructura

```
aevum_iter/
├── lib/                  # App Flutter (app, core, features)
│   ├── core/             # BD, red, sync, constantes
│   └── features/         # test, result, profile, catalog, avatar…
├── assets/               # avatares, branding, seed SQLite
├── database_model/       # Modelos SQLite de referencia
├── README.md             # Este archivo (general)
├── README_VERSION_X.Y.Z.md  # Detalle específico por versión
├── README_AEVUM.md       # Documento base previo (1.3.2)
└── CAMBIOS_AEVUM.md      # Bitácora anterior (1.3.2-10)
```

## 🚀 Instalación

<details>
<summary><strong>📱 App Flutter</strong></summary>

```bash
flutter pub get
flutter run --dart-define=AEVUM_ITER_API_URL=http://IP_DE_TU_PC:8080/api
```

> En producción usa exclusivamente la URL HTTPS institucional y define `AEVUM_ITER_API_KEY` con el mismo valor de `API_INGEST_KEY` del panel.

</details>

<details>
<summary><strong>🖥️ Panel web + API</strong></summary>

```bash
mysql -u root -p < admin_panel/sql/schema.sql
cd admin_panel
cp .env.example .env   # edita credenciales y API_INGEST_KEY
npm install
npm start
```

Panel en `http://localhost:8080` · Salud en `GET /health`.

</details>

## 🔌 API del panel

| Método | Ruta | Descripción | Auth |
|---|---|---|---|
| `GET` | `/health` | Estado del servicio + BD | — |
| `GET` | `/api/catalog-version` | Versión ligera del catálogo (chequeo en vivo) | API key |
| `GET` | `/api/catalogs` | Snapshot versionado de catálogos | API key |
| `POST` | `/api/catalog-suggestions` | Sugerir lengua, idioma o escuela | API key |
| `POST` | `/api/evaluations` | Registrar evaluación del test | API key |

## 🔢 Versionado

Esquema estilo ZZZ (`OSPRODAndroid3.2.0_R…_S…_D…`): siglas+canal pegados, versión y revisiones con guion bajo — `AIPROD2.3.0_R8_IN` (en builds empaquetados se inserta plataforma: `AIPRODAndroid2.3.0_R8_IN`):

| Parte | Significado | Cuándo cambia |
|---|---|---|
| `AI` | Siglas de la app | Aevum Iter (fijo, pegado) |
| `PROD` | Canal | Presentación comercial / producción |
| `2` | Número de versión | Cuando las actualizaciones mayores llegan a 9 |
| `3` | Actualizaciones mayores | Cambio/anexión de archivos o reescritura completa |
| `0` | Actualizaciones medianas | Cambios medios sin ser mayores (se reinicia al cambiar de versión) |
| `_R2` | Revisión | Modificaciones menores |
| `_IN` | Rama | Innovatec |

## 📜 Historial de versiones

| Versión | Cambios (general) | Detalle |
|---|---|---|
| [AIPROD2.3.0_R8_IN](README_VERSION_2.3.0.md) | Diagnóstico visible en splash para el fallo tras test | [Ver detalle](README_VERSION_2.3.0.md) |

---

<div align="center">
  <sub>Aevum Iter AIPROD2.3.0_R8_IN · Rama Innovatec · Uso institucional</sub>
</div>

# Symplifica - Dashboard de Empleados y Beneficios

Prueba técnica Fullstack Junior para Symplifica: un dashboard que unifica la gestión de
empleados, la gestión de beneficios y datos externos de geolocalización (OpenStreetMap
Nominatim), consumidos desde un frontend en VueJS.

## Arquitectura

```
pruebaSymplifica/
├── backend/    Rails API (empleados, beneficios, integración con Nominatim, auth JWT)
├── frontend/   Vue 3 + Vite (dashboard)
└── docker-compose.yml
```

- **Backend**: Ruby on Rails 7.2, API-only. PostgreSQL como base de datos.
- **Frontend**: Vue 3 + Vite, Vue Router, Pinia (estado de auth), Axios, Tailwind CSS.
- **Autenticación**: JWT (implementación manual con `bcrypt` + gema `jwt`, sin Devise).
- **API externa**: OpenStreetMap Nominatim — se consulta la ciudad del empleado para obtener
  latitud/longitud al ver su detalle.

Un único backend Rails resuelve tanto la gestión de empleados como la de beneficios y la
integración externa (en vez de separar en dos servicios como sugiere el diagrama original del
reto), ya que la prueba permite elegir un solo lenguaje de backend.

## Requisitos previos

- Ruby 3.3.5 y Rails 7.2
- Node 22+
- PostgreSQL 16 (si se corre sin Docker)
- Docker y Docker Compose (opcional, para levantar todo con un solo comando)

## Opción 1: Ejecutar con Docker (recomendado)

Desde la raíz del proyecto:

```bash
docker-compose up --build
```

Esto levanta 3 servicios: `db` (PostgreSQL), `backend` (Rails, puerto 3000) y `frontend` (Vite,
puerto 5173). El backend crea la base de datos, corre las migraciones y carga los datos de
prueba automáticamente al iniciar.

- Frontend: http://localhost:5173
- Backend: http://localhost:3000/api

## Opción 2: Ejecutar en local (sin Docker)

### Backend

```bash
cd backend
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server -p 3000
```

Por defecto, `config/database.yml` usa el socket local de PostgreSQL con el usuario del sistema
operativo. Si tu configuración de PostgreSQL requiere usuario/contraseña, define las variables
de entorno `DATABASE_HOST`, `DATABASE_USERNAME` y `DATABASE_PASSWORD` antes de correr los
comandos anteriores.

### Frontend

```bash
cd frontend
cp .env.example .env
npm install
npm run dev
```

La app queda disponible en http://localhost:5173.

## Credenciales de prueba

Los seeds (`backend/db/seeds.rb`) crean un usuario y algunos empleados de ejemplo:

- **Usuario**: `admin@symplifica.com`
- **Contraseña**: `symplifica2026`

## Variables de entorno

### Backend (`backend/.env` o variables de entorno del sistema/Docker)

| Variable             | Descripción                                              | Default (desarrollo local) |
|-----------------------|-----------------------------------------------------------|-----------------------------|
| `DATABASE_HOST`       | Host de PostgreSQL                                        | socket local                |
| `DATABASE_USERNAME`   | Usuario de PostgreSQL                                     | usuario del sistema         |
| `DATABASE_PASSWORD`   | Contraseña de PostgreSQL                                  | (vacío)                     |
| `JWT_SECRET`          | Secreto para firmar los tokens JWT                        | secreto de desarrollo fijo (**cambiar en producción**) |
| `FRONTEND_URL`        | Origen permitido por CORS                                 | `http://localhost:5173`     |

### Frontend (`frontend/.env`, ver `frontend/.env.example`)

| Variable         | Descripción                  | Default                        |
|-------------------|-------------------------------|----------------------------------|
| `VITE_API_URL`    | URL base de la API del backend | `http://localhost:3000/api`     |

## Endpoints de la API

Todos los endpoints (excepto `/api/login`) requieren el header `Authorization: Bearer <token>`.

| Método | Endpoint                                | Descripción                                      |
|--------|-------------------------------------------|---------------------------------------------------|
| POST   | `/api/login`                              | Autentica y devuelve un JWT                        |
| GET    | `/api/employees`                          | Lista todos los empleados                          |
| POST   | `/api/employees`                          | Crea un empleado                                   |
| GET    | `/api/employees/:id`                      | Detalle de un empleado: beneficios + coordenadas de Nominatim |
| GET    | `/api/employees/:employee_id/benefits`    | Lista los beneficios de un empleado                |
| POST   | `/api/employees/:employee_id/benefits`    | Crea un beneficio para un empleado                 |
| GET    | `/api/benefits/:id`                       | Detalle de un beneficio                            |
| PUT    | `/api/benefits/:id`                       | Actualiza un beneficio                             |
| DELETE | `/api/benefits/:id`                       | Elimina un beneficio                               |

## Tests

```bash
cd backend
bundle exec rspec
```

Cubre modelos (`Employee`, `Benefit`, `User`), el servicio `NominatimClient` y los endpoints de
la API (incluyendo autenticación). Las llamadas a Nominatim están mockeadas con WebMock — los
tests nunca hacen peticiones reales a la API externa.

## Decisiones técnicas

- **JWT manual en vez de Devise**: para una API con un único rol (login + emisión de token), una
  implementación manual con `bcrypt` + `jwt` es más simple de explicar y auditar que configurar
  Devise + `devise-jwt` (que añade complejidad de revocación de tokens y ajustes para modo API).
- **Secreto JWT y credenciales de base de datos por variables de entorno**: se evita depender de
  `config/master.key` (no versionado en git), para que el proyecto corra en cualquier máquina o
  contenedor sin necesitar un secreto compartido fuera del repositorio.
- **Nominatim solo se consulta en el detalle del empleado** (`GET /api/employees/:id`), no en el
  listado, para no golpear la API externa en cada carga de la lista.
- **Rutas de beneficios semi-anidadas**: `index`/`create` viven bajo `/employees/:employee_id/benefits`
  (se necesita saber de quién es el beneficio al crearlo); `show`/`update`/`destroy` viven en
  `/benefits/:id` (ya identifican el recurso por su propio id).

## Limitaciones conocidas

- Nominatim se consulta solo por nombre de ciudad (tal como pide el enunciado), sin país. Esto
  puede causar ambigüedad: por ejemplo, "Cartagena" puede resolver a Cartagena, España en vez de
  Cartagena, Colombia, si Nominatim la considera más relevante. No se agregó el parámetro de país
  porque el requisito explícitamente pide la búsqueda basada solo en la ciudad.
- El `JWT_SECRET` por defecto es un valor fijo de desarrollo; en un entorno real debe
  sobreescribirse con un secreto propio vía variable de entorno.

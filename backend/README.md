# Backend — Symplifica Dashboard

API REST en Ruby on Rails 8.1 (modo `api_only`) sobre PostgreSQL. Gestiona empleados y sus
beneficios, autentica con JWT y resuelve coordenadas de ciudades contra OpenStreetMap Nominatim.

La documentación completa del proyecto (endpoints, variables de entorno, Docker y decisiones
técnicas) está en el [README raíz](../README.md). Acá va solo lo específico del backend.

## Estructura

```
app/
├── controllers/
│   ├── application_controller.rb   Verificación del JWT en cada request
│   └── api/
│       ├── auth_controller.rb      POST /api/login
│       ├── employees_controller.rb CRUD de empleados
│       └── benefits_controller.rb  CRUD de beneficios
├── lib/json_web_token.rb           Codificación y decodificación del JWT
├── models/                         Employee, Benefit, User
└── services/nominatim_client.rb    Cliente HTTP de OpenStreetMap Nominatim
```

## Puesta en marcha

```bash
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server -p 3000
```

Sin variables de entorno, `config/database.yml` usa el socket local de PostgreSQL con el usuario
del sistema. Si tu PostgreSQL pide usuario y contraseña, definí `DATABASE_HOST`,
`DATABASE_USERNAME` y `DATABASE_PASSWORD` (ver `.env.example`).

## Comandos

```bash
bundle exec rspec         # 32 ejemplos: modelos, requests y el cliente de Nominatim
bin/rubocop               # Estilo (rubocop-rails-omakase)
bin/brakeman --no-pager   # Análisis estático de seguridad
```

Los tres corren en CI en cada push y pull request.

## Autenticación

`ApplicationController` exige el header `Authorization: Bearer <token>` en todos los endpoints
salvo `POST /api/login`, y responde `401` si falta, está mal firmado o venció. Los tokens se
firman con HS256 usando `JWT_SECRET` y expiran a las 24 horas.

Se usa `bcrypt` con `has_secure_password` en vez de Devise: para una API con un solo rol, la
implementación manual es más corta de auditar que configurar Devise + `devise-jwt`.

## Tests

Las llamadas a Nominatim están mockeadas con WebMock y `WebMock.disable_net_connect!`, así que
la suite no depende de la red ni golpea la API pública.

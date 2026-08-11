# Frontend — Symplifica Dashboard

SPA en Vue 3 (`<script setup>`) con Vite, Vue Router, Pinia y Tailwind CSS 4. Consume la API
Rails del directorio [`../backend`](../backend).

La documentación completa del proyecto está en el [README raíz](../README.md).

## Estructura

```
src/
├── components/AppLayout.vue    Layout compartido con logout
├── router/index.js             Rutas y guard de autenticación
├── services/api.js             Cliente Axios: inyecta el Bearer y maneja el 401
├── stores/auth.js              Store de Pinia con el token
└── views/
    ├── Login.vue
    ├── EmployeeList.vue        Listado
    ├── EmployeeDetail.vue      Detalle con beneficios y coordenadas
    └── EmployeeForm.vue        Alta y edición
```

## Puesta en marcha

```bash
cp .env.example .env
npm install
npm run dev          # http://localhost:5173
```

`VITE_API_URL` apunta por defecto a `http://localhost:3000/api`.

## Comandos

```bash
npm run dev          # Servidor de desarrollo
npm test             # 16 tests con Vitest
npm run test:watch   # Vitest en modo watch
npm run build        # Build de producción en dist/
npm run preview      # Sirve el build
```

## Sesión

El token se guarda en `localStorage` y se rehidrata al arrancar, así que la sesión sobrevive a
un refresh. El interceptor de request lo inyecta como `Authorization: Bearer`, y el de response
detecta el `401` de un token vencido para limpiar la sesión y volver al login.

El handler del `401` se registra desde `main.js` con `setUnauthorizedHandler()` en vez de
importar el router dentro de `api.js`, que crearía el ciclo `api → router → store → api`.

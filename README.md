# Rails API Posts - Red Social

Una aplicación Rails API completa que permite a los usuarios crear y comentar posts, con funcionalidades de red social como seguir usuarios, dar likes, notificaciones y más.

## Características

### Autenticación de Usuarios
- ✅ Registro de usuarios (sign up)
- ✅ Inicio de sesión (sign in)
- ✅ Cerrar sesión (sign out)
- ✅ Restablecer contraseña
- ✅ Cambiar email
- ✅ Cambiar contraseña
- ✅ Eliminar cuenta

### Interacciones con Posts
- ✅ Crear posts
- ✅ Comentar en posts
- ✅ Dar like a posts
- ✅ Ver lista de comentarios en un post
- ✅ Ver lista de likes en un post

### Interacciones de Usuario
- ✅ Seguir otros usuarios
- ✅ Ver lista de seguidores
- ✅ Ver lista de usuarios seguidos
- ✅ Ver lista de posts que le gustaron
- ✅ Ver lista de posts que comentó

### Interacciones Sociales
- ✅ Ver posts donde fue mencionado
- ✅ Ver posts donde fue etiquetado

### Notificaciones
- ✅ Ver lista de notificaciones
- ✅ Ver notificaciones leídas
- ✅ Ver notificaciones no leídas
- ✅ Marcar notificación como leída
- ✅ Marcar notificación como no leída

### Feed
- ✅ Ver feed (posts de usuarios seguidos)

### Búsqueda
- ✅ Buscar usuarios por:
  - Nombre
  - Username
  - Email
  - Ubicación
- ✅ Buscar posts por:
  - Contenido
  - Usuario
  - Tags
  - Comentarios
- ✅ Ordenar posts por:
  - Más recientes
  - Más antiguos
  - Más gustados
  - Más comentados
  - Más recientemente comentados
  - Más recientemente gustados

### Configuración
- ✅ Cambiar foto de perfil
- ✅ Cambiar foto de portada
- ✅ Cambiar biografía
- ✅ Cambiar sitio web
- ✅ Cambiar email
- ✅ Cambiar contraseña
- ✅ Eliminar cuenta

## Tecnologías Utilizadas

- **Rails 8.0** - Framework web
- **Ruby 3.4.4** - Lenguaje de programación
- **PostgreSQL** - Base de datos
- **JWT** - Autenticación
- **JBuilder** - Serialización JSON
- **Active Storage** - Almacenamiento de archivos
- **RSpec** - Testing
- **Factory Bot** - Generación de datos de prueba
- **Swagger** - Documentación de API
- **Kaminari** - Paginación
- **pg_search** - Búsqueda en PostgreSQL

## Instalación

1. Clona el repositorio:
```bash
git clone <repository-url>
cd rails_aiposts_no_rules
```

2. Instala las dependencias:
```bash
bundle install
```

3. Configura la base de datos:
```bash
rails db:create
rails db:migrate
```

4. Inicia el servidor:
```bash
rails server
```

La API estará disponible en `http://localhost:3000`

## Documentación de la API

La documentación interactiva de la API está disponible en:
- **Swagger UI**: `http://localhost:3000/api-docs`

## Endpoints Principales

### Autenticación
```
POST /api/v1/auth/signup          # Registro
POST /api/v1/auth/signin          # Inicio de sesión
POST /api/v1/auth/signout         # Cerrar sesión
POST /api/v1/auth/forgot_password # Olvidar contraseña
POST /api/v1/auth/reset_password  # Restablecer contraseña
PUT  /api/v1/auth/change_email    # Cambiar email
DELETE /api/v1/auth/delete_account # Eliminar cuenta
```

### Usuarios
```
GET  /api/v1/users/profile        # Perfil del usuario actual
PUT  /api/v1/users/profile        # Actualizar perfil
GET  /api/v1/users/:id            # Ver perfil de usuario
GET  /api/v1/users/:id/followers  # Seguidores
GET  /api/v1/users/:id/following  # Siguiendo
GET  /api/v1/users/:id/liked_posts # Posts que le gustaron
GET  /api/v1/users/:id/commented_posts # Posts que comentó
GET  /api/v1/users/:id/mentioned_posts # Posts donde fue mencionado
GET  /api/v1/users/:id/tagged_posts # Posts donde fue etiquetado
```

### Posts
```
GET    /api/v1/posts              # Lista de posts
GET    /api/v1/posts/feed         # Feed personalizado
GET    /api/v1/posts/:id          # Ver post específico
POST   /api/v1/posts              # Crear post
PUT    /api/v1/posts/:id          # Actualizar post
DELETE /api/v1/posts/:id          # Eliminar post
POST   /api/v1/posts/:id/like     # Dar like
DELETE /api/v1/posts/:id/like     # Quitar like
GET    /api/v1/posts/:id/likes    # Ver likes del post
GET    /api/v1/posts/:id/comments # Ver comentarios del post
```

### Comentarios
```
GET    /api/v1/comments           # Lista de comentarios
GET    /api/v1/comments/:id       # Ver comentario específico
POST   /api/v1/posts/:post_id/comments # Crear comentario
PUT    /api/v1/comments/:id       # Actualizar comentario
DELETE /api/v1/comments/:id       # Eliminar comentario
```

### Seguir Usuarios
```
POST   /api/v1/users/:user_id/follow      # Seguir usuario
DELETE /api/v1/users/:user_id/follow      # Dejar de seguir
GET    /api/v1/users/:user_id/follow_status # Estado de seguimiento
```

### Notificaciones
```
GET    /api/v1/notifications              # Lista de notificaciones
GET    /api/v1/notifications/read         # Notificaciones leídas
GET    /api/v1/notifications/unread       # Notificaciones no leídas
GET    /api/v1/notifications/:id          # Ver notificación específica
PUT    /api/v1/notifications/:id/mark_read # Marcar como leída
PUT    /api/v1/notifications/:id/mark_unread # Marcar como no leída
PUT    /api/v1/notifications/mark_all_read # Marcar todas como leídas
DELETE /api/v1/notifications/:id          # Eliminar notificación
```

### Búsqueda
```
GET /api/v1/search/users?q=query&by=field # Buscar usuarios
GET /api/v1/search/posts?q=query&by=field&sort=order # Buscar posts
```

### Imágenes
```
POST   /api/v1/images/profile_picture     # Subir foto de perfil
POST   /api/v1/images/cover_picture       # Subir foto de portada
DELETE /api/v1/images/profile_picture     # Eliminar foto de perfil
DELETE /api/v1/images/cover_picture       # Eliminar foto de portada
```

## Autenticación

La API utiliza JWT (JSON Web Tokens) para la autenticación. Incluye el token en el header `Authorization`:

```
Authorization: Bearer <your-jwt-token>
```

## Ejemplo de Uso

### 1. Registro
```bash
curl -X POST http://localhost:3000/api/v1/auth/signup \
  -H "Content-Type: application/json" \
  -d '{
    "first_name": "Juan",
    "last_name": "Pérez",
    "username": "juanperez",
    "email": "juan@example.com",
    "password": "password123"
  }'
```

### 2. Inicio de sesión
```bash
curl -X POST http://localhost:3000/api/v1/auth/signin \
  -H "Content-Type: application/json" \
  -d '{
    "email": "juan@example.com",
    "password": "password123"
  }'
```

### 3. Crear un post
```bash
curl -X POST http://localhost:3000/api/v1/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your-jwt-token>" \
  -d '{
    "content": "¡Hola mundo! Mi primer post.",
    "tags": "hola, mundo, primer-post"
  }'
```

## Testing

Ejecuta los tests con:

```bash
# Todos los tests
bundle exec rspec

# Tests específicos
bundle exec rspec spec/models/
bundle exec rspec spec/requests/
```

## Herramientas de Desarrollo

- **Rubocop**: Análisis de código
```bash
bundle exec rubocop
```

- **Brakeman**: Análisis de seguridad
```bash
bundle exec brakeman
```

## Estructura de la Base de Datos

### Usuarios (Users)
- first_name, last_name, username, email, password_digest
- bio, website, location
- profile_picture, cover_picture (Active Storage)

### Posts
- content, tags
- user_id (referencia a User)

### Comentarios (Comments)
- content
- user_id, post_id (referencias)

### Likes
- user_id, post_id (referencias)

### Follows
- follower_id, following_id (referencias a User)

### Notificaciones (Notifications)
- title, content, read
- user_id, notifiable (polimórfico)

## Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

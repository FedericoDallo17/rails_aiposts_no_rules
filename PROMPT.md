# 🚀 Full Social App Prompt (Rails 8 + React + PostgreSQL)

## 🎯 Goal

Build a **complete social media app** (Rails 8 backend + React frontend) where users can create posts, comment, like, follow, search, and receive notifications — with authentication, documentation, and testing.

The assistant must **not stop until the entire app is complete**, including documentation, testing, and CI.

---

## 🧩 Functional Requirements

### 🧑‍💻 Authentication & Account Management
- User sign up, sign in, and sign out
- Password reset via email
- Change email (with verification)
- Change password
- Delete account (with confirmation)
- JWT-based authentication with refresh tokens
- Basic rate limiting for sensitive endpoints

### 📝 Posts & Interactions
- Create, edit, and delete posts (only by author)
- Add comments to posts (CRUD by author)
- Like/unlike posts
- View list of comments and likes for a post
- Mentions (`@username`) and tags (`#tag`) detection in posts

### 👥 Social Features
- Follow/unfollow other users
- View followers and following lists
- View posts the user:
  - Liked
  - Commented on
  - Was mentioned in
  - Was tagged in

### 🔔 Notifications
- Types: new follower, like, comment, mention
- List all, read, and unread notifications
- Mark notifications as read/unread
- **Real-time notifications** via WebSocket (ActionCable)

### 📰 Feed
- Feed of posts from followed users
- Support pagination and "load newer" posts by timestamp or ID

### 🔍 Search & Sorting
- Search **users** by: name, username, email, location
- Search **posts** by: content, author, tags, or comments
- Sort posts by:
  - Newest
  - Oldest
  - Most liked
  - Most commented
  - Most recently commented
  - Most recently liked

### ⚙️ Profile Settings
- Change profile picture (Active Storage)
- Change cover picture (Active Storage)
- Edit bio, website, and location
- Change email and password
- Delete account

---

## 🛠️ Technical Requirements

- **Backend:** Rails 8.0
- **Ruby version:** 3.4.4 (already installed)
- **Database:** PostgreSQL
- **Serialization:** JBuilder
- **Authentication:** Devise + devise-jwt
- **Background jobs:** Active Job (Sidekiq)
- **Storage:** Active Storage (local + S3 ready)
- **Real-time:** Action Cable (Redis)
- **Docs:** Swagger (RSwag)
- **Security:** Brakeman
- **Linting:** RuboCop
- **Testing:** RSpec + FactoryBot + Faker + shoulda-matchers + SimpleCov
- **Seed data:** realistic users, posts, comments, likes, follows, notifications
- **CI/CD:** GitHub Actions (lint + test + brakeman)
- **Docker:** optional, with `docker-compose.yml` and `Dockerfile`

---

## 🧱 Database Schema

### Users
| Field | Type |
|-------|------|
| first_name | string |
| last_name | string |
| username | string (unique, indexed) |
| email | string (unique, indexed) |
| encrypted_password | string |
| bio | text |
| website | string |
| location | string |
| profile_picture | Active Storage |
| cover_picture | Active Storage |

### Posts
| Field | Type |
|-------|------|
| user_id | reference |
| content | text |
| tags | string[] |
| likes_count | integer (counter cache) |
| comments_count | integer (counter cache) |

### Comments
| Field | Type |
|-------|------|
| user_id | reference |
| post_id | reference |
| content | text |

### Likes
| Field | Type |
|-------|------|
| user_id | reference |
| post_id | reference |
| Unique index | (user_id, post_id) |

### Follows
| Field | Type |
|-------|------|
| follower_id | reference(User) |
| followed_id | reference(User) |
| Unique index | (follower_id, followed_id) |

### Notifications
| Field | Type |
|-------|------|
| user_id | reference |
| notifiable_type | string |
| notifiable_id | integer |
| event_type | enum |
| read_at | datetime |

---

## 📚 Backend Architecture

```
/server
  ├── app/
  │   ├── models/
  │   ├── controllers/api/v1/
  │   ├── services/
  │   ├── jobs/
  │   ├── channels/
  │   └── views/api/v1/
  ├── spec/
  ├── config/
  ├── db/migrate/
  ├── docs/
  └── README.md
```

### Key Components
- **Devise JWT Auth**
- **Rack::Attack** (rate limiting)
- **PgSearch** or native PostgreSQL FTS
- **Swagger docs at `/api-docs`**
- **Namespace:** all API routes under `/api/v1`
- **Background jobs:** notifications, mention parsing, etc.

---

## 💻 Frontend Requirements

- **Stack:** React + TypeScript + Vite + React Router + Tailwind CSS
- **State management:** Zustand
- **Data fetching:** React Query
- **Authentication:** JWT (in-memory or secure HttpOnly cookies)
- **Real-time:** Action Cable WebSocket client
- **File uploads:** Direct to Active Storage
- **Error handling:** global toast notifications

### Pages
1. Login / Register / Password Reset
2. Feed
3. Post Detail
4. Search (users and posts)
5. Profile (own and others)
6. Edit Profile / Settings
7. Notifications

---

## 🌐 API Endpoints Summary

### Auth
- `POST /api/v1/auth/sign_up`
- `POST /api/v1/auth/sign_in`
- `POST /api/v1/auth/refresh`
- `DELETE /api/v1/auth/sign_out`
- `POST /api/v1/auth/password/forgot`
- `POST /api/v1/auth/password/reset`

### Posts
- `GET /api/v1/posts`
- `POST /api/v1/posts`
- `GET /api/v1/posts/:id`
- `PUT /api/v1/posts/:id`
- `DELETE /api/v1/posts/:id`
- `POST /api/v1/posts/:id/like`
- `DELETE /api/v1/posts/:id/like`
- `GET /api/v1/posts/:id/comments`
- `POST /api/v1/posts/:id/comments`

### Social
- `POST /api/v1/users/:id/follow`
- `DELETE /api/v1/users/:id/follow`
- `GET /api/v1/users/:id/followers`
- `GET /api/v1/users/:id/following`
- `GET /api/v1/me/likes`
- `GET /api/v1/me/comments`
- `GET /api/v1/me/mentions`
- `GET /api/v1/me/tagged`

### Feed
- `GET /api/v1/feed`

### Search
- `GET /api/v1/search/users?q=...`
- `GET /api/v1/search/posts?q=...&by=content|user|tags|comments&sort=...`

### Notifications
- `GET /api/v1/notifications`
- `GET /api/v1/notifications?status=read|unread`
- `POST /api/v1/notifications/:id/read`
- `POST /api/v1/notifications/:id/unread`

---

## ✅ Quality & Security

- Strong validations on all models
- Full-text search (PostgreSQL `tsvector`)
- GIN and trigram indexes
- Eager loading to prevent N+1
- Pagination using `pagy` or `kaminari`
- Sanitization for user content
- CORS restricted to frontend origin
- Environment variables managed via `.env` and `.env.example`

---

## 📦 Deliverables

- Fully functional Rails API
- React frontend connected to API
- Seed data for testing
- Complete Swagger documentation
- GitHub Actions pipeline
- Brakeman + RuboCop + RSpec green
- README with setup, env vars, seeds, and run instructions
- Optional Docker setup
- `Makefile` or bin scripts for common tasks:
  - `make setup`
  - `make up`
  - `make lint`
  - `make test`
  - `make seed`
  - `make docs`

---

## 🧾 Documentation

- `README.md` (setup, usage, env, tests)
- `/docs/OPENAPI.md` — generated by RSwag
- `/docs/ADR.md` — architectural decisions
- `/docs/POSTMAN_COLLECTION.json` — optional
- Inline comments where logic is complex

---

## 🔄 Development Workflow (Cursor should follow this sequence)

1. Initialize monorepo with `/server` (Rails) and `/web` (React)
2. Configure all dependencies and gems
3. Define models, migrations, indexes, enums
4. Implement authentication with JWT
5. Add background jobs and Action Cable
6. Build controllers and JBuilder views
7. Write RSpec tests for all major endpoints
8. Generate Swagger documentation
9. Implement frontend (React + Tailwind)
10. Integrate API calls and JWT handling
11. Implement WebSocket notifications
12. Seed realistic data
13. Lint and run security checks
14. Finalize README and documentation
15. Push CI-ready code

---

## ✅ Acceptance Criteria

- All endpoints exist and pass RSpec tests
- Swagger docs accessible at `/api-docs`
- JWT auth works with refresh tokens
- Real-time notifications functional
- Search, sort, and feed performant
- React frontend fully functional end-to-end
- CI pipeline (RuboCop, Brakeman, RSpec) is green
- Seeds provide realistic demo data
- Documentation is complete and readable

---

> ⚠️ **Important:**  
> Do not stop until the **entire app is complete**, including backend, frontend, documentation, seeds, and CI.  
> Use the **most standard and secure** approaches for Rails 8, PostgreSQL, and React.  
> Explain architectural decisions briefly in `/docs/ADR.md`.

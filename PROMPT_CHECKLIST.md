# ✅ Build Checklist: Full Social App (Rails 8 + React + PostgreSQL)

> Paste this alongside `PROMPT.md`. Cursor should tick each task before moving on.

## 0) Repo & Tooling
- [ ] Initialize monorepo: `/server` (Rails API) and `/web` (React)
- [ ] Add `.ruby-version` (3.4.4) and `.tool-versions` (optional asdf)
- [ ] Add `.editorconfig`, `.gitignore`, `.gitattributes`
- [ ] Add `README.md` skeleton and `/docs` folder
- [ ] Add `Makefile` or `bin/` scripts

## 1) Backend Bootstrap
- [ ] `rails new server --api -d postgresql --skip-javascript --skip-hotwire`
- [ ] Gems: devise, devise-jwt, rswag, jbuilder, sidekiq, redis, rack-attack, pg_search, dotenv-rails, rubocop, brakeman, rspec-rails, factory_bot_rails, faker, shoulda-matchers, simplecov, pagy/kaminari
- [ ] Configure RuboCop + Brakeman
- [ ] Configure RSpec + SimpleCov
- [ ] Configure Rack::Attack (rate limiting)
- [ ] Configure CORS (restrict to frontend origin)
- [ ] Configure environments & `.env.example` (DB, Redis, JWT, Mailer)

## 2) Auth & Accounts
- [ ] Install Devise & devise-jwt
- [ ] User model with username (unique), email (unique), first/last name, bio, website, location
- [ ] Auth controllers: sign_up, sign_in, refresh, sign_out
- [ ] Password reset (mailer), change email (confirmation), change password
- [ ] Delete account (confirmation)
- [ ] JWT + refresh token strategy
- [ ] Request specs for all auth endpoints

## 3) Files & Background
- [ ] Active Storage setup (local + S3 ready)
- [ ] Direct upload support (if applicable)
- [ ] Active Job + Sidekiq + Redis
- [ ] Mailer previews
- [ ] Basic image validations (type/size)

## 4) Domain Models & Migrations
- [ ] Users (indexes: username, email; case-insensitive search helpers)
- [ ] Posts (content, tags:string[], counters)
- [ ] Comments (content)
- [ ] Likes (unique [user_id, post_id])
- [ ] Follows (unique [follower_id, followed_id])
- [ ] Notifications (polymorphic, event_type enum, read_at)
- [ ] Extensions: pg_trgm + FTS (tsvector), GIN indexes
- [ ] Counter caches + foreign keys
- [ ] Seeds with realistic data

## 5) Services & Policies
- [ ] Mention extraction service (`@username`) + persistence (optional Mention model)
- [ ] Notification builder service (like/comment/follow/mention)
- [ ] Authorization policies (Pundit or custom) for ownership checks

## 6) Controllers & Views (API v1)
- [ ] Namespaced routes under `/api/v1`
- [ ] Posts: CRUD, likes, list comments, pagination, sorting
- [ ] Comments: CRUD
- [ ] Social: follow/unfollow, followers/following
- [ ] Me: likes, comments, mentions, tagged
- [ ] Feed endpoint (cursor or timestamp pagination)
- [ ] Search users & posts (by content/author/tags/comments)
- [ ] JBuilder responses + serializers
- [ ] Eager loading to avoid N+1
- [ ] Request specs for all endpoints

## 7) Real-time
- [ ] Action Cable setup with Redis
- [ ] `NotificationsChannel` (stream by user_id)
- [ ] Broadcast on like/comment/follow/mention
- [ ] Auth guard for channel subscriptions
- [ ] System tests (channel broadcast basics)

## 8) API Documentation
- [ ] RSwag setup
- [ ] Define schemas and examples
- [ ] Document all endpoints (2xx, 4xx, 5xx)
- [ ] Publish at `/api-docs`
- [ ] Export `/docs/OPENAPI.md`

## 9) Frontend Bootstrap
- [ ] `web`: Vite + React + TypeScript + Tailwind + React Router
- [ ] Project structure (pages, components, lib, hooks, stores)
- [ ] Zustand for auth/UI state
- [ ] React Query for server state
- [ ] API client with interceptors (JWT + refresh)
- [ ] Action Cable client (websocket URL via env)

## 10) Frontend Features
- [ ] Auth pages (login, register, forgot/reset)
- [ ] Feed page (infinite/paged)
- [ ] Post detail: view, like/unlike, comments
- [ ] Search page (users + posts)
- [ ] Profile pages (self + others)
- [ ] Settings page (profile picture, cover, bio, website, location, email, password)
- [ ] Notifications page (read/unread, mark as read/unread)
- [ ] Direct uploads to Active Storage
- [ ] Toasts + error boundaries

## 11) Quality Gates & CI
- [ ] GitHub Actions: RuboCop + Brakeman + RSpec
- [ ] Coverage threshold (e.g., 90%)
- [ ] Lint and security must pass on PRs
- [ ] README finalized with setup/run/test instructions
- [ ] `/docs/ADR.md` with key decisions
- [ ] Optional Docker (`docker-compose.yml`) for server, web, db, redis, sidekiq

## 12) Acceptance Review
- [ ] End-to-end flow: sign up → create post → like/comment → follow → receive notification (real-time)
- [ ] Swagger `/api-docs` matches implementation
- [ ] Search/sort performant with indexes
- [ ] Seeds demonstrate all features
- [ ] All CI checks green

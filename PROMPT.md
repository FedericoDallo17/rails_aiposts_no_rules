# Build the Full AIPosts Application

I want to create a **complete social app** (backend + frontend) that allows users to create, comment on, and interact with posts.
You will build a **new Rails 8.0 API** as the backend and a **modern JavaScript frontend** (React, Vite, or Next.js).
Both parts must work together seamlessly.

The backend will expose RESTful endpoints.
The frontend will consume them and implement all required features.
Implement all features, tests, and documentation described below.

---

## Features and Requirements

### 🧩 User Authentication
Users must be able to:
- Sign up
- Sign in
- Sign out
- Reset their password
- Change their email
- Change their password
- Delete their account

Authentication must use secure token or session handling aligned with an API architecture.
Validate inputs and return clear error messages.

---

### 📝 Post Interactions
Users must be able to:
- Create a post
- Edit their own posts
- Delete their own posts
- Comment on a post
- Like a post
- Like a comment
- Repost another user's post (share it to their feed)
- See the list of comments on a post
- See the list of likes on a post
- See the list of likes on a comment
- See the list of reposts of a post

Each post should include text content, optional tags, and an author reference.
Each comment should include text content and references to its author and post.
Each like should reference the user and the liked entity (post or comment).
Each repost should reference the original post and the user who reposted it.

---

### 👥 User Interactions
Users must be able to:
- Follow and unfollow other users
- View the list of followers
- View the list of people they are following
- View the list of posts they liked
- View the list of posts they commented on

---

### 💬 Social Interactions
Users must be able to:
- See the list of posts they are mentioned in
- See the list of posts they are tagged in

Mentions should be detected when content includes “@username”.
Tags may be manually added when creating a post.

---

### 🔔 Notifications
Users must be able to:
- See all their notifications
- See which notifications are read or unread
- Mark notifications as read
- Mark notifications as unread

Notifications should be generated for:
- New follower
- New comment on a user’s post
- New like on a user’s post
- New like on a user’s comment
- Being mentioned or tagged in a post
- A repost of their post

Each notification should include the triggering user, an event type, and a link to the relevant resource.

---

### 📰 Feed
Users must be able to:
- See their feed, which includes posts from users they follow
- See reposts from users they follow
- View items sorted by newest first
- See author info and counts (likes, comments, reposts) per item

---

### 🔎 Search
Users must be able to search for both **users** and **posts**.

#### Search Users By:
- Name
- Username
- Email
- Location

#### Search Posts By:
- Content
- User
- Tags
- Comments

#### Sorting Options for Posts:
- Newest
- Oldest
- Most liked
- Most commented
- Most recently commented
- Most recently liked

---

### ⚙️ Settings
Users must be able to:
- Change profile picture
- Change cover picture
- Change bio
- Change website
- Change email
- Change password
- Delete their account

---

## 🧱 Database Schema (excluding IDs and timestamps)

**Users**
- first_name
- last_name
- profile_picture
- cover_picture
- bio
- website
- location
- username
- email
- password_digest

**Posts**
- content
- tags

**Comments**
- content

**Likes**
- can belong to either a Post or a Comment

**Reposts**
- user_id
- post_id

**Follows**
- follower_id
- followed_id

**Notifications**
- message
- notification_type
- read_at
- user_id
- actor_id

All models must include appropriate associations, validations, and indexes where appropriate.

---

## 🧰 Technical Requirements

### Backend (Rails 8.0 API)
- Ruby 3.4.4 (already installed)
- Rails 8.0 in API mode
- PostgreSQL
- Active Storage for file uploads (profile and cover pictures)
- Active Job for background processing (e.g., notifications)
- JBuilder for JSON views
- Swagger for API documentation
- RSpec and FactoryBot for testing
- RuboCop for linting
- Brakeman for security scanning

The backend must expose RESTful endpoints for all features, provide pagination for lists, handle authentication/authorization, and return structured JSON responses with proper error handling.

### Frontend (React / Vite / Next.js)
- Consume all Rails API endpoints
- Implement all functional features
- Use TailwindCSS or similar for styling
- Use client-side routing
- Manage auth tokens (login, logout, session persistence)
- Include pages for feed, profiles, post details, settings, notifications, and search
- Handle loading and error states

---

## 🧪 Testing
- RSpec tests for backend models, controllers, and request specs
- FactoryBot factories for test data
- Frontend tests (Jest/Vitest) for critical user flows
- Tests for authentication, posts, comments, likes (posts and comments), reposts, and search

---

## 📘 Documentation
- Generate Swagger documentation covering all endpoints
- Include authentication details and example requests/responses
- Provide a `README.md` explaining:
  - How to run the Rails API
  - How to run the frontend
  - Required environment variables
  - How to run tests and linters
  - Deployment notes

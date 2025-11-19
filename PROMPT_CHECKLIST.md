# ✅ AIPosts Development Checklist

This checklist defines the full scope of work required to complete the AIPosts app.

---

## 🧩 Setup
- [x] Initialize a new Rails 8.0 API project (Ruby 3.4.4, PostgreSQL).
- [x] Add and configure required gems: Devise, JBuilder, Swagger, RSpec, FactoryBot, RuboCop, Brakeman.
- [x] Configure database and environment files.
- [x] Create and migrate the database.
- [x] Initialize Git and commit base project setup.
- [x] Initialize frontend (React, Vite, or Next.js).
- [x] Connect frontend to backend API (environment variables, base URL).

## 👤 User Authentication
- [x] User can sign up.
- [x] User can sign in.
- [x] User can sign out.
- [x] User can reset their password.
- [x] User can change their email.
- [x] User can change their password.
- [x] User can delete their account.
- [x] Proper authentication tokens or sessions are used.
- [x] RSpec tests for all auth actions.
- [x] Swagger docs for auth endpoints.

## 📝 Posts
- [x] User can create a post.
- [x] User can edit their own posts.
- [x] User can delete their own posts.
- [x] Post includes content and tags.
- [x] Posts validated for content presence.
- [x] RSpec tests for post CRUD.
- [x] JSON output includes author, content, tags.
- [x] Swagger docs for post endpoints.

## 💬 Comments
- [x] User can comment on a post.
- [x] User can view all comments on a post.
- [x] User can like a comment.
- [x] Comment likes count is included where relevant.
- [x] RSpec tests for comments and comment likes.
- [x] Swagger docs for comments and comment likes.

## ❤️ Likes
- [x] User can like/unlike a post.
- [x] User can like/unlike a comment.
- [x] Each like references a user and a target entity.
- [x] User can see all likes on a post.
- [x] User can see all likes on a comment.
- [x] RSpec tests for like actions.
- [x] Swagger docs for likes.

## 🔁 Reposts
- [x] User can repost another user's post.
- [x] Reposted posts appear in the feed.
- [x] Original author is credited in reposts.
- [x] Reposts have list and toggle endpoints.
- [x] RSpec tests for reposts.
- [x] Swagger docs for reposts.

## 👥 Follows
- [x] User can follow/unfollow another user.
- [x] User can view followers.
- [x] User can view following.
- [x] Feed is based on followed users.
- [x] RSpec tests for follow relationships.
- [x] Swagger docs for follows.

## 🔔 Notifications
- [x] Notifications created for: new follower, new comment, likes on posts/comments, mentions/tags, reposts.
- [x] User can see all notifications.
- [x] User can mark notifications as read/unread.
- [x] Notifications indicate type and related resource.
- [x] RSpec tests for notifications.
- [x] Swagger docs for notifications.

## 📰 Feed
- [x] User sees posts from followed users.
- [x] Feed also includes reposts by followed users.
- [x] Feed sorted by newest first.
- [x] Feed shows counts (likes, comments, reposts).
- [x] RSpec tests for feed generation.
- [x] Swagger docs for feed endpoint.

## 🔎 Search
- [x] Search users by name, username, email, location.
- [x] Search posts by content, author, tags, comments.
- [x] Sorting supports newest, oldest, most liked, most commented, most recently commented, most recently liked.
- [x] RSpec tests for search.
- [x] Swagger docs for search endpoints.

## ⚙️ Settings
- [x] Update profile picture.
- [x] Update cover picture.
- [x] Update bio.
- [x] Update website.
- [x] Update email.
- [x] Update password.
- [x] Delete account.
- [x] RSpec tests for settings.
- [x] Swagger docs for settings endpoints.

## 🧩 Frontend Features
- [x] Implement UI (React/Vite/Next.js).
- [x] Pages: Auth (Sign up / Sign in / Reset), Feed, Profile, Post details, Settings, Notifications, Search.
- [x] Display dynamic counts and states.
- [x] Display reposted posts in feed.
- [x] Manage auth tokens securely.
- [x] Handle error, loading, and empty states.
- [x] `npm run build` passes without warnings.

## 🧪 Testing and Quality
- [x] RSpec: all backend tests pass.
- [x] Jest/Vitest: all frontend tests pass.
- [x] RuboCop: no offenses remain.
- [x] Brakeman: no critical warnings remain.
- [x] Swagger: all endpoints documented with examples.

## 📘 Documentation
- [x] Generate Swagger API docs for all controllers.
- [x] Write `README.md` with setup, environment variables, testing, and deployment notes.
- [x] Include instructions for running tests and linters.
- [x] Verify that all checkboxes above are `[x]` before finishing.

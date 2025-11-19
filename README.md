# AIPosts - Full-Stack Social Media Application

A complete social media platform with a Rails 8.0 API backend and a React frontend, featuring posts, comments, likes, reposts, follows, notifications, and search functionality.

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [Testing](#testing)
- [API Documentation](#api-documentation)
- [Project Structure](#project-structure)
- [Deployment](#deployment)

## ✨ Features

### User Authentication
- Sign up / Sign in / Sign out
- Password change and reset
- Email change
- Account deletion
- JWT-based token authentication

### Posts
- Create, edit, and delete posts
- Add tags to posts
- Like/unlike posts
- Repost functionality
- View post details with comments
- Mention users with @username

### Comments
- Comment on posts
- Like/unlike comments
- View all comments on a post
- Delete your own comments

### Social Features
- Follow/unfollow users
- View followers and following lists
- Personalized feed showing posts from followed users
- View user profiles with stats

### Notifications
- Real-time notifications for:
  - New followers
  - Comments on your posts
  - Likes on posts/comments
  - Mentions in posts
  - Reposts of your content
- Mark notifications as read/unread
- Mark all notifications as read

### Search
- Search users by name, username, email, or location
- Search posts by content, tags, or author
- Multiple sorting options:
  - Newest/Oldest
  - Most liked
  - Most commented
  - Most recently commented/liked

### Settings
- Update profile information (name, bio, website, location)
- Upload profile and cover pictures
- Change email and password
- Delete account

## 🛠 Tech Stack

### Backend
- **Ruby** 3.4.4
- **Rails** 8.0 (API mode)
- **PostgreSQL** database
- **JWT** for authentication
- **Active Storage** for file uploads
- **Kaminari** for pagination
- **RSpec** and **FactoryBot** for testing
- **RuboCop** for linting
- **Brakeman** for security scanning
- **Rswag** for API documentation (Swagger)

### Frontend
- **React** 18
- **Vite** for build tooling
- **React Router** for navigation
- **Axios** for API requests
- **TailwindCSS** for styling

## 📦 Prerequisites

- Ruby 3.4.4
- Node.js (v21+ recommended)
- PostgreSQL
- npm or yarn

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd rails_aiposts_no_rules
```

### 2. Backend Setup

```bash
cd backend

# Install dependencies
bundle install

# Setup database
rails db:create
rails db:migrate
rails db:seed  # Optional: seed with sample data

# Run tests to verify setup
bundle exec rspec
```

### 3. Frontend Setup

```bash
cd frontend

# Install dependencies
npm install
```

## ⚙️ Configuration

### Backend Environment Variables

The backend uses Rails credentials. For development, the default configuration should work. For production, set:

- `SECRET_KEY_BASE` - Rails secret key
- `DATABASE_URL` - PostgreSQL connection string
- `BACKEND_DATABASE_PASSWORD` - Database password for production

### Frontend Environment Variables

Create a `.env` file in the `frontend` directory:

```env
VITE_API_BASE_URL=http://localhost:3001/api/v1
```

For production, update the URL to your deployed backend URL.

## 🏃 Running the Application

### Backend (Rails API)

```bash
cd backend

# Start the Rails server (port: 3001)
rails server

# The server will start on port 3001 as configured in config/puma.rb
```

The API will be available at `http://localhost:3001`

### Frontend (React)

```bash
cd frontend

# Start the development server (port: 5174)
npm run dev

# Access the app at http://localhost:5174
```

## 🧪 Testing

### Backend Tests

```bash
cd backend

# Run all RSpec tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/user_spec.rb

# Run with coverage
bundle exec rspec --format documentation

# Run linter
bundle exec rubocop

# Run security scanner
bundle exec brakeman
```

### Frontend Tests

```bash
cd frontend

# Run tests (when implemented)
npm test

# Build for production
npm run build

# Preview production build
npm run preview
```

## 📚 API Documentation

### Swagger Documentation

The API is fully documented with Swagger. After starting the backend server, visit:

```
http://localhost:3001/api-docs
```

This provides:
- Interactive API explorer
- Request/response schemas
- Authentication details
- Example requests

### Key API Endpoints

#### Authentication
- `POST /api/v1/auth/sign_up` - Create new account
- `POST /api/v1/auth/sign_in` - Sign in
- `POST /api/v1/auth/change_password` - Change password
- `POST /api/v1/auth/change_email` - Change email
- `DELETE /api/v1/auth/delete_account` - Delete account

#### Posts
- `GET /api/v1/posts` - List all posts
- `GET /api/v1/posts/:id` - Get specific post
- `POST /api/v1/posts` - Create post (authenticated)
- `PATCH /api/v1/posts/:id` - Update post (authenticated)
- `DELETE /api/v1/posts/:id` - Delete post (authenticated)

#### Comments
- `GET /api/v1/posts/:post_id/comments` - Get post comments
- `POST /api/v1/posts/:post_id/comments` - Create comment (authenticated)
- `DELETE /api/v1/comments/:id` - Delete comment (authenticated)

#### Likes
- `POST /api/v1/posts/:post_id/likes` - Like post
- `DELETE /api/v1/posts/:post_id/likes` - Unlike post
- `POST /api/v1/comments/:comment_id/likes` - Like comment
- `DELETE /api/v1/comments/:comment_id/likes` - Unlike comment

#### Follows
- `POST /api/v1/users/:user_id/follow` - Follow user
- `DELETE /api/v1/users/:user_id/follow` - Unfollow user
- `GET /api/v1/users/:user_id/followers` - Get followers
- `GET /api/v1/users/:user_id/following` - Get following

#### Feed & Search
- `GET /api/v1/feed` - Get personalized feed
- `GET /api/v1/search/users?q=query` - Search users
- `GET /api/v1/search/posts?q=query&sort_by=newest` - Search posts

#### Notifications
- `GET /api/v1/notifications` - Get all notifications
- `GET /api/v1/notifications/unread` - Get unread notifications
- `PATCH /api/v1/notifications/:id/mark_as_read` - Mark as read
- `PATCH /api/v1/notifications/mark_all_as_read` - Mark all as read

## 📁 Project Structure

```
rails_aiposts_no_rules/
├── backend/                 # Rails API
│   ├── app/
│   │   ├── controllers/    # API controllers
│   │   ├── models/         # ActiveRecord models
│   │   └── views/          # JBuilder JSON views (if any)
│   ├── config/             # Rails configuration
│   ├── db/                 # Database migrations and schema
│   ├── lib/                # Custom libraries (JWT helper)
│   ├── spec/               # RSpec tests
│   │   ├── factories/      # FactoryBot factories
│   │   ├── models/         # Model specs
│   │   ├── requests/       # Request specs
│   │   └── swagger/        # Swagger API specs
│   └── swagger/            # Generated Swagger docs
│
├── frontend/               # React application
│   ├── src/
│   │   ├── components/    # Reusable React components
│   │   ├── contexts/      # React contexts (Auth)
│   │   ├── pages/         # Page components
│   │   ├── services/      # API service layer
│   │   └── App.jsx        # Main application component
│   └── public/            # Static assets
│
├── PROMPT.md              # Original project requirements
├── PROMPT_CHECKLIST.md    # Development checklist
└── README.md              # This file
```

## 🚢 Deployment

### Backend Deployment

The Rails API can be deployed to any platform that supports Ruby applications:

#### Heroku
```bash
# From backend directory
heroku create your-app-name
heroku addons:create heroku-postgresql:mini
git push heroku main
heroku run rails db:migrate
```

#### Render / Railway
- Connect your GitHub repository
- Select the `backend` directory as the root
- Set build command: `bundle install && rails db:migrate`
- Set start command: `rails server -b 0.0.0.0`

### Frontend Deployment

The React app can be deployed to static hosting platforms:

#### Vercel / Netlify
```bash
# From frontend directory
npm run build

# Deploy the dist/ directory
```

Update the `.env` file with your production backend URL before building.

### Environment Variables for Production

**Backend:**
- `RAILS_ENV=production`
- `SECRET_KEY_BASE` (generate with `rails secret`)
- `DATABASE_URL` (provided by hosting platform)

**Frontend:**
- `VITE_API_BASE_URL` (your production API URL)

## 🔐 Security Features

- Secure password hashing with bcrypt
- JWT-based authentication
- CORS configuration for cross-origin requests
- SQL injection protection (ActiveRecord)
- XSS protection
- CSRF protection (for cookie-based auth)
- Input validation on all endpoints
- Authorization checks for user-owned resources

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is open source and available under the MIT License.

## 🐛 Known Issues / Future Enhancements

- [ ] Add real-time notifications with ActionCable
- [ ] Implement password reset email flow
- [ ] Add image preview for posts
- [ ] Implement infinite scroll for feeds
- [ ] Add analytics dashboard
- [ ] Implement rate limiting
- [ ] Add caching layer (Redis)
- [ ] Implement direct messaging
- [ ] Add mobile app support

## 📧 Contact

For questions or support, please open an issue in the repository.

---

Built with ❤️ using Rails 8.0 and React

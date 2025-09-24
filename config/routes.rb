Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  namespace :api do
    namespace :v1 do
      # Authentication routes
      post "auth/signup", to: "authentication#signup"
      post "auth/signin", to: "authentication#signin"
      post "auth/signout", to: "authentication#signout"
      post "auth/forgot_password", to: "authentication#forgot_password"
      post "auth/reset_password", to: "authentication#reset_password"
      put "auth/change_email", to: "authentication#change_email"
      delete "auth/delete_account", to: "authentication#delete_account"

      # User routes
      get "users/profile", to: "users#profile"
      put "users/profile", to: "users#update_profile"
      get "users/:id", to: "users#show"
      get "users/:id/followers", to: "users#followers"
      get "users/:id/following", to: "users#following"
      get "users/:id/liked_posts", to: "users#liked_posts"
      get "users/:id/commented_posts", to: "users#commented_posts"
      get "users/:id/mentioned_posts", to: "users#mentioned_posts"
      get "users/:id/tagged_posts", to: "users#tagged_posts"

      # Follow routes
      post "users/:user_id/follow", to: "follows#create"
      delete "users/:user_id/follow", to: "follows#destroy"
      get "users/:user_id/follow_status", to: "follows#follow_status"

      # Post routes
      get "posts", to: "posts#index"
      get "posts/feed", to: "posts#feed"
      get "posts/:id", to: "posts#show"
      post "posts", to: "posts#create"
      put "posts/:id", to: "posts#update"
      delete "posts/:id", to: "posts#destroy"
      post "posts/:id/like", to: "posts#like"
      delete "posts/:id/like", to: "posts#unlike"
      get "posts/:id/likes", to: "posts#likes"
      get "posts/:id/comments", to: "posts#comments"

      # Comment routes
      get "comments", to: "comments#index"
      get "comments/:id", to: "comments#show"
      post "posts/:post_id/comments", to: "comments#create"
      put "comments/:id", to: "comments#update"
      delete "comments/:id", to: "comments#destroy"

      # Notification routes
      get "notifications", to: "notifications#index"
      get "notifications/read", to: "notifications#read"
      get "notifications/unread", to: "notifications#unread"
      get "notifications/:id", to: "notifications#show"
      put "notifications/:id/mark_read", to: "notifications#mark_read"
      put "notifications/:id/mark_unread", to: "notifications#mark_unread"
      put "notifications/mark_all_read", to: "notifications#mark_all_read"
      delete "notifications/:id", to: "notifications#destroy"

      # Search routes
      get "search/users", to: "search#users"
      get "search/posts", to: "search#posts"

      # Image routes
      post "images/profile_picture", to: "images#upload_profile_picture"
      post "images/cover_picture", to: "images#upload_cover_picture"
      delete "images/profile_picture", to: "images#delete_profile_picture"
      delete "images/cover_picture", to: "images#delete_cover_picture"
    end
  end

  # Root path
  root "rails/health#show"
end

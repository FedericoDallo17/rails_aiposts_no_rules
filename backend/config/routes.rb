Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes
  namespace :api do
    namespace :v1 do
      # Authentication
      post "auth/sign_up", to: "authentication#sign_up"
      post "auth/sign_in", to: "authentication#sign_in"
      post "auth/change_password", to: "authentication#change_password"
      post "auth/change_email", to: "authentication#change_email"
      delete "auth/delete_account", to: "authentication#delete_account"

      # Users
      resources :users, only: [ :index, :show ] do
        member do
          get "posts"
          get "liked_posts"
          get "commented_posts"
          get "followers", to: "follows#followers"
          get "following", to: "follows#following"
          post "follow", to: "follows#create"
          delete "follow", to: "follows#destroy"
        end
        collection do
          patch "update_profile"
          patch "update_profile_picture"
          patch "update_cover_picture"
        end
      end

      # Posts
      resources :posts do
        resources :comments, only: [ :index, :create ]
        member do
          post "likes", to: "likes#like_post"
          delete "likes", to: "likes#unlike_post"
          get "likes", to: "likes#post_likes"
          post "reposts", to: "reposts#create"
          delete "reposts", to: "reposts#destroy"
          get "reposts", to: "reposts#index"
        end
      end

      # Comments
      resources :comments, only: [ :destroy ] do
        member do
          post "likes", to: "likes#like_comment"
          delete "likes", to: "likes#unlike_comment"
          get "likes", to: "likes#comment_likes"
        end
      end

      # Notifications
      resources :notifications, only: [ :index ] do
        member do
          patch "mark_as_read"
          patch "mark_as_unread"
        end
        collection do
          get "unread"
          patch "mark_all_as_read"
        end
      end

      # Feed
      get "feed", to: "feed#index"

      # Search
      get "search/users", to: "search#users"
      get "search/posts", to: "search#posts"
    end
  end
end

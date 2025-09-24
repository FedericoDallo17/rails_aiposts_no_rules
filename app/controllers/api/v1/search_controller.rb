class Api::V1::SearchController < ApplicationController
  include Authenticatable

  # GET /search/users
  def users
    query = params[:q]
    return render json: { error: "Query parameter is required" }, status: :bad_request if query.blank?

    users = User.all

    case params[:by]
    when "name"
      users = users.search_by_name(query)
    when "username"
      users = users.search_by_username(query)
    when "email"
      users = users.search_by_email(query)
    when "location"
      users = users.search_by_location(query)
    else
      # Search by all fields
      users = users.where(
        "first_name ILIKE ? OR last_name ILIKE ? OR username ILIKE ? OR email ILIKE ? OR location ILIKE ?",
        "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%"
      )
    end

    users = users.page(params[:page]).per(20)

    render json: {
      users: users.as_json(except: [ :password_digest ]),
      total_count: users.count,
      current_page: users.current_page,
      total_pages: users.total_pages
    }
  end

  # GET /search/posts
  def posts
    query = params[:q]
    return render json: { error: "Query parameter is required" }, status: :bad_request if query.blank?

    posts = Post.includes(:user, :likes, :comments)

    case params[:by]
    when "content"
      posts = posts.search_by_content(query)
    when "user"
      user = User.find_by(username: params[:user_username])
      posts = posts.search_by_user(user) if user
    when "tags"
      posts = posts.search_by_tags(query)
    when "comments"
      posts = posts.search_by_comments(query)
    else
      # Search by content and tags
      posts = posts.where("content ILIKE ? OR tags ILIKE ?", "%#{query}%", "%#{query}%")
    end

    # Apply sorting
    case params[:sort]
    when "newest"
      posts = posts.newest
    when "oldest"
      posts = posts.oldest
    when "most_liked"
      posts = posts.most_liked
    when "most_commented"
      posts = posts.most_commented
    when "most_recently_commented"
      posts = posts.most_recently_commented
    when "most_recently_liked"
      posts = posts.most_recently_liked
    else
      posts = posts.newest
    end

    posts = posts.page(params[:page]).per(20)

    render json: {
      posts: posts.as_json(include: {
        user: { except: [ :password_digest ] },
        likes: { only: [ :id, :user_id ] },
        comments: { only: [ :id, :content, :created_at ] }
      }),
      total_count: posts.count,
      current_page: posts.current_page,
      total_pages: posts.total_pages
    }
  end
end

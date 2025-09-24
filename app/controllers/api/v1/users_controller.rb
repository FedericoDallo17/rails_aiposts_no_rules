class Api::V1::UsersController < ApplicationController
  include Authenticatable

  # GET /users/profile
  def profile
    render json: @current_user.as_json(except: [ :password_digest ])
  end

  # PUT /users/profile
  def update_profile
    if @current_user.update(user_params)
      render json: {
        message: "Profile updated successfully",
        user: @current_user.as_json(except: [ :password_digest ])
      }, status: :ok
    else
      render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /users/:id
  def show
    user = User.find(params[:id])
    render json: user.as_json(except: [ :password_digest ])
  end

  # GET /users/:id/followers
  def followers
    user = User.find(params[:id])
    followers = user.followers.page(params[:page]).per(20)
    render json: {
      followers: followers.as_json(except: [ :password_digest ]),
      total_count: user.followers.count,
      current_page: followers.current_page,
      total_pages: followers.total_pages
    }
  end

  # GET /users/:id/following
  def following
    user = User.find(params[:id])
    following = user.following.page(params[:page]).per(20)
    render json: {
      following: following.as_json(except: [ :password_digest ]),
      total_count: user.following.count,
      current_page: following.current_page,
      total_pages: following.total_pages
    }
  end

  # GET /users/:id/liked_posts
  def liked_posts
    user = User.find(params[:id])
    liked_posts = user.liked_posts.includes(:user, :likes, :comments)
                     .page(params[:page]).per(20)
    render json: {
      posts: liked_posts.as_json(include: {
        user: { except: [ :password_digest ] },
        likes: { only: [ :id, :user_id ] },
        comments: { only: [ :id, :content, :created_at ] }
      }),
      total_count: user.liked_posts.count,
      current_page: liked_posts.current_page,
      total_pages: liked_posts.total_pages
    }
  end

  # GET /users/:id/commented_posts
  def commented_posts
    user = User.find(params[:id])
    commented_posts = Post.joins(:comments)
                          .where(comments: { user: user })
                          .distinct
                          .includes(:user, :likes, :comments)
                          .page(params[:page]).per(20)
    render json: {
      posts: commented_posts.as_json(include: {
        user: { except: [ :password_digest ] },
        likes: { only: [ :id, :user_id ] },
        comments: { only: [ :id, :content, :created_at ] }
      }),
      total_count: commented_posts.count,
      current_page: commented_posts.current_page,
      total_pages: commented_posts.total_pages
    }
  end

  # GET /users/:id/mentioned_posts
  def mentioned_posts
    user = User.find(params[:id])
    mentioned_posts = Post.where("content ILIKE ?", "%@#{user.username}%")
                          .includes(:user, :likes, :comments)
                          .page(params[:page]).per(20)
    render json: {
      posts: mentioned_posts.as_json(include: {
        user: { except: [ :password_digest ] },
        likes: { only: [ :id, :user_id ] },
        comments: { only: [ :id, :content, :created_at ] }
      }),
      total_count: mentioned_posts.count,
      current_page: mentioned_posts.current_page,
      total_pages: mentioned_posts.total_pages
    }
  end

  # GET /users/:id/tagged_posts
  def tagged_posts
    user = User.find(params[:id])
    tagged_posts = Post.where("tags ILIKE ?", "%#{user.username}%")
                       .includes(:user, :likes, :comments)
                       .page(params[:page]).per(20)
    render json: {
      posts: tagged_posts.as_json(include: {
        user: { except: [ :password_digest ] },
        likes: { only: [ :id, :user_id ] },
        comments: { only: [ :id, :content, :created_at ] }
      }),
      total_count: tagged_posts.count,
      current_page: tagged_posts.current_page,
      total_pages: tagged_posts.total_pages
    }
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :username, :bio, :website, :location)
  end
end

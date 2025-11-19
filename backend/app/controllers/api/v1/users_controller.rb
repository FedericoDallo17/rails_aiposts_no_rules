class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_request, only: [ :show, :index ]

  # GET /api/v1/users
  def index
    @users = User.page(params[:page]).per(params[:per_page] || 20)
    render json: {
      users: @users.map { |u| user_summary(u) },
      meta: pagination_meta(@users)
    }
  end

  # GET /api/v1/users/:id
  def show
    @user = User.find(params[:id])
    render json: {
      user: user_detail(@user),
      stats: user_stats(@user)
    }
  end

  # GET /api/v1/users/:id/posts
  def posts
    @user = User.find(params[:id])
    @posts = @user.posts.includes(:user).order(created_at: :desc).page(params[:page]).per(params[:per_page] || 20)
    render json: {
      posts: @posts.map { |p| post_detail(p) },
      meta: pagination_meta(@posts)
    }
  end

  # GET /api/v1/users/:id/liked_posts
  def liked_posts
    @user = User.find(params[:id])
    @posts = Post.joins(:likes)
                 .where(likes: { user_id: @user.id })
                 .includes(:user)
                 .order("likes.created_at DESC")
                 .page(params[:page]).per(params[:per_page] || 20)
    render json: {
      posts: @posts.map { |p| post_detail(p) },
      meta: pagination_meta(@posts)
    }
  end

  # GET /api/v1/users/:id/commented_posts
  def commented_posts
    @user = User.find(params[:id])
    @posts = Post.joins(:comments)
                 .where(comments: { user_id: @user.id })
                 .includes(:user)
                 .distinct
                 .order("comments.created_at DESC")
                 .page(params[:page]).per(params[:per_page] || 20)
    render json: {
      posts: @posts.map { |p| post_detail(p) },
      meta: pagination_meta(@posts)
    }
  end

  # PATCH /api/v1/users/update_profile
  def update_profile
    if current_user.update(user_params)
      render json: {
        user: user_detail(current_user),
        message: "Profile updated successfully"
      }, status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/users/update_profile_picture
  def update_profile_picture
    if params[:profile_picture].present?
      current_user.profile_picture.attach(params[:profile_picture])
      render json: {
        user: user_detail(current_user),
        message: "Profile picture updated successfully"
      }, status: :ok
    else
      render json: { error: "No profile picture provided" }, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/users/update_cover_picture
  def update_cover_picture
    if params[:cover_picture].present?
      current_user.cover_picture.attach(params[:cover_picture])
      render json: {
        user: user_detail(current_user),
        message: "Cover picture updated successfully"
      }, status: :ok
    else
      render json: { error: "No cover picture provided" }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :bio, :website, :location)
  end

  def user_summary(user)
    {
      id: user.id,
      username: user.username,
      full_name: user.full_name,
      bio: user.bio,
      profile_picture_url: user.profile_picture.attached? ? url_for(user.profile_picture) : nil
    }
  end

  def user_detail(user)
    {
      id: user.id,
      username: user.username,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      full_name: user.full_name,
      bio: user.bio,
      website: user.website,
      location: user.location,
      profile_picture_url: user.profile_picture.attached? ? url_for(user.profile_picture) : nil,
      cover_picture_url: user.cover_picture.attached? ? url_for(user.cover_picture) : nil
    }
  end

  def user_stats(user)
    {
      posts_count: user.posts.count,
      followers_count: user.followers.count,
      following_count: user.following.count,
      is_following: logged_in? && current_user.following?(user)
    }
  end

  def post_detail(post)
    {
      id: post.id,
      content: post.content,
      tags: post.tag_list,
      created_at: post.created_at,
      user: user_summary(post.user),
      likes_count: post.likes_count,
      comments_count: post.comments_count,
      reposts_count: post.reposts_count,
      liked_by_current_user: logged_in? && post.liked_by?(current_user),
      reposted_by_current_user: logged_in? && post.reposted_by?(current_user)
    }
  end

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count,
      per_page: collection.limit_value
    }
  end
end

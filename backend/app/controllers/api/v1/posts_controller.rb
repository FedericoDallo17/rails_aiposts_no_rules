class Api::V1::PostsController < ApplicationController
  skip_before_action :authorize_request, only: [ :index, :show ]
  before_action :set_post, only: [ :show, :update, :destroy ]
  before_action :authorize_post_owner, only: [ :update, :destroy ]

  # GET /api/v1/posts
  def index
    @posts = Post.includes(:user).order(created_at: :desc).page(params[:page]).per(params[:per_page] || 20)
    render json: {
      posts: @posts.map { |p| post_detail(p) },
      meta: pagination_meta(@posts)
    }
  end

  # GET /api/v1/posts/:id
  def show
    render json: { post: post_detail(@post) }
  end

  # POST /api/v1/posts
  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      create_mention_notifications(@post)
      render json: {
        post: post_detail(@post),
        message: "Post created successfully"
      }, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/posts/:id
  def update
    if @post.update(post_params)
      render json: {
        post: post_detail(@post),
        message: "Post updated successfully"
      }
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/posts/:id
  def destroy
    @post.destroy
    render json: { message: "Post deleted successfully" }, status: :ok
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_post_owner
    unless @post.user_id == current_user.id
      render json: { error: "Unauthorized" }, status: :forbidden
    end
  end

  def post_params
    params.require(:post).permit(:content, :tags)
  end

  def create_mention_notifications(post)
    mentions = post.mentions
    mentions.each do |username|
      mentioned_user = User.find_by(username: username)
      next unless mentioned_user && mentioned_user != current_user

      Notification.create(
        user: mentioned_user,
        actor_id: current_user.id,
        notification_type: "mention",
        message: "#{current_user.username} mentioned you in a post"
      )
    end
  end

  def post_detail(post)
    {
      id: post.id,
      content: post.content,
      tags: post.tag_list,
      created_at: post.created_at,
      updated_at: post.updated_at,
      user: user_summary(post.user),
      likes_count: post.likes_count,
      comments_count: post.comments_count,
      reposts_count: post.reposts_count,
      liked_by_current_user: logged_in? && post.liked_by?(current_user),
      reposted_by_current_user: logged_in? && post.reposted_by?(current_user)
    }
  end

  def user_summary(user)
    {
      id: user.id,
      username: user.username,
      full_name: user.full_name,
      profile_picture_url: user.profile_picture.attached? ? url_for(user.profile_picture) : nil
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

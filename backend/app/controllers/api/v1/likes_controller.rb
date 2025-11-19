class Api::V1::LikesController < ApplicationController
  skip_before_action :authorize_request, only: [ :post_likes, :comment_likes ]

  # POST /api/v1/posts/:id/likes
  def like_post
    @post = Post.find(params[:id])
    @like = @post.likes.build(user: current_user)

    if @like.save
      render json: {
        message: "Post liked successfully",
        likes_count: @post.likes_count
      }, status: :created
    else
      render json: { errors: @like.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/posts/:id/likes
  def unlike_post
    @post = Post.find(params[:id])
    @like = @post.likes.find_by(user: current_user)

    if @like
      @like.destroy
      render json: {
        message: "Post unliked successfully",
        likes_count: @post.likes_count
      }, status: :ok
    else
      render json: { error: "Like not found" }, status: :not_found
    end
  end

  # GET /api/v1/posts/:id/likes
  def post_likes
    @post = Post.find(params[:id])
    @likes = @post.likes.includes(:user).order(created_at: :desc).page(params[:page]).per(params[:per_page] || 20)
    render json: {
      likes: @likes.map { |l| like_detail(l) },
      meta: pagination_meta(@likes)
    }
  end

  # POST /api/v1/comments/:id/likes
  def like_comment
    @comment = Comment.find(params[:id])
    @like = @comment.likes.build(user: current_user)

    if @like.save
      render json: {
        message: "Comment liked successfully",
        likes_count: @comment.likes_count
      }, status: :created
    else
      render json: { errors: @like.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/comments/:id/likes
  def unlike_comment
    @comment = Comment.find(params[:id])
    @like = @comment.likes.find_by(user: current_user)

    if @like
      @like.destroy
      render json: {
        message: "Comment unliked successfully",
        likes_count: @comment.likes_count
      }, status: :ok
    else
      render json: { error: "Like not found" }, status: :not_found
    end
  end

  # GET /api/v1/comments/:id/likes
  def comment_likes
    @comment = Comment.find(params[:id])
    @likes = @comment.likes.includes(:user).order(created_at: :desc).page(params[:page]).per(params[:per_page] || 20)
    render json: {
      likes: @likes.map { |l| like_detail(l) },
      meta: pagination_meta(@likes)
    }
  end

  private

  def like_detail(like)
    {
      id: like.id,
      created_at: like.created_at,
      user: user_summary(like.user)
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

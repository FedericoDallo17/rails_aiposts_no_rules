class Api::V1::CommentsController < ApplicationController
  skip_before_action :authorize_request, only: [ :index ]
  before_action :set_post, only: [ :index, :create ]
  before_action :set_comment, only: [ :destroy ]
  before_action :authorize_comment_owner, only: [ :destroy ]

  # GET /api/v1/posts/:post_id/comments
  def index
    @comments = @post.comments.includes(:user).order(created_at: :desc).page(params[:page]).per(params[:per_page] || 20)
    render json: {
      comments: @comments.map { |c| comment_detail(c) },
      meta: pagination_meta(@comments)
    }
  end

  # POST /api/v1/posts/:post_id/comments
  def create
    @comment = @post.comments.build(comment_params.merge(user: current_user))

    if @comment.save
      render json: {
        comment: comment_detail(@comment),
        message: "Comment created successfully"
      }, status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/comments/:id
  def destroy
    @comment.destroy
    render json: { message: "Comment deleted successfully" }, status: :ok
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def authorize_comment_owner
    unless @comment.user_id == current_user.id
      render json: { error: "Unauthorized" }, status: :forbidden
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def comment_detail(comment)
    {
      id: comment.id,
      content: comment.content,
      created_at: comment.created_at,
      user: user_summary(comment.user),
      likes_count: comment.likes_count,
      liked_by_current_user: logged_in? && comment.liked_by?(current_user)
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

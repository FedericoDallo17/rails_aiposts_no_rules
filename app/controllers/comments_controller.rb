class CommentsController < ApplicationController
  include Authenticatable

  before_action :set_comment, only: [ :show, :update, :destroy ]

  # GET /comments
  def index
    comments = Comment.includes(:user, :post)
                      .page(params[:page]).per(20)

    render json: {
      comments: comments.as_json(include: {
        user: { except: [ :password_digest ] },
        post: { only: [ :id, :content, :created_at ] }
      }),
      total_count: Comment.count,
      current_page: comments.current_page,
      total_pages: comments.total_pages
    }
  end

  # GET /comments/:id
  def show
    render json: @comment.as_json(include: {
      user: { except: [ :password_digest ] },
      post: { include: { user: { except: [ :password_digest ] } } }
    })
  end

  # POST /posts/:post_id/comments
  def create
    post = Post.find(params[:post_id])
    comment = post.comments.build(comment_params)
    comment.user = @current_user

    if comment.save
      render json: {
        message: "Comment created successfully",
        comment: comment.as_json(include: {
          user: { except: [ :password_digest ] },
          post: { only: [ :id, :content, :created_at ] }
        })
      }, status: :created
    else
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /comments/:id
  def update
    if @comment.user == @current_user
      if @comment.update(comment_params)
        render json: {
          message: "Comment updated successfully",
          comment: @comment.as_json(include: {
            user: { except: [ :password_digest ] },
            post: { only: [ :id, :content, :created_at ] }
          })
        }, status: :ok
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Not authorized to update this comment" }, status: :forbidden
    end
  end

  # DELETE /comments/:id
  def destroy
    if @comment.user == @current_user
      @comment.destroy
      render json: { message: "Comment deleted successfully" }, status: :ok
    else
      render json: { error: "Not authorized to delete this comment" }, status: :forbidden
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.permit(:content)
  end
end

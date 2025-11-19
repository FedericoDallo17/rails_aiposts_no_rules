class Api::V1::RepostsController < ApplicationController
  skip_before_action :authorize_request, only: [ :index ]

  # POST /api/v1/posts/:id/reposts
  def create
    @post = Post.find(params[:id])
    @repost = @post.reposts.build(user: current_user)

    if @repost.save
      render json: {
        message: "Post reposted successfully",
        reposts_count: @post.reposts_count
      }, status: :created
    else
      render json: { errors: @repost.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/posts/:id/reposts
  def destroy
    @post = Post.find(params[:id])
    @repost = @post.reposts.find_by(user: current_user)

    if @repost
      @repost.destroy
      render json: {
        message: "Repost removed successfully",
        reposts_count: @post.reposts_count
      }, status: :ok
    else
      render json: { error: "Repost not found" }, status: :not_found
    end
  end

  # GET /api/v1/posts/:id/reposts
  def index
    @post = Post.find(params[:id])
    @reposts = @post.reposts.includes(:user).order(created_at: :desc).page(params[:page]).per(params[:per_page] || 20)
    render json: {
      reposts: @reposts.map { |r| repost_detail(r) },
      meta: pagination_meta(@reposts)
    }
  end

  private

  def repost_detail(repost)
    {
      id: repost.id,
      created_at: repost.created_at,
      user: user_summary(repost.user),
      post: {
        id: repost.post.id,
        content: repost.post.content,
        original_author: user_summary(repost.post.user)
      }
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

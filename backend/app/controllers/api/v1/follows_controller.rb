class Api::V1::FollowsController < ApplicationController
  skip_before_action :authorize_request, only: [ :followers, :following ]

  # POST /api/v1/users/:user_id/follow
  def create
    @user_to_follow = User.find(params[:user_id])

    if current_user == @user_to_follow
      render json: { error: "You cannot follow yourself" }, status: :unprocessable_entity
      return
    end

    @follow = current_user.active_follows.build(followed_id: @user_to_follow.id)

    if @follow.save
      render json: {
        message: "You are now following #{@user_to_follow.username}",
        following: true
      }, status: :created
    else
      render json: { errors: @follow.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/:user_id/follow
  def destroy
    @user_to_unfollow = User.find(params[:user_id])
    @follow = current_user.active_follows.find_by(followed_id: @user_to_unfollow.id)

    if @follow
      @follow.destroy
      render json: {
        message: "You have unfollowed #{@user_to_unfollow.username}",
        following: false
      }, status: :ok
    else
      render json: { error: "You are not following this user" }, status: :not_found
    end
  end

  # GET /api/v1/users/:user_id/followers
  def followers
    @user = User.find(params[:user_id])
    @followers = @user.followers.page(params[:page]).per(params[:per_page] || 20)
    render json: {
      followers: @followers.map { |u| user_detail(u) },
      meta: pagination_meta(@followers)
    }
  end

  # GET /api/v1/users/:user_id/following
  def following
    @user = User.find(params[:user_id])
    @following = @user.following.page(params[:page]).per(params[:per_page] || 20)
    render json: {
      following: @following.map { |u| user_detail(u) },
      meta: pagination_meta(@following)
    }
  end

  private

  def user_detail(user)
    {
      id: user.id,
      username: user.username,
      full_name: user.full_name,
      bio: user.bio,
      profile_picture_url: user.profile_picture.attached? ? url_for(user.profile_picture) : nil,
      is_following: logged_in? && current_user.following?(user)
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

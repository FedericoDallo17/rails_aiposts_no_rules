class FollowsController < ApplicationController
  include Authenticatable

  # POST /users/:user_id/follow
  def create
    user_to_follow = User.find(params[:user_id])

    if user_to_follow == @current_user
      render json: { error: "Cannot follow yourself" }, status: :unprocessable_entity
      return
    end

    if @current_user.following?(user_to_follow)
      render json: { error: "Already following this user" }, status: :unprocessable_entity
      return
    end

    if @current_user.follow(user_to_follow)
      render json: { message: "Successfully followed user" }, status: :created
    else
      render json: { error: "Failed to follow user" }, status: :unprocessable_entity
    end
  end

  # DELETE /users/:user_id/follow
  def destroy
    user_to_unfollow = User.find(params[:user_id])

    if @current_user.unfollow(user_to_unfollow)
      render json: { message: "Successfully unfollowed user" }, status: :ok
    else
      render json: { error: "Not following this user" }, status: :unprocessable_entity
    end
  end

  # GET /users/:user_id/follow_status
  def follow_status
    user = User.find(params[:user_id])
    is_following = @current_user.following?(user)

    render json: {
      user_id: user.id,
      is_following: is_following,
      followers_count: user.followers.count,
      following_count: user.following.count
    }
  end
end

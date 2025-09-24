class Api::V1::ImagesController < ApplicationController
  include Authenticatable

  # POST /images/profile_picture
  def upload_profile_picture
    if @current_user.profile_picture.attach(params[:image])
      render json: {
        message: "Profile picture uploaded successfully",
        image_url: url_for(@current_user.profile_picture)
      }, status: :ok
    else
      render json: { errors: @current_user.profile_picture.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /images/cover_picture
  def upload_cover_picture
    if @current_user.cover_picture.attach(params[:image])
      render json: {
        message: "Cover picture uploaded successfully",
        image_url: url_for(@current_user.cover_picture)
      }, status: :ok
    else
      render json: { errors: @current_user.cover_picture.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /images/profile_picture
  def delete_profile_picture
    @current_user.profile_picture.purge
    render json: { message: "Profile picture deleted successfully" }, status: :ok
  end

  # DELETE /images/cover_picture
  def delete_cover_picture
    @current_user.cover_picture.purge
    render json: { message: "Cover picture deleted successfully" }, status: :ok
  end
end

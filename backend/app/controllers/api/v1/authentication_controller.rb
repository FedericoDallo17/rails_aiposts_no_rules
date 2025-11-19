class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: [ :sign_up, :sign_in ]

  # POST /api/v1/auth/sign_up
  def sign_up
    user = User.new(sign_up_params)

    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: {
        token: token,
        user: user_response(user),
        message: "Account created successfully"
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/auth/sign_in
  def sign_in
    user = User.find_by(email: params[:email]&.downcase)

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: {
        token: token,
        user: user_response(user),
        message: "Signed in successfully"
      }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  # POST /api/v1/auth/change_password
  def change_password
    if current_user.authenticate(params[:current_password])
      if current_user.update(password: params[:new_password])
        render json: { message: "Password changed successfully" }, status: :ok
      else
        render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Current password is incorrect" }, status: :unauthorized
    end
  end

  # POST /api/v1/auth/change_email
  def change_email
    if current_user.authenticate(params[:password])
      if current_user.update(email: params[:new_email])
        render json: {
          user: user_response(current_user),
          message: "Email changed successfully"
        }, status: :ok
      else
        render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Password is incorrect" }, status: :unauthorized
    end
  end

  # DELETE /api/v1/auth/delete_account
  def delete_account
    if current_user.authenticate(params[:password])
      current_user.destroy
      render json: { message: "Account deleted successfully" }, status: :ok
    else
      render json: { error: "Password is incorrect" }, status: :unauthorized
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation,
                                  :first_name, :last_name, :bio, :website, :location)
  end

  def user_response(user)
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
end

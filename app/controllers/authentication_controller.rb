class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request, only: [ :signup, :signin, :forgot_password, :reset_password ]

  # POST /auth/signup
  def signup
    user = User.new(user_params)
    if user.save
      token = JwtService.encode(user_id: user.id)
      render json: {
        message: "User created successfully",
        user: user.as_json(except: [ :password_digest ]),
        token: token
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /auth/signin
  def signin
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)
      render json: {
        message: "Login successful",
        user: user.as_json(except: [ :password_digest ]),
        token: token
      }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  # POST /auth/signout
  def signout
    # In a stateless JWT system, signout is handled client-side by removing the token
    render json: { message: "Logged out successfully" }, status: :ok
  end

  # POST /auth/forgot_password
  def forgot_password
    user = User.find_by(email: params[:email])
    if user
      # In a real app, you would send an email with reset instructions
      # For now, we'll just return a success message
      render json: { message: "Password reset instructions sent to your email" }, status: :ok
    else
      render json: { error: "Email not found" }, status: :not_found
    end
  end

  # POST /auth/reset_password
  def reset_password
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:current_password])
      if user.update(password: params[:new_password])
        render json: { message: "Password updated successfully" }, status: :ok
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid current password" }, status: :unauthorized
    end
  end

  # PUT /auth/change_email
  def change_email
    if @current_user.authenticate(params[:current_password])
      if @current_user.update(email: params[:new_email])
        render json: { message: "Email updated successfully" }, status: :ok
      else
        render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid current password" }, status: :unauthorized
    end
  end

  # DELETE /auth/delete_account
  def delete_account
    if @current_user.authenticate(params[:password])
      @current_user.destroy
      render json: { message: "Account deleted successfully" }, status: :ok
    else
      render json: { error: "Invalid password" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:first_name, :last_name, :username, :email, :password, :bio, :website, :location)
  end
end

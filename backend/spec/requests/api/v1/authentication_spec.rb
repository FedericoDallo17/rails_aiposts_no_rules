require 'rails_helper'

RSpec.describe "Api::V1::Authentication", type: :request do
  describe "POST /api/v1/auth/sign_up" do
    let(:valid_attributes) do
      {
        user: {
          username: "testuser",
          email: "test@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    context "with valid parameters" do
      it "creates a new user" do
        expect {
          post "/api/v1/auth/sign_up", params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it "returns a token" do
        post "/api/v1/auth/sign_up", params: valid_attributes
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context "with invalid parameters" do
      it "does not create a new user" do
        expect {
          post "/api/v1/auth/sign_up", params: { user: { username: "" } }
        }.to change(User, :count).by(0)
      end

      it "returns errors" do
        post "/api/v1/auth/sign_up", params: { user: { username: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end

  describe "POST /api/v1/auth/sign_in" do
    let(:user) { create(:user, email: "test@example.com", password: "password123") }

    context "with valid credentials" do
      it "returns a token" do
        post "/api/v1/auth/sign_in", params: { email: user.email, password: "password123" }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context "with invalid credentials" do
      it "returns an error" do
        post "/api/v1/auth/sign_in", params: { email: user.email, password: "wrongpassword" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/auth/change_password" do
    let(:user) { create(:user, password: "oldpassword123") }
    let(:token) { JsonWebToken.encode(user_id: user.id) }

    context "with valid current password" do
      it "changes the password" do
        post "/api/v1/auth/change_password",
             params: { current_password: "oldpassword123", new_password: "newpassword123" },
             headers: { 'Authorization' => "Bearer #{token}" }
        expect(response).to have_http_status(:ok)
        expect(user.reload.authenticate("newpassword123")).to be_truthy
      end
    end

    context "with invalid current password" do
      it "returns an error" do
        post "/api/v1/auth/change_password",
             params: { current_password: "wrongpassword", new_password: "newpassword123" },
             headers: { 'Authorization' => "Bearer #{token}" }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

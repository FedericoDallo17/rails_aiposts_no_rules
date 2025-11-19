require 'swagger_helper'

RSpec.describe 'Authentication API', type: :request do
  path '/api/v1/auth/sign_up' do
    post 'Sign up a new user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              username: { type: :string },
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string },
              first_name: { type: :string },
              last_name: { type: :string },
              bio: { type: :string },
              website: { type: :string },
              location: { type: :string }
            },
            required: [ 'username', 'email', 'password', 'password_confirmation' ]
          }
        }
      }

      response '201', 'user created' do
        let(:user) do
          {
            user: {
              username: 'testuser',
              email: 'test@example.com',
              password: 'password123',
              password_confirmation: 'password123'
            }
          }
        end
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { user: { username: '' } } }
        run_test!
      end
    end
  end

  path '/api/v1/auth/sign_in' do
    post 'Sign in a user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: [ 'email', 'password' ]
      }

      response '200', 'user signed in' do
        let(:user) { create(:user, email: 'test@example.com', password: 'password123') }
        let(:credentials) { { email: user.email, password: 'password123' } }
        run_test!
      end

      response '401', 'unauthorized' do
        let(:credentials) { { email: 'test@example.com', password: 'wrongpassword' } }
        run_test!
      end
    end
  end
end

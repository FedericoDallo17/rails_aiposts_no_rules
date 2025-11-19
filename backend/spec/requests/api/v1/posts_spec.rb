require 'rails_helper'

RSpec.describe "Api::V1::Posts", type: :request do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe "GET /api/v1/posts" do
    it "returns all posts" do
      create_list(:post, 3)
      get "/api/v1/posts"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['posts'].size).to eq(3)
    end
  end

  describe "GET /api/v1/posts/:id" do
    let(:post) { create(:post) }

    it "returns the post" do
      get "/api/v1/posts/#{post.id}"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['post']['id']).to eq(post.id)
    end
  end

  describe "POST /api/v1/posts" do
    context "with valid parameters" do
      it "creates a new post" do
        expect {
          post "/api/v1/posts",
               params: { post: { content: "Test post" } },
               headers: headers
        }.to change(Post, :count).by(1)
      end

      it "returns the created post" do
        post "/api/v1/posts",
             params: { post: { content: "Test post", tags: "test" } },
             headers: headers
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['post']['content']).to eq("Test post")
      end
    end

    context "with invalid parameters" do
      it "returns errors" do
        post "/api/v1/posts",
             params: { post: { content: "" } },
             headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /api/v1/posts/:id" do
    let(:post_to_update) { create(:post, user: user) }

    context "when user owns the post" do
      it "updates the post" do
        patch "/api/v1/posts/#{post_to_update.id}",
              params: { post: { content: "Updated content" } },
              headers: headers
        expect(response).to have_http_status(:ok)
        expect(post_to_update.reload.content).to eq("Updated content")
      end
    end

    context "when user does not own the post" do
      let(:other_user_post) { create(:post) }

      it "returns forbidden" do
        patch "/api/v1/posts/#{other_user_post.id}",
              params: { post: { content: "Updated content" } },
              headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE /api/v1/posts/:id" do
    let(:post_to_delete) { create(:post, user: user) }

    context "when user owns the post" do
      it "deletes the post" do
        post_to_delete # create the post
        expect {
          delete "/api/v1/posts/#{post_to_delete.id}", headers: headers
        }.to change(Post, :count).by(-1)
      end
    end
  end
end

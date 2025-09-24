class Api::V1::PostsController < ApplicationController
  include Authenticatable

  before_action :set_post, only: [ :show, :update, :destroy, :like, :unlike, :comments ]

  # GET /posts
  def index
    posts = Post.includes(:user, :likes, :comments)
                .page(params[:page]).per(20)

    # Apply sorting
    case params[:sort]
    when "newest"
      posts = posts.newest
    when "oldest"
      posts = posts.oldest
    when "most_liked"
      posts = posts.most_liked
    when "most_commented"
      posts = posts.most_commented
    when "most_recently_commented"
      posts = posts.most_recently_commented
    when "most_recently_liked"
      posts = posts.most_recently_liked
    else
      posts = posts.newest
    end

    render json: {
      posts: posts.as_json(include: {
        user: { except: [ :password_digest ] },
        likes: { only: [ :id, :user_id ] },
        comments: { only: [ :id, :content, :created_at ] }
      }),
      total_count: Post.count,
      current_page: posts.current_page,
      total_pages: posts.total_pages
    }
  end

  # GET /posts/feed
  def feed
    posts = @current_user.feed_posts
                         .includes(:user, :likes, :comments)
                         .page(params[:page]).per(20)

    render json: {
      posts: posts.as_json(include: {
        user: { except: [ :password_digest ] },
        likes: { only: [ :id, :user_id ] },
        comments: { only: [ :id, :content, :created_at ] }
      }),
      total_count: @current_user.feed_posts.count,
      current_page: posts.current_page,
      total_pages: posts.total_pages
    }
  end

  # GET /posts/:id
  def show
    render json: @post.as_json(include: {
      user: { except: [ :password_digest ] },
      likes: { only: [ :id, :user_id ] },
      comments: { include: { user: { except: [ :password_digest ] } } }
    })
  end

  # POST /posts
  def create
    post = @current_user.posts.build(post_params)
    if post.save
      render json: {
        message: "Post created successfully",
        post: post.as_json(include: {
          user: { except: [ :password_digest ] },
          likes: { only: [ :id, :user_id ] },
          comments: { only: [ :id, :content, :created_at ] }
        })
      }, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /posts/:id
  def update
    if @post.user == @current_user
      if @post.update(post_params)
        render json: {
          message: "Post updated successfully",
          post: @post.as_json(include: {
            user: { except: [ :password_digest ] },
            likes: { only: [ :id, :user_id ] },
            comments: { only: [ :id, :content, :created_at ] }
          })
        }, status: :ok
      else
        render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Not authorized to update this post" }, status: :forbidden
    end
  end

  # DELETE /posts/:id
  def destroy
    if @post.user == @current_user
      @post.destroy
      render json: { message: "Post deleted successfully" }, status: :ok
    else
      render json: { error: "Not authorized to delete this post" }, status: :forbidden
    end
  end

  # POST /posts/:id/like
  def like
    if @current_user.like(@post)
      render json: { message: "Post liked successfully" }, status: :ok
    else
      render json: { error: "Already liked this post" }, status: :unprocessable_entity
    end
  end

  # DELETE /posts/:id/like
  def unlike
    if @current_user.unlike(@post)
      render json: { message: "Post unliked successfully" }, status: :ok
    else
      render json: { error: "Post not liked" }, status: :unprocessable_entity
    end
  end

  # GET /posts/:id/likes
  def likes
    likes = @post.likes.includes(:user).page(params[:page]).per(20)
    render json: {
      likes: likes.as_json(include: { user: { except: [ :password_digest ] } }),
      total_count: @post.likes.count,
      current_page: likes.current_page,
      total_pages: likes.total_pages
    }
  end

  # GET /posts/:id/comments
  def comments
    comments = @post.comments.includes(:user).page(params[:page]).per(20)
    render json: {
      comments: comments.as_json(include: { user: { except: [ :password_digest ] } }),
      total_count: @post.comments.count,
      current_page: comments.current_page,
      total_pages: comments.total_pages
    }
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.permit(:content, :tags)
  end
end

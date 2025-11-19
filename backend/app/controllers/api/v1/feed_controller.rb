class Api::V1::FeedController < ApplicationController
  # GET /api/v1/feed
  def index
    following_ids = current_user.following.pluck(:id)

    # Get post IDs from followed users, current user, and reposted posts
    own_and_following_post_ids = Post.where(user_id: [ current_user.id, *following_ids ]).pluck(:id)
    reposted_post_ids = Repost.where(user_id: following_ids).pluck(:post_id)
    
    all_post_ids = (own_and_following_post_ids + reposted_post_ids).uniq

    # Fetch all posts in one query
    @posts = Post.includes(:user, :reposts)
                 .where(id: all_post_ids)
                 .order(created_at: :desc)
                 .page(params[:page])
                 .per(params[:per_page] || 20)

    render json: {
      posts: @posts.map { |p| post_detail(p) },
      meta: pagination_meta(@posts)
    }
  end

  private

  def post_detail(post)
    # Check if this post was reposted by someone the user follows
    repost = post.reposts.where(user_id: current_user.following.pluck(:id)).order(created_at: :desc).first

    {
      id: post.id,
      content: post.content,
      tags: post.tag_list,
      created_at: post.created_at,
      user: user_summary(post.user),
      likes_count: post.likes_count,
      comments_count: post.comments_count,
      reposts_count: post.reposts_count,
      liked_by_current_user: post.liked_by?(current_user),
      reposted_by_current_user: post.reposted_by?(current_user),
      reposted_by: repost ? user_summary(repost.user) : nil
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

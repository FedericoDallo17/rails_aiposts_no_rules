class Api::V1::SearchController < ApplicationController
  skip_before_action :authorize_request

  # GET /api/v1/search/users
  def users
    query = params[:q]

    if query.blank?
      render json: { users: [], meta: { total_count: 0 } }
      return
    end

    @users = User.where(
      "username ILIKE :q OR first_name ILIKE :q OR last_name ILIKE :q OR email ILIKE :q OR location ILIKE :q",
      q: "%#{query}%"
    ).page(params[:page]).per(params[:per_page] || 20)

    render json: {
      users: @users.map { |u| user_detail(u) },
      meta: pagination_meta(@users)
    }
  end

  # GET /api/v1/search/posts
  def posts
    query = params[:q]
    sort_by = params[:sort_by] || "newest"

    if query.blank?
      render json: { posts: [], meta: { total_count: 0 } }
      return
    end

    # Search by content, tags, user, or comments
    @posts = Post.includes(:user, :comments)
                 .left_joins(:comments, :user)
                 .where(
                   "posts.content ILIKE :q OR posts.tags ILIKE :q OR users.username ILIKE :q OR comments.content ILIKE :q",
                   q: "%#{query}%"
                 )
                 .distinct

    # Apply sorting
    @posts = apply_sorting(@posts, sort_by)

    @posts = @posts.page(params[:page]).per(params[:per_page] || 20)

    render json: {
      posts: @posts.map { |p| post_detail(p) },
      meta: pagination_meta(@posts)
    }
  end

  private

  def apply_sorting(posts, sort_by)
    case sort_by
    when "newest"
      posts.recent
    when "oldest"
      posts.oldest
    when "most_liked"
      posts.most_liked
    when "most_commented"
      posts.most_commented
    when "most_recently_commented"
      posts.most_recently_commented
    when "most_recently_liked"
      posts.most_recently_liked
    else
      posts.recent
    end
  end

  def user_detail(user)
    {
      id: user.id,
      username: user.username,
      full_name: user.full_name,
      bio: user.bio,
      location: user.location,
      profile_picture_url: user.profile_picture.attached? ? url_for(user.profile_picture) : nil,
      followers_count: user.followers.count,
      is_following: logged_in? && current_user&.following?(user)
    }
  end

  def post_detail(post)
    {
      id: post.id,
      content: post.content,
      tags: post.tag_list,
      created_at: post.created_at,
      user: user_summary(post.user),
      likes_count: post.likes_count,
      comments_count: post.comments_count,
      reposts_count: post.reposts_count,
      liked_by_current_user: logged_in? && current_user && post.liked_by?(current_user),
      reposted_by_current_user: logged_in? && current_user && post.reposted_by?(current_user)
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

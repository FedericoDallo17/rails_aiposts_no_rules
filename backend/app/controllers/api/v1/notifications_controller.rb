class Api::V1::NotificationsController < ApplicationController
  before_action :set_notification, only: [ :mark_as_read, :mark_as_unread ]

  # GET /api/v1/notifications
  def index
    @notifications = current_user.notifications
                                  .includes(:actor)
                                  .recent
                                  .page(params[:page])
                                  .per(params[:per_page] || 20)

    render json: {
      notifications: @notifications.map { |n| notification_detail(n) },
      unread_count: current_user.notifications.unread.count,
      meta: pagination_meta(@notifications)
    }
  end

  # GET /api/v1/notifications/unread
  def unread
    @notifications = current_user.notifications
                                  .unread
                                  .includes(:actor)
                                  .recent
                                  .page(params[:page])
                                  .per(params[:per_page] || 20)

    render json: {
      notifications: @notifications.map { |n| notification_detail(n) },
      meta: pagination_meta(@notifications)
    }
  end

  # PATCH /api/v1/notifications/:id/mark_as_read
  def mark_as_read
    @notification.mark_as_read!
    render json: {
      notification: notification_detail(@notification),
      message: "Notification marked as read"
    }
  end

  # PATCH /api/v1/notifications/:id/mark_as_unread
  def mark_as_unread
    @notification.mark_as_unread!
    render json: {
      notification: notification_detail(@notification),
      message: "Notification marked as unread"
    }
  end

  # PATCH /api/v1/notifications/mark_all_as_read
  def mark_all_as_read
    current_user.notifications.unread.update_all(read_at: Time.current)
    render json: { message: "All notifications marked as read" }
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end

  def notification_detail(notification)
    {
      id: notification.id,
      message: notification.message,
      notification_type: notification.notification_type,
      read: notification.read?,
      created_at: notification.created_at,
      actor: user_summary(notification.actor)
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

class Api::V1::NotificationsController < ApplicationController
  include Authenticatable

  before_action :set_notification, only: [ :show, :mark_read, :mark_unread, :destroy ]

  # GET /notifications
  def index
    notifications = @current_user.notifications
                                 .includes(:notifiable)
                                 .order(created_at: :desc)
                                 .page(params[:page]).per(20)

    render json: {
      notifications: notifications.as_json(include: {
        notifiable: { only: [ :id, :content, :created_at ] }
      }),
      total_count: @current_user.notifications.count,
      current_page: notifications.current_page,
      total_pages: notifications.total_pages
    }
  end

  # GET /notifications/read
  def read
    notifications = @current_user.notifications.read
                                 .includes(:notifiable)
                                 .order(created_at: :desc)
                                 .page(params[:page]).per(20)

    render json: {
      notifications: notifications.as_json(include: {
        notifiable: { only: [ :id, :content, :created_at ] }
      }),
      total_count: @current_user.notifications.read.count,
      current_page: notifications.current_page,
      total_pages: notifications.total_pages
    }
  end

  # GET /notifications/unread
  def unread
    notifications = @current_user.notifications.unread
                                 .includes(:notifiable)
                                 .order(created_at: :desc)
                                 .page(params[:page]).per(20)

    render json: {
      notifications: notifications.as_json(include: {
        notifiable: { only: [ :id, :content, :created_at ] }
      }),
      total_count: @current_user.notifications.unread.count,
      current_page: notifications.current_page,
      total_pages: notifications.total_pages
    }
  end

  # GET /notifications/:id
  def show
    render json: @notification.as_json(include: {
      notifiable: { only: [ :id, :content, :created_at ] }
    })
  end

  # PUT /notifications/:id/mark_read
  def mark_read
    @notification.mark_as_read!
    render json: { message: "Notification marked as read" }, status: :ok
  end

  # PUT /notifications/:id/mark_unread
  def mark_unread
    @notification.mark_as_unread!
    render json: { message: "Notification marked as unread" }, status: :ok
  end

  # DELETE /notifications/:id
  def destroy
    @notification.destroy
    render json: { message: "Notification deleted successfully" }, status: :ok
  end

  # PUT /notifications/mark_all_read
  def mark_all_read
    @current_user.notifications.unread.update_all(read: true)
    render json: { message: "All notifications marked as read" }, status: :ok
  end

  private

  def set_notification
    @notification = @current_user.notifications.find(params[:id])
  end
end

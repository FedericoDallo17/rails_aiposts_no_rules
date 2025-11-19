class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  # Validations
  validates :user, presence: true
  validates :likeable, presence: true
  validates :user_id, uniqueness: { scope: [ :likeable_type, :likeable_id ],
                                    message: "has already liked this" }

  # Callbacks
  after_create :create_notification

  private

  def create_notification
    return if user == likeable.user

    Notification.create!(
      user: likeable.user,
      actor_id: user.id,
      notification_type: likeable_type == "Post" ? "like_post" : "like_comment",
      message: "#{user.username} liked your #{likeable_type.downcase}"
    )
  end
end

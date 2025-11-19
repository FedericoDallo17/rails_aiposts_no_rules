class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  # Validations
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validates :follower_id, uniqueness: { scope: :followed_id, message: "is already following this user" }
  validate :cannot_follow_self

  # Callbacks
  after_create :create_notification

  private

  def cannot_follow_self
    if follower_id == followed_id
      errors.add(:base, "You cannot follow yourself")
    end
  end

  def create_notification
    Notification.create!(
      user: followed,
      actor_id: follower_id,
      notification_type: "follow",
      message: "#{follower.username} started following you"
    )
  end
end

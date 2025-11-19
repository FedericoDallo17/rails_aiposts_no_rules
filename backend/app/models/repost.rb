class Repost < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # Validations
  validates :user, presence: true
  validates :post, presence: true
  validates :user_id, uniqueness: { scope: :post_id, message: "has already reposted this post" }
  validate :cannot_repost_own_post

  # Callbacks
  after_create :create_notification

  private

  def cannot_repost_own_post
    if user_id == post&.user_id
      errors.add(:base, "You cannot repost your own post")
    end
  end

  def create_notification
    Notification.create!(
      user: post.user,
      actor_id: user.id,
      notification_type: "repost",
      message: "#{user.username} reposted your post"
    )
  end
end

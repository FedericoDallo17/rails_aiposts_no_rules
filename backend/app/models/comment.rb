class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :likes, as: :likeable, dependent: :destroy

  # Validations
  validates :content, presence: true, length: { maximum: 1000 }
  validates :user, presence: true
  validates :post, presence: true

  # Callbacks
  after_create :create_notification

  # Instance methods
  def likes_count
    likes.count
  end

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  private

  def create_notification
    return if user == post.user

    Notification.create!(
      user: post.user,
      actor_id: user.id,
      notification_type: "comment",
      message: "#{user.username} commented on your post"
    )
  end
end

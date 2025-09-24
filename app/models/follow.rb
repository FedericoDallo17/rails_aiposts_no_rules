class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :following, class_name: "User"

  # Validations
  validates :follower_id, uniqueness: { scope: :following_id, message: "is already following this user" }
  validate :cannot_follow_self

  private

  def cannot_follow_self
    errors.add(:following, "cannot follow yourself") if follower_id == following_id
  end
end

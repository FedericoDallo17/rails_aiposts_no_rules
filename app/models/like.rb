class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # Validations
  validates :user_id, uniqueness: { scope: :post_id, message: "has already liked this post" }
end

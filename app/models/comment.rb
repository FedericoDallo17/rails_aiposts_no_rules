class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # Validations
  validates :content, presence: true, length: { minimum: 1, maximum: 500 }

  # Scopes
  scope :search_by_content, ->(query) { where("content ILIKE ?", "%#{query}%") }

  # Methods
  def mentioned_users
    content.scan(/@(\w+)/).flatten.map { |username| User.find_by(username: username) }.compact
  end
end

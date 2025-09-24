class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user

  # Validations
  validates :content, presence: true, length: { minimum: 1, maximum: 2000 }

  # Scopes
  scope :search_by_content, ->(query) { where("content ILIKE ?", "%#{query}%") }
  scope :search_by_user, ->(user) { where(user: user) }
  scope :search_by_tags, ->(tags) { where("tags ILIKE ?", "%#{tags}%") }
  scope :search_by_comments, ->(query) { joins(:comments).where("comments.content ILIKE ?", "%#{query}%") }
  scope :newest, -> { order(created_at: :desc) }
  scope :oldest, -> { order(created_at: :asc) }
  scope :most_liked, -> { left_joins(:likes).group(:id).order("COUNT(likes.id) DESC") }
  scope :most_commented, -> { left_joins(:comments).group(:id).order("COUNT(comments.id) DESC") }
  scope :most_recently_commented, -> { left_joins(:comments).group(:id).order("MAX(comments.created_at) DESC") }
  scope :most_recently_liked, -> { left_joins(:likes).group(:id).order("MAX(likes.created_at) DESC") }

  # Methods
  def like_count
    likes.count
  end

  def comment_count
    comments.count
  end

  def liked_by?(user)
    likes.exists?(user: user)
  end

  def mentioned_users
    content.scan(/@(\w+)/).flatten.map { |username| User.find_by(username: username) }.compact
  end

  def tagged_users
    content.scan(/#(\w+)/).flatten
  end
end

class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :reposts, dependent: :destroy

  # Validations
  validates :content, presence: true, length: { maximum: 5000 }
  validates :user, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :oldest, -> { order(created_at: :asc) }
  scope :most_liked, -> { left_joins(:likes).group(:id).order("COUNT(likes.id) DESC") }
  scope :most_commented, -> { left_joins(:comments).group(:id).order("COUNT(comments.id) DESC") }
  scope :most_recently_commented, -> {
    left_joins(:comments)
    .group("posts.id")
    .order(Arel.sql("MAX(comments.created_at) DESC NULLS LAST"))
  }
  scope :most_recently_liked, -> {
    left_joins(:likes)
    .group("posts.id")
    .order(Arel.sql("MAX(likes.created_at) DESC NULLS LAST"))
  }

  # Instance methods
  def likes_count
    likes.count
  end

  def comments_count
    comments.count
  end

  def reposts_count
    reposts.count
  end

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  def reposted_by?(user)
    reposts.exists?(user_id: user.id)
  end

  def tag_list
    tags&.split(",")&.map(&:strip) || []
  end

  def tag_list=(tag_array)
    self.tags = tag_array.join(", ")
  end

  def mentions
    content.scan(/@(\w+)/).flatten
  end
end

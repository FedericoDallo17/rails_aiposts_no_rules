class User < ApplicationRecord
  has_secure_password

  # Associations
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :follows_as_follower, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :follows_as_following, class_name: "Follow", foreign_key: "following_id", dependent: :destroy
  has_many :following, through: :follows_as_follower, source: :following
  has_many :followers, through: :follows_as_following, source: :follower
  has_many :notifications, dependent: :destroy

  # Active Storage
  has_one_attached :profile_picture
  has_one_attached :cover_picture

  # Validations
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :username, presence: true, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :bio, length: { maximum: 500 }
  validates :website, format: { with: URI.regexp(%w[http https]), message: "must be a valid URL" }, allow_blank: true
  validates :location, length: { maximum: 100 }

  # Scopes
  scope :search_by_name, ->(query) { where("first_name ILIKE ? OR last_name ILIKE ?", "%#{query}%", "%#{query}%") }
  scope :search_by_username, ->(query) { where("username ILIKE ?", "%#{query}%") }
  scope :search_by_email, ->(query) { where("email ILIKE ?", "%#{query}%") }
  scope :search_by_location, ->(query) { where("location ILIKE ?", "%#{query}%") }

  # Methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def follow(user)
    following << user unless following.include?(user) || self == user
  end

  def unfollow(user)
    following.delete(user)
  end

  def following?(user)
    following.include?(user)
  end

  def like(post)
    liked_posts << post unless liked_posts.include?(post)
  end

  def unlike(post)
    liked_posts.delete(post)
  end

  def liked?(post)
    liked_posts.include?(post)
  end

  def feed_posts
    Post.joins(:user).where(user: following).or(Post.where(user: self)).order(created_at: :desc)
  end
end

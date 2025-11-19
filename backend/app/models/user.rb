class User < ApplicationRecord
  has_secure_password

  # Active Storage attachments
  has_one_attached :profile_picture
  has_one_attached :cover_picture

  # Associations
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :reposts, dependent: :destroy
  has_many :reposted_posts, through: :reposts, source: :post
  has_many :notifications, dependent: :destroy

  # Follower associations
  has_many :active_follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_follows, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower

  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 30 },
            format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers, and underscores" }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, length: { maximum: 50 }, allow_blank: true
  validates :last_name, length: { maximum: 50 }, allow_blank: true
  validates :bio, length: { maximum: 500 }, allow_blank: true
  validates :website, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: "must be a valid URL" }, allow_blank: true
  validates :location, length: { maximum: 100 }, allow_blank: true

  # Callbacks
  before_save :downcase_email

  # Instance methods
  def follow(other_user)
    following << other_user unless self == other_user || following.include?(other_user)
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def feed
    following_ids = following.pluck(:id)
    own_and_following_post_ids = Post.where(user_id: [ id, *following_ids ]).pluck(:id)
    reposted_post_ids = Repost.where(user_id: following_ids).pluck(:post_id)
    all_post_ids = (own_and_following_post_ids + reposted_post_ids).uniq

    Post.includes(:user)
        .where(id: all_post_ids)
        .order(created_at: :desc)
  end

  def full_name
    "#{first_name} #{last_name}".strip.presence || username
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end

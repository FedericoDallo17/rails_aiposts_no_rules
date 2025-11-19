class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :actor, class_name: "User"

  # Validations
  validates :message, presence: true
  validates :notification_type, presence: true
  validates :user, presence: true
  validates :actor, presence: true

  # Scopes
  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  # Instance methods
  def read?
    read_at.present?
  end

  def unread?
    !read?
  end

  def mark_as_read!
    update(read_at: Time.current) if unread?
  end

  def mark_as_unread!
    update(read_at: nil) if read?
  end
end

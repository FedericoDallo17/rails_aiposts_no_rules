class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  # Validations
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 500 }

  # Scopes
  scope :read, -> { where(read: true) }
  scope :unread, -> { where(read: false) }

  # Methods
  def mark_as_read!
    update!(read: true)
  end

  def mark_as_unread!
    update!(read: false)
  end
end

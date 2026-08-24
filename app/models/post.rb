# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user

  validates :body, presence: true, length: { maximum: 5000 }

  scope :recent, -> { order(created_at: :desc) }

  def liked_by?(user)
    return false if user.nil?

    likes.exists?(user_id: user.id)
  end
end

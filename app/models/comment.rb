# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: true, length: { maximum: 2000 }

  scope :recent, -> { order(created_at: :desc) }
end

class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  scope :positive, -> {order(score: :desc)}
  scope :negative, -> {order(score: :asc)}

  validates :comment, presence:true
end

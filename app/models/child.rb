class Child < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy

  enum gender: { boy: 0, girl: 1 }

  validates :name, presence: true
  validates :birthday, presence: true
  validates :gender, presence: true

end

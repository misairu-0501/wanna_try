class Post < ApplicationRecord
  belongs_to :user
  belongs_to :child
  belongs_to :genre
  has_many :post_comments, dependent: :destroy

  has_one_attached :post_image

  enum public_status: { range_all: 0, range_group: 1, range_myself: 2 }

  validates :title, presence: true, length:{maximum:30}
  validates :body, presence: true, length:{maximum:500}
  validates :shooting_date, presence: true
  validates :public_status, presence: true
  attribute :public_status, :integer, default: 0

  #投稿画像の取得
  def get_post_image
    (post_image.attached?) ? post_image : 'no_image.png'
  end
end

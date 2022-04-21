class Post < ApplicationRecord
  belongs_to :user
  belongs_to :child
  belongs_to :genre
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_one_attached :post_image

  enum public_status: { range_all: 0, range_group: 1, range_myself: 2 }

  validates :title, presence: true, length:{maximum:30}
  validates :body, presence: true, length:{maximum:500}
  validates :shooting_date, presence: true
  validates :public_status, presence: true
  attribute :public_status, :integer, default: 0

  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :favorite_count, -> {includes(:favorites).sort{|a,b| b.favorites.size <=> a.favorites.size}}

  #上記一行は下記のようにも記述できる
  # scope :favorite_count, -> {left_joins(:favorites).group(:id).order(Arel.sql('COUNT(favorites.id) desc'))}


  #投稿画像の取得
  def get_post_image
    unless post_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      post_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    post_image
  end

  #userが「いいね」しているかどうかしらべる(存在していればtrue)
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  #誕生日と日付から年齢を求める
  def age_calculation
    shooting_date = self.shooting_date.strftime("%Y%m%d").to_i
    birthday = Child.find(self.child_id).birthday.strftime("%Y%m%d").to_i
    age = ((shooting_date - birthday) / 10000).floor
  end

  #年齢が指定の範囲に入っているか確認する(入っている：true)
  def age_range?(age_lower, age_upper)
    post_age = self.age_calculation
    return (post_age.to_i >= age_lower.to_i) && (post_age.to_i <= age_upper.to_i)
  end

  #投稿の子供の性別が検索と一致するか確認する(一致する or 検索が「全て」：true)
  def ensure_gender?(search_gender)
    post_gender = self.child.gender
    return (search_gender == post_gender) || (search_gender == "all")
  end
end

class Child < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy

  enum gender: { boy: 0, girl: 1 }

  validates :name, presence: true
  validates :birthday, presence: true
  validates :gender, presence: true

  #誕生日から年齢を求める
  def now_age_calculation
    today = Date.today.strftime("%Y%m%d").to_i
    birthday = self.birthday.strftime("%Y%m%d").to_i
    age = ((today - birthday) / 10000).floor
  end
end

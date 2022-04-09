class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :children, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed # 自分がフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower # 自分をフォローしている人(自分がフォローされている人)

  validates :name, presence: true, uniqueness: true
  attribute :is_deleted, :boolean, default: false

  #フォローしたときの処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  #フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  #フォローしているか判断
  def following?(user)
    followings.include?(user)
  end
end


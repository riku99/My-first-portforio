class Discovery < ApplicationRecord
  # このクラス(Discovery)がある別のクラス(User)に従属していることを表し、従属先のクラスのidを外部キーとして抱えることを表す
  belongs_to :user

  # このモデル(Discovery)の主キーを外部キーとして抱えるモデル(Favorite)が存在し、そのレコードが複数登録可能であることを表す。デフォルトではdiscovery_id
  has_many :favorites, dependent: :destroy

  has_many :favo_user, through: :favorites, source: :user

  has_many :comments, dependent: :destroy

  validates :content, presence: true, length: { maximum: 150 }
  default_scope -> { order(created_at: :desc) }
end

class Favorite < ApplicationRecord
  # このクラス(Favorite)がある別のクラス(User)に従属していることを表し、従属先のクラスのidを外部キーとして抱えることを表す。外部キーのデフォルトはここではuser_id
  belongs_to :user
  belongs_to :discovery
  validates :user_id, presence: true
  validates :discovery_id, presence: true
end

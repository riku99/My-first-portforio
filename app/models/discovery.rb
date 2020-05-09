class Discovery < ApplicationRecord
  # このクラスがある別のクラス(User)に従属していることを表し、従属先のクラスのidを外部キーとして抱えることを表す
  belongs_to :user
  validates :content, presence: true, length: { maximum: 150 }
  default_scope -> { order(created_at: :desc) }
end

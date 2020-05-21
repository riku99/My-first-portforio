class Favorite < ApplicationRecord
  # このクラス(Favorite)がある別のクラス(User)に従属していることを表し、従属先のクラスのidを外部キーとして抱えることを表す。外部キーのデフォルトはここではuser_id
  belongs_to :user
  belongs_to :discovery, optional: true   # optionalでカラムのnullを許可する
  belongs_to :comment, optional: true

  validates :user_id, presence: true
  validates :discovery_or_comment, presence: true

  private

  # discovery_idかcomment_idがあればtrue
  def discovery_or_comment
    discovery_id.present? || comment_id.present?
  end

end

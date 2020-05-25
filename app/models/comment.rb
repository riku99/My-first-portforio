class Comment < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :favo_user, through: :favorites, source: :user
  has_many :forcomments, class_name: "Comment", foreign_key: "forcomment_id"

  belongs_to :user
  belongs_to :discovery, optional: true
  belongs_to :forcomment, class_name: "Comment", optional: true

  validates :user_id, presence: true
  validates :discovery_or_forcomment, presence: true
  validates :content, presence: true, length: { maximum: 150 }

  default_scope -> { order(created_at: :desc) }

  private

  def discovery_or_forcomment
    discovery_id.present? || forcomment_id.present?
  end

end

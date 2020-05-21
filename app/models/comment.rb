class Comment < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :favo_user, through: :favorites, source: :user
  belongs_to :user
  belongs_to :discovery

  validates :user_id, presence: true
  validates :discovery_id, presence: true
  validates :content, presence: true, length: { maximum: 150 }

  default_scope -> { order(created_at: :desc) }
end

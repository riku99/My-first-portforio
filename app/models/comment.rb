class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :discovery
  validates :user_id, presence: true
  validates :discovery_id, presence: true
  validates :content, presence: true, length: { maximum: 150 }

  default_scope -> { order(created_at: :desc) }
end

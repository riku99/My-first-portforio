class Discovery < ApplicationRecord
  validates :content, presence: true, length: { maximum: 150 }
  default_scope -> { order(created_at: :desc) }
end

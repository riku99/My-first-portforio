class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"    # UserのidとRellahionshipのfollowed_idが等しいUserを返す
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end

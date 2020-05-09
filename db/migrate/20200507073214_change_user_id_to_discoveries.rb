class ChangeUserIdToDiscoveries < ActiveRecord::Migration[6.0]
  def change
    change_column :discoveries, :user_id, :integer, null: false
  end
end

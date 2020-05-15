class AddIndexFavoritesUserIdDiscoveryId < ActiveRecord::Migration[6.0]
  def change
    add_index :favorites, [:user_id, :discovery_id], unique: true
  end
end

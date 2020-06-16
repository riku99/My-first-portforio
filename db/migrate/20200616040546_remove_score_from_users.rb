class RemoveScoreFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :score, :integer
    remove_column :users, :target_score, :integer
  end
end

class ChangeColumnToAllowNull < ActiveRecord::Migration[6.0]
  def up
    change_column :comments, :discovery_id, :integer, null: true
  end

  def down
    change_column :comments, :discovery_id, :integer, null: false
  end
end

class AddAcountIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :acount_id, :string
  end
end

class AddColumnToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :forcomment_id, :integer
  end
end

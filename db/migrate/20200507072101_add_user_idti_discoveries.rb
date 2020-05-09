class AddUserIdtiDiscoveries < ActiveRecord::Migration[6.0]
  def up
    add_reference :discoveries, :user, index: true
  end

  def down
    remove_reference :discoveries, :user, index: true
  end
end

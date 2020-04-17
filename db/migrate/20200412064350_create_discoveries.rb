class CreateDiscoveries < ActiveRecord::Migration[6.0]
  def change
    create_table :discoveries do |t|
      t.text :content

      t.timestamps
    end
  end
end

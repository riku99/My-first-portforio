class AddReferencesToFavorites < ActiveRecord::Migration[6.0]
  def change
    add_reference :favorites, :comment, foreign_key: true
  end
end

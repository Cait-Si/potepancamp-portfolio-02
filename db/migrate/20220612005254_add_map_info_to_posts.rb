class AddMapInfoToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :address, :string, null: false
    add_column :posts, :latitude, :float
    add_column :posts, :longitude, :float
  end
end

class AddPostImageToPost < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :post_image, :string, null: false
  end
end

class AddFinishedToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :finished, :boolean, default: false, null: false
  end
end

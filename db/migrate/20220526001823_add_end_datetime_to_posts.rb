class AddEndDatetimeToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :end_datetime, :datetime, null: false
  end
end

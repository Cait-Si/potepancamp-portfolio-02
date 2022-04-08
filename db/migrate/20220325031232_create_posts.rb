class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title,       null: false
      t.integer :person,     null: false
      t.datetime :datetime,  null: false
      t.string :location,    null: false
      t.string :level,       null: false
      t.text :description,   null: false
      t.datetime :deadline,  null: false
      t.references :user,    null: false, foreign_key: true

      t.timestamps
    end
  end
end

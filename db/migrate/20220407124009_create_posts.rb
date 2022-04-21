class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :child_id
      t.integer :genre_id
      t.string :title
      t.text :body
      t.date :shooting_date
      t.integer :public_status

      t.timestamps
    end
  end
end

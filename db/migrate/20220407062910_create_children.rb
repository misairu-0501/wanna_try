class CreateChildren < ActiveRecord::Migration[6.1]
  def change
    create_table :children do |t|
      t.integer :user_id
      t.string :name
      t.date :birthday
      t.integer :gender

      t.timestamps
    end
  end
end

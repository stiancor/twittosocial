class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :micropost_id
      t.integer :user_id

      t.timestamps
    end

    add_index :likes, :micropost_id
    add_index :likes, :user_id
    add_index :likes, [:user_id, :micropost_id], unique: true
  end
end

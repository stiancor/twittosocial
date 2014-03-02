class CreateEventComments < ActiveRecord::Migration
  def change
    create_table :event_comments do |t|
      t.string :content
      t.integer :user_id
      t.integer :event_id
      t.timestamps
    end
    add_index :event_comments, [:event_id, :created_at]
  end
end

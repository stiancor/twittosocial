class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :location
      t.datetime :start_time
      t.datetime :end_time
      t.text :invitation
      t.integer :user_id

      t.timestamps
    end
  end
end

class CreateEventInvites < ActiveRecord::Migration
  def change
    create_table :event_invites do |t|
      t.integer :attend_status
      t.integer :event_id
      t.integer :user_id
      t.timestamps
    end
  end
end

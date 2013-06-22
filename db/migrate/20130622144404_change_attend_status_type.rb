class ChangeAttendStatusType < ActiveRecord::Migration
  def change
    change_column :event_invites, :attend_status, :string, default: 'no_reply'
  end
end

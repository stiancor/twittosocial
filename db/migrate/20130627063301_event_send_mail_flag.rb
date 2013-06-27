class EventSendMailFlag < ActiveRecord::Migration
  def change
    add_column :events, :send_mail, :boolean, default: false
  end
end

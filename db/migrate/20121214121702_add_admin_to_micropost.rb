class AddAdminToMicropost < ActiveRecord::Migration
  def change
    add_column :microposts, :admin_message, :boolean
  end
end

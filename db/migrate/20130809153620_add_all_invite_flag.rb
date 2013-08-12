class AddAllInviteFlag < ActiveRecord::Migration
  def change
    add_column :events, :invite_all, :boolean, default: true
  end

end

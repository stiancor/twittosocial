class ForgottenPasswordKey < ActiveRecord::Migration
  def change
    add_column :users, :forgotten_password_key, :string
  end

end

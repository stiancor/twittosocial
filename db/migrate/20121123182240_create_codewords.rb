class CreateCodewords < ActiveRecord::Migration
  def change
    create_table :codewords do |t|
      t.string :codeword

      t.timestamps
    end
  end
end

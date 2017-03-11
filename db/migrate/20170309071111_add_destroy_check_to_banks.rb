class AddDestroyCheckToBanks < ActiveRecord::Migration
  def change
    add_column :banks, :destroy_check, :boolean, default: false, null: false
  end
end

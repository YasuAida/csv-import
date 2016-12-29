class AddDestroyCheckToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :destroy_check, :boolean, default: false, null: false
  end
end

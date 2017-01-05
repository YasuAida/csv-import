class AddDestroyCheckToExchanges < ActiveRecord::Migration
  def change
    add_column :exchanges, :destroy_check, :boolean, default: false, null: false
  end
end

class AddDestroyCheckToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :destroy_check, :boolean, default: false, null: false
  end
end

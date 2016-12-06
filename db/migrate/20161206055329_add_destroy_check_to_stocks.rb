class AddDestroyCheckToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :destroy_check, :boolen
  end
end

class AddDestroyCheckToSales < ActiveRecord::Migration
  def change
    add_column :sales, :destroy_check, :boolean, default: false, null: false
  end
end

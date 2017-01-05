class AddDestroyCheckToCurrencies < ActiveRecord::Migration
  def change
    add_column :currencies, :destroy_check, :boolean, default: false, null: false
  end
end

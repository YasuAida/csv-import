class AddDestroyCheckToRakutenCosts < ActiveRecord::Migration
  def change
    add_column :rakuten_costs, :destroy_check, :boolean, default: false, null: false
  end
end

class AddSoldoutCheckToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :soldout_check, :boolean, default: false, null: false
    change_column_default :stocks, :sold_unit, 0
  end
end

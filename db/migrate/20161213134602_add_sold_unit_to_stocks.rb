class AddSoldUnitToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :sold_unit, :integer
  end
end

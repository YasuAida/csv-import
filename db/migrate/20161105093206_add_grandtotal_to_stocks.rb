class AddGrandtotalToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :grandtotal, :integer
  end
end

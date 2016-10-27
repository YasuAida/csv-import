class AddSkurateToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :sku, :string
    add_column :stocks, :rate, :float
  end
end

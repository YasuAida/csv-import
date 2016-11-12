class AddGoodsamountToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :goods_amount, :integer
  end
end

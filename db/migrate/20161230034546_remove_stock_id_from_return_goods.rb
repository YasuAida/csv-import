class RemoveStockIdFromReturnGoods < ActiveRecord::Migration
  def change
    remove_column :return_goods, :stock_id, :integer
  end
end

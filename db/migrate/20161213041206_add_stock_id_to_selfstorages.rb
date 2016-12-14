class AddStockIdToSelfstorages < ActiveRecord::Migration
  def change
    add_column :selfstorages, :stock_id, :integer
  end
end

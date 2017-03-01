class RemoveAsinIndexFromStockledgers < ActiveRecord::Migration
  def change
    remove_index :stockledgers, :asin
    remove_index :stockledgers, :sku
  end
end

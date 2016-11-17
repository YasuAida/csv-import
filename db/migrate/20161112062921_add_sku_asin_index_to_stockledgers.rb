class AddSkuAsinIndexToStockledgers < ActiveRecord::Migration
  def change
    add_index :stockledgers, :sku
    add_index :stockledgers, :asin
  end
end

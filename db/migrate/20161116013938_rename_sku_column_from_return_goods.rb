class RenameSkuColumnFromReturnGoods < ActiveRecord::Migration
  def change
    rename_column :return_goods, :sku, :old_sku
  end
end

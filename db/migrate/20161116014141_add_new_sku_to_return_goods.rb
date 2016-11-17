class AddNewSkuToReturnGoods < ActiveRecord::Migration
  def change
    add_column :return_goods, :new_sku, :string
    add_column :return_goods, :disposal, :boolean, default: false, null: false  
  end
end

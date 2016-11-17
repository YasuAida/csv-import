class CreateReturnGoods < ActiveRecord::Migration
  def change
    create_table :return_goods do |t|
      t.string :order_num
      t.string :sku

      t.timestamps null: false
    end
  end
end

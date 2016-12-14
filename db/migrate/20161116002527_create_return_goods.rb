class CreateReturnGoods < ActiveRecord::Migration
  def change
    create_table :return_goods do |t|
      t.references :stock, index: true, foreign_key: true         
      t.string :order_num
      t.string :sku

      t.timestamps null: false
    end
  end
end

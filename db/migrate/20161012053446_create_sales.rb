class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.date :date
      t.string :order_num
      t.string :sku
      t.string :kind_of_transaction
      t.string :kind_of_payment
      t.string :detail_of_payment
      t.integer :amount
      t.integer :quantity
      t.string :goods_name

      t.timestamps null: false
    end
  end
end

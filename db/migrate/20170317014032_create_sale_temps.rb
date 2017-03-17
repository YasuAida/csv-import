class CreateSaleTemps < ActiveRecord::Migration
  def change
    create_table :sale_temps do |t|
      t.references :user, index: true, foreign_key: true
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

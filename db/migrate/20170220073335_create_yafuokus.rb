class CreateYafuokus < ActiveRecord::Migration
  def change
    create_table :yafuokus do |t|
      t.references :user, index: true, foreign_key: true
      t.references :stock, index: true, foreign_key: true
      t.date :date
      t.string :order_num
      t.string :sku
      t.integer :unit_price
      t.integer :number, default: 1
      t.integer :sales_amount
      t.integer :cogs_amount
      t.integer :commission
      t.integer :shipping_cost
      t.date :money_receipt_date
      t.date :shipping_pay_date
      t.boolean :destroy_check, default: false, null: false

      t.timestamps null: false
    end
  end
end

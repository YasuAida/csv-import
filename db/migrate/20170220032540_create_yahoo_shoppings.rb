class CreateYahooShoppings < ActiveRecord::Migration
  def change
    create_table :yahoo_shoppings do |t|
      t.references :user, index: true, foreign_key: true
      t.date :date
      t.string :order_id
      t.integer :unit_price
      t.integer :number, default: 1
      t.integer :sales_amount
      t.string :settlement
      t.integer :settle_commission
      t.integer :affiliate_commission
      t.integer :point_commission
      t.integer :total_commissions
      t.integer :cogs_amount
      t.integer :shipping_cost
      t.date :money_receipt_date
      t.date :shipping_pay_date
      t.boolean :destroy_check, default: false, null: false

      t.timestamps null: false
    end
  end
end

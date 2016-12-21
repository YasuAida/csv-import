class CreateStockreturns < ActiveRecord::Migration
  def change
    create_table :stockreturns do |t|
      t.references :stock, index: true, foreign_key: true
      t.date :date
      t.string :sku
      t.string :asin
      t.string :goods_name
      t.integer :number
      t.float :unit_price
      t.float :rate
      t.integer :goods_amount
      t.date :money_paid
      t.string :purchase_from
      t.string :currency

      t.timestamps null: false
    end
  end
end

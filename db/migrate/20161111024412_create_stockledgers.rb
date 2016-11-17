class CreateStockledgers < ActiveRecord::Migration
  def change
    create_table :stockledgers do |t|
      t.date :transaction_date
      t.string :sku
      t.string :asin
      t.string :goods_name
      t.integer :number
      t.integer :unit_price
      t.integer :grandtotal

      t.timestamps null: false
    end
  end
end

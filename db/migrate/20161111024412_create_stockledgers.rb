class CreateStockledgers < ActiveRecord::Migration
  def change
    create_table :stockledgers do |t|
      t.references :stock, index: true, foreign_key: true
      t.date :sold_date
      t.string :sku
      t.string :asin
      t.string :goods_name
      t.string :number
      t.string :grandtotal

      t.timestamps null: false
    end
  end
end

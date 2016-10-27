class CreateStockaccepts < ActiveRecord::Migration
  def change
    create_table :stockaccepts do |t|
      t.date :date
      t.string :fnsku
      t.string :sku
      t.string :goods_name
      t.integer :quantity
      t.string :fba_number
      t.string :fc

      t.timestamps null: false
    end
  end
end

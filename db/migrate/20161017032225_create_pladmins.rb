class CreatePladmins < ActiveRecord::Migration
  def change
    create_table :pladmins do |t|
      t.date :date
      t.string :order_num
      t.string :sku
      t.string :goods_name
      t.integer :sale_amount
      t.integer :commission
      t.integer :cgs_amount

      t.timestamps null: false
    end
  end
end

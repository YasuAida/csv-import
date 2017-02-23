class CreateRakutens < ActiveRecord::Migration
  def change
    create_table :rakutens do |t|
      t.references :user, index: true, foreign_key: true      
      t.string :order_num
      t.date :sale_date
      t.string :goods_name
      t.string :pc_mobile
      t.integer :unit_price
      t.integer :number
      t.integer :shipping_cost
      t.integer :consumption_tax
      t.integer :cod_fee
      t.integer :shop_coupon
      t.integer :commission
      t.integer :vest_point
      t.integer :system_improvement
      t.integer :credit_commission
      t.integer :data_processing
      t.string :settlement
      t.integer :use_point
      t.integer :use_coupon
      t.date :receipt_date

      t.timestamps null: false
    end
  end
end

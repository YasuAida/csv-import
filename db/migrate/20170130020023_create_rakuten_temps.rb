class CreateRakutenTemps < ActiveRecord::Migration
  def change
    create_table :rakuten_temps do |t|
      t.references :user, index: true, foreign_key: true
      t.string :order_num
      t.date :order_date
      t.date :sale_date
      t.string :kind_of_card
      t.string :brand
      t.string :content
      t.string :installment
      t.integer :receipt_amount
      t.float :rate

      t.timestamps null: false
    end
  end
end

class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.references :user, index: true, foreign_key: true      
      t.date :date
      t.string :asin
      t.string :goods_name
      t.integer :number
      t.float :unit_price
      t.date :money_paid
      t.string :purchase_from
      t.string :currency

      t.timestamps null: false
    end
  end
end

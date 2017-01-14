class CreateDummyStocks < ActiveRecord::Migration
  def change
    create_table :dummy_stocks do |t|
      t.references :user, index: true, foreign_key: true       
      t.references :stock, index: true, foreign_key: true
      t.date :date
      t.integer :number
      t.boolean :destroy_check, default: false, null: false

      t.timestamps null: false
    end
  end
end

class CreateDisposals < ActiveRecord::Migration
  def change
    create_table :disposals do |t|
      t.references :user, index: true, foreign_key: true       
      t.references :stock, index: true, foreign_key: true
      t.date :date
      t.string :order_num
      t.string :sku
      t.integer :number      

      t.timestamps null: false
    end
  end
end

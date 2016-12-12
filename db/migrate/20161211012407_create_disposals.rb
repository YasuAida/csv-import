class CreateDisposals < ActiveRecord::Migration
  def change
    create_table :disposals do |t|
      t.date :date
      t.string :order_num
      t.string :sku
      t.integer :number      

      t.timestamps null: false
    end
  end
end

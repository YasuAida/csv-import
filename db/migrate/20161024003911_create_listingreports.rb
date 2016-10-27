class CreateListingreports < ActiveRecord::Migration
  def change
    create_table :listingreports do |t|
      t.string :sku
      t.string :asin
      t.integer :price
      t.integer :quantity

      t.timestamps null: false
    end
  end
end

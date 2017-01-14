class CreateListingreports < ActiveRecord::Migration
  def change
    create_table :listingreports do |t|
      t.references :user, index: true, foreign_key: true
      t.string :sku
      t.string :asin
      t.integer :price
      t.integer :quantity

      t.timestamps null: false
    end
  end
end

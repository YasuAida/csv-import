class CreateSelfstorages < ActiveRecord::Migration
  def change
    create_table :selfstorages do |t|
      t.string :sku

      t.timestamps null: false
    end
  end
end

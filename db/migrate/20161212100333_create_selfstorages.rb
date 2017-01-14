class CreateSelfstorages < ActiveRecord::Migration
  def change
    create_table :selfstorages do |t|
      t.references :user, index: true, foreign_key: true  
      t.string :sku

      t.timestamps null: false
    end
  end
end

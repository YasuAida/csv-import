class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.references :user, index: true, foreign_key: true      
      t.date :date, null: false
      t.string :country, null: false
      t.float :rate, null: false, default: 0

      t.timestamps null: false
      t.index [:date, :country], unique: true, name: 'exchange_index'
    end
  end
end

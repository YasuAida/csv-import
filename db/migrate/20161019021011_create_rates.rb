class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.float :usd
      t.float :eur
      t.float :cny
      t.float :thb
      t.float :krw
      t.float :other

      t.timestamps null: false
    end
  end
end

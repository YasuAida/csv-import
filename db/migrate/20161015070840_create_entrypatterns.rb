class CreateEntrypatterns < ActiveRecord::Migration
  def change
    create_table :entrypatterns do |t|
      t.string :sku
      t.string :kind_of_transaction
      t.string :kind_of_payment
      t.string :detail_of_payment
      t.string :handling
      t.string :debt
      t.string :credit

      t.timestamps null: false
    end
  end
end

class CreateExpenseRelations < ActiveRecord::Migration
  def change
    create_table :expense_relations do |t|
      t.references :stock, index: true, foreign_key: true
      t.references :subexpense, index: true, foreign_key: true

      t.timestamps null: false
      
      t.index [:stock_id, :subexpense_id], unique: true
    end
  end
end

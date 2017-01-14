class CreateExpenseMethods < ActiveRecord::Migration
  def change
    create_table :expense_methods do |t|
      t.references :user, index: true, foreign_key: true      
      t.string :method

      t.timestamps null: false
    end
  end
end

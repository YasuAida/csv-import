class CreateExpenseMethods < ActiveRecord::Migration
  def change
    create_table :expense_methods do |t|
      t.string :method

      t.timestamps null: false
    end
  end
end

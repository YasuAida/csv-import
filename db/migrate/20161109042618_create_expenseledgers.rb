class CreateExpenseledgers < ActiveRecord::Migration
  def change
    create_table :expenseledgers do |t|    
      t.date :date
      t.string :content
      t.integer :amount
      t.float :rate
      t.date :money_paid
      t.string :purchase_from
      t.string :currency

      t.timestamps null: false
    end
  end
end

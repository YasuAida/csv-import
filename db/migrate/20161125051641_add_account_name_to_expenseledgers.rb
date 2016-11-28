class AddAccountNameToExpenseledgers < ActiveRecord::Migration
  def change
    add_column :expenseledgers, :account_name, :string
  end
end

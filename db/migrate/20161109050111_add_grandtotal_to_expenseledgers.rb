class AddGrandtotalToExpenseledgers < ActiveRecord::Migration
  def change
    add_column :expenseledgers, :grandtotal, :integer
  end
end

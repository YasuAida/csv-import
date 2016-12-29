class AddDestroyCheckToExpenseledgers < ActiveRecord::Migration
  def change
    add_column :expenseledgers, :destroy_check, :boolean, default: false, null: false
  end
end

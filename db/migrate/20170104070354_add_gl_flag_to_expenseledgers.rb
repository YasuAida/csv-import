class AddGlFlagToExpenseledgers < ActiveRecord::Migration
  def change
    add_column :expenseledgers, :gl_flag, :boolean, default: false, null: false
  end
end

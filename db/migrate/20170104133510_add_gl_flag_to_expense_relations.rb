class AddGlFlagToExpenseRelations < ActiveRecord::Migration
  def change
    add_column :expense_relations, :gl_flag, :boolean, default: false, null: false
  end
end

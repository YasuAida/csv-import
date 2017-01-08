class AddRelationFlagToExpenseRelations < ActiveRecord::Migration
  def change
    add_column :expense_relations, :relation_flag, :boolean, default: false, null: false
  end
end

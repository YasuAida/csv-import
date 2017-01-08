class RemoveGlFlagFromPladmins < ActiveRecord::Migration
  def change
    remove_column :pladmins, :gl_flag, :boolean
    remove_column :stocks, :gl_flag, :boolean
    remove_column :stocks, :ledger_flag, :boolean
    remove_column :stockreturns, :gl_flag, :boolean
    remove_column :return_goods, :gl_flag, :boolean
    remove_column :disposals, :gl_flag, :boolean
    remove_column :subexpenses, :gl_flag, :boolean
    remove_column :expense_relations, :gl_flag, :boolean
    remove_column :expense_relations, :relation_flag, :boolean
    remove_column :expenseledgers, :gl_flag, :boolean
    remove_column :vouchers, :gl_flag, :boolean
  end
end

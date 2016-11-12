class RenameDebtColumnToEntrypatterns < ActiveRecord::Migration
  def change
    rename_column :entrypatterns, :debt, :debit_account
    rename_column :entrypatterns, :credit, :credit_account
  end
end

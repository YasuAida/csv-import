class RemoveDebitAccountFromEntrypatterns < ActiveRecord::Migration
  def change
    remove_column :entrypatterns, :debit_account, :string
    remove_column :entrypatterns, :debit_subaccount, :string
    remove_column :entrypatterns, :debit_taxcode, :string
    remove_column :entrypatterns, :credit_account, :string
    remove_column :entrypatterns, :credit_subaccount, :string
    remove_column :entrypatterns, :credit_taxcode, :string    
  end
end

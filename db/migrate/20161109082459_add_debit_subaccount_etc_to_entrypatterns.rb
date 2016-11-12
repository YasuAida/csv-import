class AddDebitSubaccountEtcToEntrypatterns < ActiveRecord::Migration
  def change
    add_column :entrypatterns, :debit_subaccount, :string
    add_column :entrypatterns, :debit_taxcode, :string
    add_column :entrypatterns, :credit_subaccount, :string
    add_column :entrypatterns, :credit_taxcode, :string
  end
end

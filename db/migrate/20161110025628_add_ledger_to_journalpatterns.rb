class AddLedgerToJournalpatterns < ActiveRecord::Migration
  def change
    add_column :journalpatterns, :ledger, :string
  end
end

class AddReferenceToJournalpatterns < ActiveRecord::Migration
  def change
    add_column :journalpatterns, :reference, :string
  end
end

class RemoveReferenceFromJournalpatterns < ActiveRecord::Migration
  def change
    remove_column :journalpatterns, :reference, :string
  end
end

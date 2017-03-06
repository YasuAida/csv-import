class AddDestroyCheckToJournalpatterns < ActiveRecord::Migration
  def change
    add_column :journalpatterns, :destroy_check, :boolean, default: false, null: false
  end
end

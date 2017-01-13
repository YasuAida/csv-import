class AddDestroyCheckToEntrypatterns < ActiveRecord::Migration
  def change
    add_column :entrypatterns, :destroy_check, :boolean, default: false, null: false
  end
end

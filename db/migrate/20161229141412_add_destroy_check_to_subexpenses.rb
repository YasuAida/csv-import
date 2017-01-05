class AddDestroyCheckToSubexpenses < ActiveRecord::Migration
  def change
    add_column :subexpenses, :destroy_check, :boolean, default: false, null: false
  end
end

class AddDestroyCheckToGeneralledgers < ActiveRecord::Migration
  def change
    add_column :generalledgers, :destroy_check, :boolean, default: false, null: false
  end
end

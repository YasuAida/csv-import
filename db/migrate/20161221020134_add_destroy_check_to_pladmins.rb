class AddDestroyCheckToPladmins < ActiveRecord::Migration
  def change
    add_column :pladmins, :destroy_check, :boolean, default: false, null: false
  end
end

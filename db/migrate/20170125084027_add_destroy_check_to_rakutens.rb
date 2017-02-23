class AddDestroyCheckToRakutens < ActiveRecord::Migration
  def change
    add_column :rakutens, :destroy_check, :boolean, default: false, null: false
  end
end

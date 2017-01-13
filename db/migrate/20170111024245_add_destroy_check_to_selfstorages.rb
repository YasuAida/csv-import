class AddDestroyCheckToSelfstorages < ActiveRecord::Migration
  def change
    add_column :selfstorages, :destroy_check, :boolean, default: false, null: false
  end
end

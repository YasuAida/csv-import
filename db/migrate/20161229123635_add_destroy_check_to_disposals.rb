class AddDestroyCheckToDisposals < ActiveRecord::Migration
  def change
    add_column :disposals, :destroy_check, :boolean, default: false, null: false
  end
end

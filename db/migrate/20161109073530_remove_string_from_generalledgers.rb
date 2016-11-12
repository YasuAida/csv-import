class RemoveStringFromGeneralledgers < ActiveRecord::Migration
  def change
    remove_column :generalledgers, :string, :string
  end
end

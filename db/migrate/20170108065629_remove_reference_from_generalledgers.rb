class RemoveReferenceFromGeneralledgers < ActiveRecord::Migration
  def change
    remove_column :generalledgers, :reference, :string
  end
end

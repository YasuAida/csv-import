class RenameQuantityColumnToPladmins < ActiveRecord::Migration
  def change
    rename_column :pladmins, :unit, :quantity
  end
end

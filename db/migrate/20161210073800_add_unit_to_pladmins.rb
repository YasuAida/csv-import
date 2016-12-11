class AddUnitToPladmins < ActiveRecord::Migration
  def change
    add_column :pladmins, :unit, :integer
  end
end

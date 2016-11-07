class RemoveGrandtotalFromAllocationcosts < ActiveRecord::Migration
  def change
    remove_column :allocationcosts, :grandtotal, :integer
  end
end

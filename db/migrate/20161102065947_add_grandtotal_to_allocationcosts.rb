class AddGrandtotalToAllocationcosts < ActiveRecord::Migration
  def change
    add_column :allocationcosts, :grandtotal, :integer
  end
end

class RemoveAllocFlagFromAllocationcosts < ActiveRecord::Migration
  def change
    remove_column :allocationcosts, :alloc_flag, :boolean
  end
end

class RenameGlFlagColumnToAllocationcosts < ActiveRecord::Migration
  def change
    rename_column :allocationcosts, :gl_flag, :alloc_flag
  end
end

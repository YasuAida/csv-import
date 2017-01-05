class AddGlFlagToAllocationcosts < ActiveRecord::Migration
  def change
    add_column :allocationcosts, :gl_flag, :boolean, default: false, null: false
  end
end

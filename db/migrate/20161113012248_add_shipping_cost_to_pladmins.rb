class AddShippingCostToPladmins < ActiveRecord::Migration
  def change
    add_column :pladmins, :shipping_cost, :integer
  end
end

class AddGrandtotalToStockreturns < ActiveRecord::Migration
  def change
    add_column :stockreturns, :grandtotal, :integer
  end
end

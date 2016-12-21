class AddDestroyCheckToStockreturns < ActiveRecord::Migration
  def change
    add_column :stockreturns, :destroy_check, :boolean, default: false, null: false
  end
end

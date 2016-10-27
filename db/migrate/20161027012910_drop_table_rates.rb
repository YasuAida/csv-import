class DropTableRates < ActiveRecord::Migration
  def change
    drop_table :rates
  end
end

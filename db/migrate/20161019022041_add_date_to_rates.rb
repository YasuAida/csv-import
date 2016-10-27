class AddDateToRates < ActiveRecord::Migration
  def change
    add_column :rates, :date, :date
  end
end

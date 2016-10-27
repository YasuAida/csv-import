class AddRateToSubexpenses < ActiveRecord::Migration
  def change
    add_column :subexpenses, :rate, :float
  end
end

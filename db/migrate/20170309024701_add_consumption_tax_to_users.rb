class AddConsumptionTaxToUsers < ActiveRecord::Migration
  def change
    add_column :users, :consumption_tax, :string
  end
end

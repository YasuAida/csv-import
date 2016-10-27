class AddMethodToCurrencies < ActiveRecord::Migration
  def change
    add_column :currencies, :method, :string
  end
end

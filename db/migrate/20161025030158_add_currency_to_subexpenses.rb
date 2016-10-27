class AddCurrencyToSubexpenses < ActiveRecord::Migration
  def change
    add_column :subexpenses, :currency, :string
  end
end

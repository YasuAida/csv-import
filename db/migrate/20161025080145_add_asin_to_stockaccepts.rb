class AddAsinToStockaccepts < ActiveRecord::Migration
  def change
    add_column :stockaccepts, :asin, :string
  end
end

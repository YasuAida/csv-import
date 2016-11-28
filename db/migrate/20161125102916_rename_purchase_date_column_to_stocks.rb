class RenamePurchaseDateColumnToStocks < ActiveRecord::Migration
  def change
    rename_column :stocks, :purchase_date, :date
  end
end

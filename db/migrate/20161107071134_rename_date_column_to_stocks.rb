class RenameDateColumnToStocks < ActiveRecord::Migration
  def change
    rename_column :stocks, :date, :purchase_date
  end
end

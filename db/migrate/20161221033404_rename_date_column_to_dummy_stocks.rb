class RenameDateColumnToDummyStocks < ActiveRecord::Migration
  def change
    rename_column :dummy_stocks, :date, :sale_date
    add_column :dummy_stocks, :cancel_date, :date
  end
end

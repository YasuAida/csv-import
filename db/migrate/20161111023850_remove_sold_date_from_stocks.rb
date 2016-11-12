class RemoveSoldDateFromStocks < ActiveRecord::Migration
  def change
    remove_column :stocks, :sold_date, :date
  end
end

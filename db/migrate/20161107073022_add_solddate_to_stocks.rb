class AddSolddateToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :sold_date, :date
  end
end

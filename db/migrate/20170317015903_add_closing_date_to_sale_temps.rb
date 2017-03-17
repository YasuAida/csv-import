class AddClosingDateToSaleTemps < ActiveRecord::Migration
  def change
    add_column :sale_temps, :closing_date, :date
  end
end

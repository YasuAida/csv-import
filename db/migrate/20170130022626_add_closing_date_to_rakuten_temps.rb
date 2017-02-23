class AddClosingDateToRakutenTemps < ActiveRecord::Migration
  def change
    add_column :rakuten_temps, :closing_date, :date
  end
end

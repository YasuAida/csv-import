class AddTotalSalesToRakutenTemps < ActiveRecord::Migration
  def change
    add_column :rakuten_temps, :total_sales, :integer
  end
end

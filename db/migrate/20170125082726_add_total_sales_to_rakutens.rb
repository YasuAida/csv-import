class AddTotalSalesToRakutens < ActiveRecord::Migration
  def change
    add_column :rakutens, :total_sales, :integer
    add_column :rakutens, :total_commissions, :integer
  end
end

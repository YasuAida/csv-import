class RenameMoneyReceiveColumnToSales < ActiveRecord::Migration
  def change
    rename_column :sales, :money_receive, :closing_date
  end
end

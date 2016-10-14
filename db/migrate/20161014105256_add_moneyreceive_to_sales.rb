class AddMoneyreceiveToSales < ActiveRecord::Migration
  def change
    add_column :sales, :money_receive, :date
  end
end

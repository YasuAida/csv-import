class AddMoneyreceiveToPladmins < ActiveRecord::Migration
  def change
    add_column :pladmins, :money_receive, :date
  end
end

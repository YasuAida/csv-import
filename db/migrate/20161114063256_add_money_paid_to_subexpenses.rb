class AddMoneyPaidToSubexpenses < ActiveRecord::Migration
  def change
    add_column :subexpenses, :money_paid, :date
  end
end

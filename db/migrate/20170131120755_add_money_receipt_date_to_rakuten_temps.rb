class AddMoneyReceiptDateToRakutenTemps < ActiveRecord::Migration
  def change
    add_column :rakuten_temps, :money_receipt_date, :date
  end
end

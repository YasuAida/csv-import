class AddLedgerFlagToStocks < ActiveRecord::Migration
  def change
    add_column :stocks, :ledger_flag, :boolean, default: false, null: false
  end
end

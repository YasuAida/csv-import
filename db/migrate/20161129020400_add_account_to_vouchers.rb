class AddAccountToVouchers < ActiveRecord::Migration
  def change
    add_column :vouchers, :debit_subaccount, :string
    add_column :vouchers, :debit_taxcode, :string
    add_column :vouchers, :credit_subaccount, :string
    add_column :vouchers, :credit_taxcode, :string
  end
end

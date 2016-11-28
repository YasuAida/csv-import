class AddCommissionDateToPladmins < ActiveRecord::Migration
  def change
    add_column :pladmins, :commission_pay_date, :date
    add_column :pladmins, :shipping_pay_date, :date
  end
end

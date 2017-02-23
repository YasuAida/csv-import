class AddBillingDateToRakutens < ActiveRecord::Migration
  def change
    add_column :rakutens, :billing_date, :date
  end
end

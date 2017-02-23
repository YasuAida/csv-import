class AddShippingPaymentToRakutens < ActiveRecord::Migration
  def change
    add_column :rakutens, :shipping_payment, :integer
  end
end

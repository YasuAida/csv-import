class RemovePaymentDetailFromYahooShoppings < ActiveRecord::Migration
  def change
    remove_column :yahoo_shoppings, :payment_detail, :string
    remove_column :yahoo_shoppings, :settle_commission, :integer
    remove_column :yahoo_shoppings, :affiliate_commission, :integer
    remove_column :yahoo_shoppings, :point_commission, :integer
    remove_column :yahoo_shoppings, :receipt_detail, :string
    
    rename_column :yahoo_shoppings, :total_commissions, :commission
  end
end

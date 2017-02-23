class AddReceiptDetailToYahooShoppings < ActiveRecord::Migration
  def change
    add_column :yahoo_shoppings, :receipt_detail, :string
    rename_column :yahoo_shoppings, :settlement, :payment_detail    
  end
end

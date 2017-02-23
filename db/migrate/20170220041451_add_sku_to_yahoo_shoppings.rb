class AddSkuToYahooShoppings < ActiveRecord::Migration
  def change
    add_column :yahoo_shoppings, :sku, :string
  end
end

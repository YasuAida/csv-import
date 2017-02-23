class AddGoodsNameToYahooShoppings < ActiveRecord::Migration
  def change
    add_column :yahoo_shoppings, :goods_name, :string
  end
end

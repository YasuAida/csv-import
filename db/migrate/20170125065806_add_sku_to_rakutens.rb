class AddSkuToRakutens < ActiveRecord::Migration
  def change
    add_column :rakutens, :sku, :string
  end
end

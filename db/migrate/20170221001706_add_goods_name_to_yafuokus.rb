class AddGoodsNameToYafuokus < ActiveRecord::Migration
  def change
    add_column :yafuokus, :goods_name, :string
  end
end

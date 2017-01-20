class AddDefaultToReturnGoods < ActiveRecord::Migration
  def change
    change_column_default :return_goods, :number, 1
  end
end

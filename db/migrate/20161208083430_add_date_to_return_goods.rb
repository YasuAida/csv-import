class AddDateToReturnGoods < ActiveRecord::Migration
  def change
    add_column :return_goods, :date, :date
  end
end

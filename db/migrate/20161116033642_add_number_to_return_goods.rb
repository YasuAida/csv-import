class AddNumberToReturnGoods < ActiveRecord::Migration
  def change
    add_column :return_goods, :number, :integer
  end
end

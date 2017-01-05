class AddDestroyCheckToReturnGoods < ActiveRecord::Migration
  def change
    add_column :return_goods, :destroy_check, :boolean, default: false, null: false
  end
end

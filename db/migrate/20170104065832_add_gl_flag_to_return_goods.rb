class AddGlFlagToReturnGoods < ActiveRecord::Migration
  def change
    add_column :return_goods, :gl_flag, :boolean, default: false, null: false
  end
end

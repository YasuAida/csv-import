class RemoveDisposalFromReturnGoods < ActiveRecord::Migration
  def change
    remove_column :return_goods, :disposal, :boolean
  end
end

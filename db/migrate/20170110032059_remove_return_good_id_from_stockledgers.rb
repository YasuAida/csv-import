class RemoveReturnGoodIdFromStockledgers < ActiveRecord::Migration
  def change
    remove_column :stockledgers, :return_good_id, :integer
  end
end

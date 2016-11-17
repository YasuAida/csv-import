class AddClassificationToStockledgers < ActiveRecord::Migration
  def change
    add_column :stockledgers, :classification, :string
  end
end

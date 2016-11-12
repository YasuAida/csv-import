class AddAmountToGeneralledgers < ActiveRecord::Migration
  def change
    add_column :generalledgers, :amount, :integer
  end
end

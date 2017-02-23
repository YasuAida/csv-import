class AddReceiptAmountToRakutens < ActiveRecord::Migration
  def change
    add_column :rakutens, :receipt_amount, :integer
  end
end

class RenameReceiptDateColumnToRakutens < ActiveRecord::Migration
  def change
    rename_column :rakutens, :receipt_date, :money_receipt_date
    add_column :rakutens, :point_receipt_date, :date
  end
end

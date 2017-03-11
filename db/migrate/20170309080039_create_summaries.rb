class CreateSummaries < ActiveRecord::Migration
  def change
    create_table :summaries do |t|
      t.references :user, index: true, foreign_key: true
      t.date :closing_date
      t.integer :total_sales
      t.string :bank
      t.date :money_receipt_date
      t.boolean :destroy_check, default: false, null: false

      t.timestamps null: false
    end
  end
end

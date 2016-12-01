class CreateFinancialStatements < ActiveRecord::Migration
  def change
    create_table :financial_statements do |t|
      t.date :period_start
      t.string :monthly_yearly
      t.string :account
      t.integer :amount

      t.timestamps null: false
    end
  end
end

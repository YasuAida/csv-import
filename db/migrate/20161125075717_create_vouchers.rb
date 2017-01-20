class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.references :user, index: true, foreign_key: true
      t.references :sale, index: true, foreign_key: true      
      t.date :date
      t.string :debit_account
      t.string :credit_account
      t.string :content
      t.string :trade_company
      t.integer :amount

      t.timestamps null: false
    end
  end
end

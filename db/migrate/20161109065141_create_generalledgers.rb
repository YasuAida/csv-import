class CreateGeneralledgers < ActiveRecord::Migration
  def change
    create_table :generalledgers do |t|
      t.references :pladmin, index: true, foreign_key: true
      t.references :stock, index: true, foreign_key: true
      t.references :stockreturn, index: true, foreign_key: true
      t.references :return_good, index: true, foreign_key: true
      t.references :disposal, index: true, foreign_key: true
      t.references :expenseledger, index: true, foreign_key: true
      t.references :voucher, index: true, foreign_key: true
      t.references :subexpense, index: true, foreign_key: true
      t.references :expense_relation, index: true, foreign_key: true      
      t.date :date
      t.string :debit_account
      t.string :debit_subaccount
      t.integer :debit_amount
      t.string :debit_taxcode
      t.string :credit_account
      t.string :credit_subaccount
      t.integer :credit_amount
      t.string :credit_taxcode
      t.string :content
      t.string :trade_company
      t.string :reference
      t.string :string

      t.timestamps null: false
    end
  end
end

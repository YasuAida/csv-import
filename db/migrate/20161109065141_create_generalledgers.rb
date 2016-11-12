class CreateGeneralledgers < ActiveRecord::Migration
  def change
    create_table :generalledgers do |t|
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

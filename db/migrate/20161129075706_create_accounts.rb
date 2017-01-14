class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :user, index: true, foreign_key: true 
      t.string :account
      t.string :debit_credit
      t.string :bs_pl

      t.timestamps null: false
    end
  end
end

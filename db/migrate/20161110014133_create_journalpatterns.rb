class CreateJournalpatterns < ActiveRecord::Migration
  def change
    create_table :journalpatterns do |t|
      t.references :user, index: true, foreign_key: true
      t.string :taxcode
      t.string :pattern
      t.string :debit_account
      t.string :debit_subaccount
      t.string :debit_taxcode
      t.string :credit_account
      t.string :credit_subaccount
      t.string :credit_taxcode

      t.timestamps null: false
    end
  end
end

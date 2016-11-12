class Journalpattern < ActiveRecord::Base
    validates :taxcode, uniqueness: { scope: [:ledger, :pattern, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode] }
end

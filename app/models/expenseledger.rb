class Expenseledger < ActiveRecord::Base
    
  validates :date, uniqueness: { scope: [:content, :amount, :money_paid, :purchase_from] }
    
end

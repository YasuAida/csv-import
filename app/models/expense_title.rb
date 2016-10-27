class ExpenseTitle < ActiveRecord::Base
    belongs_to :subexpense
    validates :item, uniqueness: { scope: [:item] }
end

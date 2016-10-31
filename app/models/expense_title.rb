class ExpenseTitle < ActiveRecord::Base
    validates :item, uniqueness: { scope: [:item] }, presence: true
end

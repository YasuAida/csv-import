class ExpenseTitle < ActiveRecord::Base
    validates :item, presence: true
end

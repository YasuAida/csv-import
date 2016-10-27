class ExpenseMethod < ActiveRecord::Base
    validates :method, uniqueness: { scope: [:method] }
end

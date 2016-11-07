class ExpenseMethod < ActiveRecord::Base
    validates :method, presence: true
end

class ExpenseMethod < ActiveRecord::Base
    validates :method, presence: true, uniqueness: true
end

class ExpenseRelation < ActiveRecord::Base
  belongs_to :stock
  belongs_to :subexpense
end


class Allocationcost < ActiveRecord::Base
    belongs_to :stock
    
    validates :stock_id, uniqueness: { scope: :title }
end

class MultiChannel < ActiveRecord::Base
    validates :order_num, uniqueness:true
end

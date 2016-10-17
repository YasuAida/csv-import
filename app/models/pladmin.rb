class Pladmin < ActiveRecord::Base
    validates :order_num, uniqueness: { scope: [:date, :sku] }
end

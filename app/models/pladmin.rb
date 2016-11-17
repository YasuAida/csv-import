class Pladmin < ActiveRecord::Base
    validates :order_num, uniqueness: { scope: [:date] }
    validates :date, uniqueness: { scope: [:sku] }
    validates :date, uniqueness: { scope: [:order_num] }
end

class Entrypattern < ActiveRecord::Base
    validates :SKU, uniqueness: { scope: [:kind_of_transaction, :kind_of_payment, :detail_of_payment, :handling] }
end

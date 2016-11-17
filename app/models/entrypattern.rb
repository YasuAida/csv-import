class Entrypattern < ActiveRecord::Base
    validates :sku, uniqueness: { scope: [:kind_of_transaction, :kind_of_payment, :detail_of_payment, :handling] }
end

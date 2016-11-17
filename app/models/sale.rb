class Sale < ActiveRecord::Base

  validates :order_num, uniqueness: { scope: [:date, :sku, :kind_of_transaction, :kind_of_payment, :detail_of_payment, :amount, :quantity, :goods_name] }
end

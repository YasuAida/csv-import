class Stockledger < ActiveRecord::Base

    validates :transaction_date, uniqueness: { scope: [:asin, :goods_name, :number, :unit_price, :grandtotal] }
    validates :sku, uniqueness: { scope: [:transaction_date, :goods_name, :number, :unit_price, :grandtotal] }
    validates :asin, uniqueness: { scope: [:transaction_date, :sku, :number, :unit_price, :grandtotal] }
    validates :goods_name, uniqueness: { scope: [:transaction_date, :sku, :asin, :unit_price, :grandtotal] }
    validates :number, uniqueness: { scope: [:transaction_date,:sku, :asin, :goods_name, :grandtotal] }
    validates :unit_price, uniqueness: { scope: [:transaction_date,:sku, :asin, :goods_name, :number] }
    validates :grandtotal, uniqueness: { scope: [:sku, :asin, :goods_name, :number, :unit_price] }
end

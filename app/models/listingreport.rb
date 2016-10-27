class Listingreport < ActiveRecord::Base
      validates :sku, uniqueness: { scope: [:asin, :price, :quantity] }
end

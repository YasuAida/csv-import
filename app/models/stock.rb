class Stock < ActiveRecord::Base

require 'date'
    def date_and_asin
        self.date.strftime("%Y/%m/%d") + ' ' + self.asin + ' ' + self.goods_name + ' ' + self.number.to_s + '個'
    end

    validates :asin, uniqueness: { scope: [:date, :goods_name, :number, :unit_price, :money_paid, :purchase_from] }
    
    has_many :expense_relations, dependent: :destroy
    has_many :expense_relation_subexpenses, through: :expense_relations, source: :subexpense
    
    has_many :allocationcosts
end

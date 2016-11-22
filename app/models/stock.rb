class Stock < ActiveRecord::Base

require 'date'
    def date_and_asin
        self.purchase_date.strftime("%Y/%m/%d") + ' ' + self.asin + ' ' + self.goods_name + ' ' + self.number.to_s + '個'
    end

    validates :sku , uniqueness: { scope: [:asin, :purchase_date, :goods_name, :number, :unit_price, :money_paid, :purchase_from] }
    validates :asin, presence: true
    validates :purchase_date, presence: true
    validates :number, presence: true
    validates :unit_price, presence: true
    validates :money_paid, presence: true
    validates :purchase_from, presence: true
    validates :currency, presence: true
    
    has_many :expense_relations, dependent: :destroy
    has_many :expense_relation_subexpenses, through: :expense_relations, source: :subexpense
    
    has_many :allocationcosts

    def self.to_csv
      headers = %w(ID 日付 SKU ASIN 商品名 個数 単価 支払日 購入先 通貨) 
      csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
        all.each do |row|
            csv_column_values = [
              row.id,
              row.purchase_date,
              row.sku,
              row.asin,
              row.goods_name,
              row.number,
              row.unit_price,
              row.money_paid,
              row.purchase_from,
              row.currency
            ]
            csv << csv_column_values
        end    
      end
      csv_data.encode(Encoding::SJIS)
    end
end

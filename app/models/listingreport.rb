class Listingreport < ActiveRecord::Base
  validates :sku, uniqueness: { scope: [:asin, :price, :quantity] }
  
  def self.to_download
    headers = %w(ID SKU ASIN 価格 数量)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.id,
        row.sku,
        row.asin,
        row.price,
        row.quantity
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
end

class Listingreport < ActiveRecord::Base
  validates :user_id, uniqueness: { scope: [:sku, :asin, :price, :quantity] }
  
  belongs_to :user
  
  def self.to_download
    headers = %w(SKU ASIN 価格 数量)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
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
  
  def self.admin_download
    headers = %w(ID user_id SKU ASIN 価格 数量)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.id,
        row.user_id,
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

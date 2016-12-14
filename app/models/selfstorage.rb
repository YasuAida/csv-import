class Selfstorage < ActiveRecord::Base
  validates :sku, uniqueness: true, presence: true
  
  def self.to_csv
    headers = %w(ID SKU) 
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.sku
        ]
        csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
  
  def self.to_download
    headers = %w(ID SKU) 
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.sku
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
end

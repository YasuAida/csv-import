class Disposal < ActiveRecord::Base
  def self.to_csv
    headers = %w(ID 日付 注文番号 SKU 個数) 
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.date,
          row.order_num,
          row.sku,
          row.number
        ]
        csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
  
  def self.to_download
    headers = %w(ID 日付 注文番号 SKU 個数) 
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.date,
          row.order_num,
          row.sku,
          row.number
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
end

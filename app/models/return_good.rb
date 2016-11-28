class ReturnGood < ActiveRecord::Base
    
  def self.to_csv
    headers = %w(ID 注文番号 返還前SKU 新SKU 個数 廃棄したか？) 
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.order_num,
          row.old_sku,
          row.new_sku,
          row.number,
          row.disposal
        ]
        csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
  
  def self.to_download
    headers = %w(ID 注文番号 返還前SKU 新SKU 個数 廃棄したか？) 
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.order_num,
          row.old_sku,
          row.new_sku,
          row.number,
          row.disposal 
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
end

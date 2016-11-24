class MultiChannel < ActiveRecord::Base
    validates :order_num, uniqueness:true
    
    def self.to_csv
      headers = %w(ID 注文番号 SKU) 
      csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
        all.each do |row|
            csv_column_values = [
              row.id,
              row.order_num,
              row.sku
            ]
            csv << csv_column_values
        end    
      end
      csv_data.encode(Encoding::SJIS)
    end
end

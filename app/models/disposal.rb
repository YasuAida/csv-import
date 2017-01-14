class Disposal < ActiveRecord::Base
  belongs_to :user
  belongs_to :stock
  has_many :generalledgers, dependent: :destroy
  
  def self.to_csv
    headers = %w(仕入ID 日付 注文番号 SKU 個数) 
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.stock_id,
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
    headers = %w(ID 仕入ID 日付 注文番号 SKU 個数) 
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.stock_id,
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

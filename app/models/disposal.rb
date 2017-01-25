class Disposal < ActiveRecord::Base

  validates :user_id , uniqueness: { scope: [:sale_id, :stock_id, :date, :order_num, :sku, :number] }

  belongs_to :user
  belongs_to :sale  
  belongs_to :stock
  has_many :generalledgers, dependent: :destroy
  
  def self.to_csv
    headers = %w(取引ID 仕入ID 日付 注文番号 SKU 個数) 
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.sale_id,
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
    headers = %w(ID user_id 取引ID 仕入ID 日付 注文番号 SKU 個数) 
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.user_id,
          row.sale_id,          
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

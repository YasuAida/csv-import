class Stockledger < ActiveRecord::Base
  belongs_to :user
  belongs_to :stock
  belongs_to :return_good
  
  def self.to_download
    headers = %w(仕入ID 日付 SKU ASIN 商品名 分類 数量 単価 金額)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.stock_id,
          row.transaction_date,
          row.sku,
          row.asin,
          row.goods_name,
          row.classification,
          row.number,
          row.unit_price,
          row.grandtotal   
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace, :replace => "?")
  end

  def self.admin_download
    headers = %w(ID user_id 仕入ID 日付 SKU ASIN 商品名 分類 数量 単価 金額)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.user_id,
          row.stock_id,
          row.transaction_date,
          row.sku,
          row.asin,
          row.goods_name,
          row.classification,
          row.number,
          row.unit_price,
          row.grandtotal   
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace, :replace => "?")
  end
end

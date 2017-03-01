class Stockaccept < ActiveRecord::Base

  validates :user_id, uniqueness: { scope: [:date, :fnsku, :sku, :goods_name, :quantity, :fba_number, :fc, :asin] }

  belongs_to :user
  
  def self.to_download
    headers = %w(日付 FNSKU 出品者SKU 商品名	数量 FBA納品番号 FC ASIN)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.date,
        row.fnsku,
        row.sku,
        row.goods_name,
        row.quantity,
        row.fba_number,
        row.fc,
        row.asin 
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace, :replace => "?")
  end
  
  def self.admin_download
    headers = %w(ID user_id 日付 FNSKU 出品者SKU 商品名	数量 FBA納品番号 FC ASIN)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.id,
        row.user_id,
        row.date,
        row.fnsku,
        row.sku,
        row.goods_name,
        row.quantity,
        row.fba_number,
        row.fc,
        row.asin 
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace, :replace => "?")
  end
end

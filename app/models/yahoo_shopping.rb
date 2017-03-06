class YahooShopping < ActiveRecord::Base
    
  validates :user_id, uniqueness: { scope: [ :order_id, :sku] }    
    
  belongs_to :user
  
  def self.to_download
    headers = %w(日付 注文ID SKU 商品名 単価 個数 売上高 原価 手数料 送料 入金日 送料支払日)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.date,
          row.order_id,
          row.sku,          
          row.goods_name,
          row.unit_price,
          row.number,
          row.sales_amount,
          row.cogs_amount,
          row.commission,
          row.shipping_cost,
          row.money_receipt_date,
          row.shipping_pay_date   
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
  
  def self.admin_download
    headers = %w(ID user_id 日付 注文ID SKU 商品名 単価 個数 売上高 原価 手数料 送料 入金日 送料支払日)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.user_id,
          row.date,
          row.order_id,
          row.sku,          
          row.goods_name,
          row.unit_price,
          row.number,
          row.sales_amount,
          row.cogs_amount,
          row.commission,
          row.shipping_cost,
          row.money_receipt_date,
          row.shipping_pay_date   
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
end

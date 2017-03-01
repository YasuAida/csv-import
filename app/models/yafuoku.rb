class Yafuoku < ActiveRecord::Base
  
  validates :user_id, uniqueness: { scope: [ :date, :order_num, :sku, :goods_name, :sale_place, :unit_price, :number, :sales_amount, :cogs_amount,:commission,:shipping_cost, :money_receipt_date,:shipping_pay_date, :commission_pay_date] }  
  
  belongs_to :user
  belongs_to :stock
  
  def self.to_download
    headers = %w(ID user_id 日付 注文番号 SKU 商品名 販売先 単価 個数 売上高 原価 手数料 送料 入金日 送料支払日 手数料支払日)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.user_id,
          row.date,
          row.order_num,
          row.sku,          
          row.goods_name,
          row.sale_place,
          row.unit_price,
          row.number,
          row.sales_amount,
          row.cogs_amount,
          row.commission,
          row.shipping_cost,
          row.money_receipt_date,
          row.shipping_pay_date,
          row.commission_pay_date        
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
  
  def self.admin_download
    headers = %w(ID user_id 日付 注文番号 SKU 商品名 販売先 単価 個数 売上高 原価 手数料 送料 入金日 送料支払日 手数料支払日)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.user_id,
          row.date,
          row.order_num,
          row.sku,          
          row.goods_name,
          row.sale_place,
          row.unit_price,
          row.number,
          row.sales_amount,
          row.cogs_amount,
          row.commission,
          row.shipping_cost,
          row.money_receipt_date,
          row.shipping_pay_date,
          row.commission_pay_date        
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
end  


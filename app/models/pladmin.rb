class Pladmin < ActiveRecord::Base
  belongs_to :stock
  has_many :generalledgers, dependent: :destroy
  
  validates :date, uniqueness: { scope: [:stock_id, :order_num, :sku, :goods_name, :sale_place] }
  
  def self.to_csv
    headers = %w(仕入ID 日付 注文番号 SKU 商品名 個数 売上先 売上高 手数料 原価 送料 入金日 手数料支払日 送料支払日) 
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.stock_id,       
          row.date,
          row.order_num,
          row.sku,
          row.goods_name,
          row.quantity,
          row.sale_place,
          row.sale_amount,
          row.commission,
          row.cgs_amount,
          row.shipping_cost,
          row.money_receive,
          row.commission_pay_date,
          row.shipping_pay_date
        ]
        csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace, :replace => "?")
  end
    
  def self.to_download
    headers = %w(ID 仕入ID 日付 注文番号 SKU 商品名 個数 売上先 売上高 手数料 原価 送料 入金日 手数料支払日 送料支払日)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.stock_id, 
          row.date,
          row.order_num,
          row.sku,
          row.goods_name,
          row.quantity,
          row.sale_place,
          row.sale_amount,
          row.commission,
          row.cgs_amount,
          row.shipping_cost,
          row.money_receive,
          row.commission_pay_date,
          row.shipping_pay_date
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace, :replace => "?")
  end
end

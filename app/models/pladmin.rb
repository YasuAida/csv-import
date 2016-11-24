class Pladmin < ActiveRecord::Base
    validates :date, uniqueness: { scope: [:order_num, :sku, :goods_name] }
    
    def self.to_csv
      headers = %w(ID 日付 注文番号 SKU 商品名 売上先 売上高 手数料 原価 送料 入金日) 
      csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
        all.each do |row|
            csv_column_values = [
              row.id,
              row.date,
              row.order_num,
              row.sku,
              row.goods_name,
              row.sale_place,
              row.sale_amount,
              row.commission,
              row.cgs_amount,
              row.shipping_cost,
              row.money_receive
            ]
            csv << csv_column_values
        end    
      end
      csv_data.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace, :replace => "?")
    end
end

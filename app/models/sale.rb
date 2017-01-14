class Sale < ActiveRecord::Base

  validates :order_num, uniqueness: { scope: [:date, :sku, :kind_of_transaction, :kind_of_payment, :detail_of_payment, :amount, :quantity, :goods_name] }

  belongs_to :user
  
  def self.to_download
    headers = %w(ID 日付 注文番号 SKU トランザクションの種類 支払いの種類 支払いの詳細 金額	数量 商品名	入金日 処理)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.id,
        row.date,
        row.order_num,
        row.sku,
        row.kind_of_transaction,
        row.kind_of_payment,
        row.detail_of_payment,
        row.amount,
        row.quantity,
        row.goods_name,        
        row.money_receive,        
        row.handling   
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace, :replace => "?")
  end
end

class Stockreturn < ActiveRecord::Base

  validates :user_id, uniqueness: { scope: [:stock_id,:date, :sku, :asin, :goods_name, :number, :unit_price, :money_paid, :purchase_from] }

  belongs_to :user

  has_many :generalledgers, dependent: :destroy
  
  def self.to_download
    headers = %w(ID 仕入ID 日付 SKU ASIN 商品名 個数 単価 レート 小計(円貨) 支払日 購入先 通貨 総額)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.user_id,
          row.stock_id,          
          row.date,
          row.sku,
          row.asin,
          row.goods_name,
          row.number,
          row.unit_price,
          row.rate,
          row.goods_amount,
          row.money_paid,
          row.purchase_from,
          row.currency,
          row.grandtotal
        ]
        csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace, :replace => "?")
  end
end

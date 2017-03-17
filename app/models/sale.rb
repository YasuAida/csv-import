class Sale < ActiveRecord::Base

  belongs_to :user

  has_many :pladmins, dependent: :destroy
  has_many :multi_channels, dependent: :destroy
  has_many :return_goods, dependent: :destroy
  has_many :disposals, dependent: :destroy
  has_many :expenseledgers, dependent: :destroy
  has_many :vouchers, dependent: :destroy  
  
  def self.to_download
    headers = %w(日付 注文番号 SKU トランザクションの種類 支払いの種類 支払いの詳細 金額	数量 商品名	締め日 処理)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.date,
        row.order_num,
        row.sku,
        row.kind_of_transaction,
        row.kind_of_payment,
        row.detail_of_payment,
        row.amount,
        row.quantity,
        row.goods_name,        
        row.closing_date,        
        row.handling   
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace, :replace => "?")
  end
  
  def self.admin_download
    headers = %w(ID user_id 日付 注文番号 SKU トランザクションの種類 支払いの種類 支払いの詳細 金額	数量 商品名	締め日 処理)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.id,
        row.user_id,
        row.date,
        row.order_num,
        row.sku,
        row.kind_of_transaction,
        row.kind_of_payment,
        row.detail_of_payment,
        row.amount,
        row.quantity,
        row.goods_name,        
        row.closing_date,        
        row.handling   
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace, :replace => "?")
  end
end

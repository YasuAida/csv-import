class Expenseledger < ActiveRecord::Base
  has_many :generalledgers, dependent: :destroy
    
  validates :date, uniqueness: { scope: [:account_name, :content, :amount, :money_paid, :purchase_from] }
  
  def self.to_csv
    headers = %w(日付 勘定科目 摘要 金額(外貨) レート 支払日 購入先 通貨 金額(円貨))
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [      
        row.date,
        row.account_name,
        row.content,
        row.amount,
        row.rate,
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
  
  def self.to_download
    headers = %w(ID 日付 勘定科目 摘要 金額(外貨) レート 支払日 購入先 通貨 金額(円貨))
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.id,          
        row.date,
        row.account_name,
        row.content,
        row.amount,
        row.rate,
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

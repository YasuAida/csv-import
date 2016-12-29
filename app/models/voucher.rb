class Voucher < ActiveRecord::Base
  validates :date, uniqueness: { scope: [:debit_account, :credit_account, :content, :trade_company ] }
    
  def self.to_download
    headers = %w(ID	日付 借方勘定科目 貸方勘定科目 摘要	取引先 金額)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.id,
        row.date,
        row.debit_account,
        row.debit_subaccount,        
        row.debit_taxcode,        
        row.credit_account,
        row.credit_subaccount,
        row.credit_taxcode,
        row.amount,
        row.content,        
        row.trade_company
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end  
end

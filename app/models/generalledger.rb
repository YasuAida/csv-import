class Generalledger < ActiveRecord::Base
  
  validates :date, uniqueness: { scope: [:debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode, :amount, :content, :trade_company, :reference] }  
  
  def self.to_download
    headers = %w(ID 日付 借方勘定科目 借方補助科目 借方税コード 貸方勘定科目 貸方補助科目 貸方税コード 金額 摘要 購入先 備考)
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
        row.trade_company,        
        row.reference    
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
    
end

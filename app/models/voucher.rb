class Voucher < ActiveRecord::Base
  validates :user_id, uniqueness: { scope: [:sale_id, :date, :debit_account, :credit_account, :content, :trade_company ] }

  belongs_to :user

  has_many :generalledgers, dependent: :destroy

  def self.to_csv
    headers = %w(日付 取引ID 借方勘定科目 借方補助科目 借方税コード 貸方勘定科目 貸方補助科目 貸方税コード 金額 摘要 取引先)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.sale_id,
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
    csv_data.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace, :replace => "?")
  end  
    
  def self.to_download
    headers = %w(ID	user_id 取引ID 日付 借方勘定科目 借方補助科目 借方税コード 貸方勘定科目 貸方補助科目 貸方税コード 金額 摘要 取引先)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.id,
        row.user_id,
        row.sale_id,
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
    csv_data.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace, :replace => "?")
  end  
end

class Journalpattern < ActiveRecord::Base
  validates :taxcode, uniqueness: { scope: [:ledger, :pattern, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode] }
    
  def self.to_download
    headers = %w(ID 税コード 元帳 パターン 借方勘定科目 借方補助科目 借方税コード 貸方勘定科目 貸方補助科目 貸方税コード)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.id,
        row.taxcode,
        row.ledger,
        row.pattern,
        row.debit_account,
        row.debit_subaccount,
        row.debit_taxcode,
        row.credit_account,
        row.credit_subaccount,
        row.credit_taxcode
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end  
end

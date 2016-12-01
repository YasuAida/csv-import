class Account < ActiveRecord::Base
    
  def self.to_download
    headers = %w(ID 勘定科目 貸借区分 ＢＳ／ＰＬ区分)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
          csv_column_values = [
            row.id,
            row.account,
            row.debit_credit,
            row.bs_pl
          ]
          csv << csv_column_values
      end    
    end
  csv_data.encode(Encoding::SJIS)
  end
end

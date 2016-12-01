class FinancialStatement < ActiveRecord::Base
  validates :account, uniqueness: { scope: [:period_start, :monthly_yearly] }  
  
  def self.to_download
    headers = %w(ID 期間 月次／年次 勘定科目 金額)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.id,          
        row.period_start,
        row.monthly_yearly,
        row.account,
        row.amount
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
end

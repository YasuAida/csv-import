class Period < ActiveRecord::Base
  validates :period_start, uniqueness: { scope: [:monthly_yearly] }, presence: true
  
  def self.to_download
    headers = %w(ID 開始日 終了日 月次／年次)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.period_start,
          row.period_end,
          row.monthly_yearly
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end  
end

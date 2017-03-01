class Period < ActiveRecord::Base
  validates :user_id, uniqueness: { scope: [:period_start, :monthly_yearly] }, presence: true
  validates :period_start, presence: true  
  validates :monthly_yearly, presence: true
  
  belongs_to :user
  
  def self.to_download
    headers = %w(開始日 終了日 月次／年次)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.period_start,
          row.period_end,
          row.monthly_yearly
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
  
  def self.admin_download
    headers = %w(ID user_id 開始日 終了日 月次／年次)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.user_id, 
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

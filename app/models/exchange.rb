class Exchange < ActiveRecord::Base
  validates :user_id, uniqueness: { scope: [:date, :country] }, presence: true
  validates :date, presence: true  
  validates :country, presence: true
  validates :rate, presence: true
  
  belongs_to :user
  
  def self.to_download
    headers = %w(日付 国 レート)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
          csv_column_values = [           
            row.date,
            row.country,
            row.rate
          ]
          csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
  
  def self.admin_download
    headers = %w(ID user_id 日付 国 レート)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
          csv_column_values = [
            row.id,
            row.user_id,            
            row.date,
            row.country,
            row.rate
          ]
          csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
end

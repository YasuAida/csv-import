class Exchange < ActiveRecord::Base
  validates :date, uniqueness: { scope: :country }, presence: true
  validates :country, presence: true
  validates :rate, presence: true
  
  belongs_to :user
  
  def self.to_download
    headers = %w(ID 日付 国 レート)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
          csv_column_values = [
            row.id,
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

class Currency < ActiveRecord::Base
  validates :name, uniqueness: { scope: [:method] }, presence: true
  validates :method, presence: true
    
  belongs_to :user
    
  def self.to_download
    headers = %w(ID 通貨名 換算方法)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
          csv_column_values = [
            row.id,
            row.name,
            row.method
          ]
          csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
end

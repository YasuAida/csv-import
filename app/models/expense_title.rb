class ExpenseTitle < ActiveRecord::Base
  validates :item, uniqueness: { scope: :method }, presence: true
  validates :method, presence: true
  
  def self.to_download
    headers = %w(ID 付随費用項目 按分方法)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.id,
        row.item,
        row.method
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
    
end

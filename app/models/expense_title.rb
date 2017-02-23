class ExpenseTitle < ActiveRecord::Base
  validates :user_id, uniqueness: { scope: [:item, :method] }, presence: true
  validates :item, presence: true
  
  belongs_to :user
  
  def self.to_download
    headers = %w(ID user_id 付随費用項目 按分方法)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
        row.id,
        row.user_id,
        row.item,
        row.method
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
    
end

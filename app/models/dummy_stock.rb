class DummyStock < ActiveRecord::Base

  validates :user_id , uniqueness: { scope: [:stock_id, :sale_date, :cancel_date, :number] }
  
  belongs_to :user
  belongs_to :stock  
  
  def self.to_download
    headers = %w(ID user_id 仕入ID 売上日 キャンセル日 個数) 
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.user_id,
          row.stock_id,          
          row.sale_date,
          row.cancel_date,
          row.number
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
end

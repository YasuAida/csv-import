class DummyStock < ActiveRecord::Base
  belongs_to :stock
  
  validates :stock_id , uniqueness: { scope: [:sale_date, :cancel_date, :number] }  
  
  def self.to_download
    headers = %w(ID 仕入ID 売上日 キャンセル日 個数) 
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
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

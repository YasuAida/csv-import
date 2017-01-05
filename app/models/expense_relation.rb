class ExpenseRelation < ActiveRecord::Base
  belongs_to :stock
  belongs_to :subexpense
  
  has_many :generalledgers, dependent: :destroy
  
  def self.to_download
    headers = %w(ID Stock_id Subexpense_id)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
          csv_column_values = [
            row.id,
            row.stock_id,
            row.subexpense_id
          ]
          csv << csv_column_values
      end
  end
  csv_data.encode(Encoding::SJIS)
  end  
end


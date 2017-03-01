class Allocationcost < ActiveRecord::Base
  belongs_to :user
  belongs_to :stock
  belongs_to :generalledger
  
  validates :user_id, uniqueness: { scope: [:stock_id,:title] }
  
  def self.to_download
    headers = %w(仕入ID 付随費用項目 配分額)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
          csv_column_values = [
            row.stock_id,
            row.title,
            row.allocation_amount
          ]
          csv << csv_column_values
      end    
    end
  csv_data.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace, :replace => "?")
  end
  
  def self.admin_download
    headers = %w(ID user_id 仕入ID 付随費用項目 配分額)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
          csv_column_values = [
            row.id,
            row.user_id,
            row.stock_id,
            row.title,
            row.allocation_amount
          ]
          csv << csv_column_values
      end    
    end
  csv_data.encode(Encoding::SJIS, :invalid => :replace, :undef => :replace, :replace => "?")
  end
end

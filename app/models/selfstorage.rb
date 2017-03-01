class Selfstorage < ActiveRecord::Base
  validates :user_id, uniqueness: { scope: [:sku] }, presence: true

  belongs_to :user
  
  def self.to_download
    headers = %w(ID user_id SKU) 
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.sku
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
  
  def self.admin_download
    headers = %w(ID user_id SKU) 
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.user_id,
          row.sku
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
end

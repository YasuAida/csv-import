class RakutenSetting < ActiveRecord::Base
    
  validates :user_id, uniqueness: { scope: [:start_date, :end_date, :start_sales, :end_sales, :pc_addition, :mobile_addition] } 
  validates :start_date, presence: true
  validates :pc_rate, presence: true
  validates :mobile_rate, presence: true
    
  belongs_to :user
  
  def self.to_download
    headers = %w(開始日 終了日 起点売上高 終点売上高 PC料率 モバイル料率 PC加算額 モバイル加算額)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.start_date,          
          row.end_date,
          row.start_sales,
          row.end_sales,          
          row.pc_rate,
          row.mobile_rate,
          row.pc_addition,
          row.mobile_addition
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
  
  def self.admin_download
    headers = %w(ID user_id 開始日 終了日 起点売上高 終点売上高 PC料率 モバイル料率 PC加算額 モバイル加算額)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.user_id,
          row.start_date,          
          row.end_date,
          row.start_sales,
          row.end_sales,          
          row.pc_rate,
          row.mobile_rate,
          row.pc_addition,
          row.mobile_addition
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
end

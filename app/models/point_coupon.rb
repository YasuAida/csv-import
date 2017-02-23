class PointCoupon < ActiveRecord::Base

  validates :user_id, uniqueness: { scope: [ :order_num, :shop_coupon, :use_point, :use_coupon] }
    
  belongs_to :user

  def self.to_download
    headers = %w(ID user_id 注文番号 店舗クーポン ポイント利用額 クーポン利用額)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.user_id,
          row.order_num,          
          row.shop_coupon,
          row.use_point,
          row.use_coupon   
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
  
end

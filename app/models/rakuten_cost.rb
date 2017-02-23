class RakutenCost < ActiveRecord::Base
  belongs_to :user
  
  def self.to_download
    headers = %w(ID user_id 課金日 RMSシステム利用料 RMSモバイル利用料 スーパーポイント付与料（PC） スーパーポイント付与料（Mobile） アフィリエイト成果報酬 アフィリエイトシステム利用料 R-Card-Plus モール利用料 RMS出店料 支払日)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.user_id,
          row.billing_date,          
          row.pc_usage_fee,
          row.mobile_usage_fee,
          row.pc_vest_point,          
          row.mobile_vest_point,
          row.affiliate_reward,
          row.affiliate_system_fee,
          row.r_card_plus,
          row.system_improvement_fee,
          row.open_shop_fee,
          row.payment_date
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
end

class Rakuten < ActiveRecord::Base
    
  validates :user_id, uniqueness: { scope: [ :order_num, :order_date, :sku, :goods_name, :option, :pc_mobile, :unit_price,:number,:settlement, :shipping_cost,:consumption_tax, :cod_fee] }

  belongs_to :user
  
  def self.to_download
    headers = %w(注文番号 注文日 売上日 SKU 商品名 選択 カード種別 PC/MOBILE 単価 個数 送料 消費税 代引手数料 店舗クーポン 売上金額 楽天手数料 ポイント付与額 追加システム利用料 クレジット手数料等 データ処理料 総手数料額 決済方法 入金額 ポイント利用額 クーポン利用額 締め日 入金日 ポイント入金日 楽天課金日 未入金額)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.order_num,          
          row.order_date,
          row.sale_date,
          row.sku,          
          row.goods_name,
          row.option,
          row.kind_of_card,
          row.pc_mobile,
          row.unit_price,
          row.number,
          row.shipping_cost,
          row.consumption_tax,
          row.cod_fee,
          row.shop_coupon,
          row.total_sales,
          row.commission,
          row.vest_point,
          row.system_improvement,
          row.credit_commission,
          row.data_processing,
          row.total_commissions,
          row.settlement,
          row.receipt_amount,
          row.use_point,
          row.use_coupon,
          row.closing_date,
          row.money_receipt_date,
          row.point_receipt_date,
          row.billing_date,
          row.minyukin        
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
  
  def self.admin_download
    headers = %w(ID user_id 注文番号 注文日 売上日 SKU 商品名 選択 カード種別 PC/MOBILE 単価 個数 送料 消費税 代引手数料 店舗クーポン 売上金額 楽天手数料 ポイント付与額 追加システム利用料 クレジット手数料等 データ処理料 総手数料額 決済方法 入金額 ポイント利用額 クーポン利用額 締め日 入金日 ポイント入金日 楽天課金日 未入金額)
    csv_data = CSV.generate(headers: headers, write_headers: true, force_quotes: true) do |csv|
      all.each do |row|
        csv_column_values = [
          row.id,
          row.user_id,
          row.order_num,          
          row.order_date,
          row.sale_date,
          row.sku,          
          row.goods_name,
          row.option,
          row.kind_of_card,
          row.pc_mobile,
          row.unit_price,
          row.number,
          row.shipping_cost,
          row.consumption_tax,
          row.cod_fee,
          row.shop_coupon,
          row.total_sales,
          row.commission,
          row.vest_point,
          row.system_improvement,
          row.credit_commission,
          row.data_processing,
          row.total_commissions,
          row.settlement,
          row.receipt_amount,
          row.use_point,
          row.use_coupon,
          row.closing_date,
          row.money_receipt_date,
          row.point_receipt_date,
          row.billing_date,
          row.minyukin        
       ]
      csv << csv_column_values
      end    
    end
    csv_data.encode(Encoding::SJIS)
  end
end

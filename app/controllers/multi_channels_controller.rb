class MultiChannelsController < ApplicationController
  before_action :set_multi_channel, only: [ :update]  
  before_action :logged_in_user  
  
  def index
    @all_multi_channels = current_user.multi_channels.all
    @q = current_user.multi_channels.search(params[:q])
    @multi_channels = @q.result(distinct: true).order(date: :desc).page(params[:page]).per(100) 
    @multi_channel = current_user.multi_channels.build
    
    respond_to do |format|
      format.html
      format.csv { send_data @multi_channels.to_csv, type: 'text/csv; charset=shift_jis', filename: "multi_channels.csv" }
    end
  end

  def create
    params[:multi_channel][:sku] = params[:multi_channel][:sku].gsub(" ","")
    @multi_channel = current_user.multi_channels.build(multi_channel_params)
    if @multi_channel.save
      redirect_to multi_channels_path , notice: 'データを保存しました'
    else
      redirect_to multi_channels_path , notice: 'データの保存に失敗しました'  
    end
  end
  
  def sku
  #損益管理シートへSKUと商品名を入力
    current_user.multi_channels.all.each do |multi|
      sku_pladmin = current_user.pladmins.find_by(date: multi.date, order_num: multi.order_num, sku: nil)
      multi_number = current_user.multi_channels.where(date: multi.date, order_num: multi.order_num).count
      ex_pladmins = current_user.pladmins.where(date: multi.date, order_num: multi.order_num)
      old_pladmins = ex_pladmins.where.not(sku: nil)
      
      if old_pladmins.present? && multi_number > 1
        old_pladmins.each do |old_pladmin|
          if old_pladmin.sku == multi.sku
            break
          end
        end
        
        new_pladmin = current_user.pladmins.build(sale_id: multi.sale_id, date: multi.date, order_num: multi.order_num, sku: multi.sku, quantity: multi.number, sale_place: "その他")
        
        sku_stocks = current_user.stocks.where(sku: multi.sku)
        sku_stockaccepts = current_user.stockaccepts.where(sku: multi.sku) 
        if sku_stocks.present?
          new_pladmin.goods_name = sku_stocks.first.goods_name + "（マルチ発送分）"
        elsif sku_stockaccepts.present?
          new_pladmin.goods_name = sku_stockaccepts.first.goods_name + "（マルチ発送分）" 
        end
        new_pladmin.save
      elsif sku_pladmin.present?
        sku_pladmin.sku = multi.sku
        sku_pladmin.quantity = multi.number
        
        sku_stocks = current_user.stocks.where(sku: multi.sku)
        sku_stockaccepts = current_user.stockaccepts.where(sku: multi.sku) 
        if sku_stocks.present?
          sku_pladmin.goods_name = sku_stocks.first.goods_name + "（マルチ発送分）"
        elsif sku_stockaccepts.present?
          sku_pladmin.goods_name = sku_stockaccepts.first.goods_name + "（マルチ発送分）" 
        end
        sku_pladmin.save
      end
    end
    
    current_user.multi_channels.group(:date, :order_num).all.each do |multi|
      multi_number = current_user.multi_channels.where(date: multi.date, order_num: multi.order_num).count
      if multi_number > 1
        target_pladmins = current_user.pladmins.where(date: multi.date, order_num: multi.order_num)
        if target_pladmins.present?
          
          total_shipping_cost = target_pladmins.sum(:shipping_cost)
          ex_shipping_cost = total_shipping_cost / multi_number
          shipping_cost = BigDecimal(ex_shipping_cost.to_s).round(0)
          pay_date_pladmin = target_pladmins.where.not(shipping_pay_date: nil)
          pay_date = pay_date_pladmin.first.shipping_pay_date
          
          target_pladmins.each do |target_pladmin|
            target_pladmin.update(shipping_cost: shipping_cost, shipping_pay_date: pay_date)
          end
          
          if total_shipping_cost - target_pladmins.sum(:shipping_cost) != 0
            shipping_fraction = total_shipping_cost - target_pladmins.sum(:shipping_cost)
            new_shipping_cost = shipping_cost + shipping_fraction
            target_pladmins.last.update(shipping_cost: new_shipping_cost)
          end
        end
      end
    end
    redirect_to pladmins_path , notice: 'SKUと商品名の転記が終了しました'    
  end
  
  def update
    params[:multi_channel][:sku] = params[:multi_channel][:sku].gsub(" ","")
    @multi_channel.update(multi_channel_params)
    
    redirect_to multi_channels_path , notice: '保存しました'
  end  
  
  def destroy
    current_user.multi_channels.where(destroy_check: true).destroy_all
    redirect_to multi_channels_path, notice: 'データを削除しました'
  end
  
  private
  def multi_channel_params
    params.require(:multi_channel).permit(:sale_id, :date, :order_num, :sku, :number, :destroy_check)
  end
  
  def set_multi_channel
    @multi_channel = current_user.multi_channels.find(params[:id])
  end
end

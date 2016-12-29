class MultiChannelsController < ApplicationController
  def index
    @multi_channels = MultiChannel.all
    
    respond_to do |format|
      format.html
      format.csv { send_data @multi_channels.to_csv, type: 'text/csv; charset=shift_jis', filename: "multi_channels.csv" }
    end
  end
  
  def sku
  #損益管理シートへSKUと商品名を入力
    MultiChannel.all.each do |multi|
      pladmin = Pladmin.find_by(order_num: multi.order_num)
      pladmin.sku = multi.sku
      
      @sku_stocks = Stock.where(sku: multi.sku)
      if @sku_stocks.present?
        pladmin.goods_name = @sku_stocks.first.goods_name + "（マルチ発送分）"
      else
        @sku_pladmins = Pladmin.where(sku: multi.sku) 
        pladmin.goods_name = @sku_pladmins.first.goods_name if @sku_pladmins.present?
      end
      pladmin.save
    end
    redirect_to pladmins_path , notice: 'SKUと商品名の転記が終了しました'    
  end
  
  def update
    @multi_channel = MultiChannel.find_by(order_num: params[:multi_channel][:order_num])
    @multi_channel.sku = params[:multi_channel][:sku]
    @multi_channel.save
    
    redirect_to multi_channels_path , notice: '保存しました'
  end
  
  private
  def multi_channel_params
    params.require(:multi_channel).permit(:order_num, :sku)
  end
  
end

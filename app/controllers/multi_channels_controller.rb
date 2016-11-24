class MultiChannelsController < ApplicationController
  def index
    @multi_channels = MultiChannel.all
    
    respond_to do |format|
      format.html
      format.csv { send_data @multi_channels.to_csv, type: 'text/csv; charset=shift_jis', filename: "multi_channels.csv" }
    end
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

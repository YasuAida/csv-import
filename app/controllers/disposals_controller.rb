class DisposalsController < ApplicationController
  before_action :set_disposal, only: [ :update, :destroy] 
  
  def index
    @disposal = Disposal.new   
    #@disposals = Disposal.all
    @q = Disposal.search(params[:q])
    @disposals = @q.result(distinct: true).page(params[:page])
    
    respond_to do |format|
      format.html
      format.csv { send_data @disposals.to_csv, type: 'text/csv; charset=shift_jis', filename: "disposals.csv" }
    end  
  end
  
  def create
    @disposal = Disposal.new(disposal_params)
    @disposal.save
    redirect_to disposals_path , notice: '保存しました'    
  end
  
  def update
    if @disposal.update(disposal_params)
      redirect_to disposals_path , notice: '保存しました'
    end
  end
  
  def destroy
    @disposal.destroy
    redirect_to disposals_path, notice: 'データを削除しました'
  end
  
  private
  def disposal_params
    params.require(:disposal).permit(:date, :order_num, :sku, :number)
  end
  
  def set_disposal
    @disposal = Disposal.find(params[:id])
  end
end

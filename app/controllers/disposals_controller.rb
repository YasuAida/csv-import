class DisposalsController < ApplicationController
  before_action :set_disposal, only: [ :update] 
  
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
    if @update_disposal.update(disposal_params)
      @update_disposal.gl_flag = false
      @update_disposal.save
      redirect_to disposals_path , notice: '保存しました'
    else
      redirect_to disposals_path , notice: '保存に失敗しました'
    end
  end
  
  def destroy
    Disposal.where(destroy_check: true).destroy_all
    redirect_to disposals_path, notice: 'データを削除しました'
  end
  
  private
  def disposal_params
    params.require(:disposal).permit(:date, :order_num, :sku, :number, :destroy_check)
  end
  
  def set_disposal
    @update_disposal = Disposal.find(params[:id])
  end
end

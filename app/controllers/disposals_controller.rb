class DisposalsController < ApplicationController
  before_action :set_disposal, only: [:edit, :update, :copy]
  before_action :logged_in_user
  
  def index
    @q = current_user.disposals.search(params[:q])
    @disposals = @q.result(distinct: true).page(params[:page])
    @disposal = current_user.disposals.build
    
    respond_to do |format|
      format.html
      format.csv { send_data @disposals.to_download, type: 'text/csv; charset=shift_jis', filename: "disposals.csv" }
    end  
  end
  
  def new
    @q = current_user.disposals.search(params[:q])
    @disposals = @q.result(distinct: true).page(params[:page])
    @disposal = current_user.disposals.build  
  end
  
  def create
    @disposal = current_user.disposals.build(disposal_params)        
    @disposal.save
    redirect_to disposals_path , notice: '保存しました'    
  end
  
  def edit
    @q = current_user.disposals.search(params[:q])
    @disposals = @q.result(distinct: true).page(params[:page])  
    @disposal = @update_disposal
  end
  
  def update
    if @update_disposal.update(disposal_params)
      redirect_to disposals_path , notice: '保存しました'
    else
      redirect_to disposals_path , notice: '保存に失敗しました'
    end
  end

  def copy
    @copy_disposal = @update_disposal.dup
    @copy_disposals = current_user.disposals.where(date: @copy_disposal.date, stock_id: @copy_disposal.stock_id, order_num: @copy_disposal.order_num)
    @copy_disposal.sku = @copy_disposal.sku + "(" + @copy_disposals.count.to_s + ")"
    if @copy_disposal.save 
      @copy_disposals = current_user.disposals.where(date: @copy_disposal.date, stock_id: @copy_disposal.stock_id, order_num: @copy_disposal.order_num)
    else
      redirect_to :back 
    end  
  end
  
  def destroy
    current_user.disposals.where(destroy_check: true).destroy_all
    redirect_to disposals_path, notice: 'データを削除しました'
  end
  
  private
  def disposal_params
    params.require(:disposal).permit(:date, :order_num, :sku, :number, :destroy_check)
  end
  
  def set_disposal
    @update_disposal = current_user.disposals.find(params[:id])
  end
end

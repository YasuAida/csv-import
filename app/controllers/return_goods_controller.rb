class ReturnGoodsController < ApplicationController
  before_action :set_return_good, only: [ :update] 
  
  def index
    @return_good = ReturnGood.new   
    @q = ReturnGood.search(params[:q])
    @return_goods = @q.result(distinct: true).page(params[:page])
    @all_return_goods = ReturnGood.all
    
    respond_to do |format|
      format.html
      format.csv { send_data @all_return_goods.to_csv, type: 'text/csv; charset=shift_jis', filename: "return_goods.csv" }
    end  
  end
  
  def create
    @return_good = ReturnGood.create(return_good_params)  
    redirect_to return_goods_path , notice: '保存しました'    
  end
  
  def update
    if @return_good.update(return_good_params)
      @return_good.gl_flag = false
      @return_good.save
      redirect_to return_goods_path , notice: '保存しました'
    else
      redirect_to return_goods_path , notice: '保存に失敗しました'
    end
  end
  
  def destroy
    ReturnGood.where(destroy_check: true).destroy_all
    redirect_to return_goods_path, notice: 'データを削除しました'
  end
  
  private
  def return_good_params
    params.require(:return_good).permit(:date, :order_num, :old_sku, :new_sku, :number, :destroy_check)
  end
  
  def set_return_good
    @return_good = ReturnGood.find(params[:id])
  end
  
end
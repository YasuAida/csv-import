class ReturnGoodsController < ApplicationController
  include ReturnGoodsHelper
  before_action :set_return_good, only: [ :update, :destroy] 
  
  def index
    @return_good = ReturnGood.new   
    #@return_goods = ReturnGood.all
    @q = ReturnGood.search(params[:q])
    @return_goods = @q.result(distinct: true).page(params[:page])
    
    respond_to do |format|
      format.html
      format.csv { send_data @return_goods.to_csv, type: 'text/csv; charset=shift_jis', filename: "return_goods.csv" }
    end  
  end
  
  def create
    @return_good = ReturnGood.new(return_good_params)  
    redirect_to return_goods_path , notice: '保存しました'    
  end
  
  def update
    if @return_good.update(return_good_params)
      redirect_to return_goods_path , notice: '保存しました'
    else
      redirect_to return_goods_path , notice: '保存に失敗しました'
    end
  end
  
  def destroy
    @return_good.destroy
    redirect_to return_goods_path, notice: 'データを削除しました'
  end
  
  private
  def return_good_params
    params.require(:return_good).permit(:date, :order_num, :old_sku, :new_sku, :number)
  end
  
  def set_return_good
    @return_good = ReturnGood.find(params[:id])
  end
  
end
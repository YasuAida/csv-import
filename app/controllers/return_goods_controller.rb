class ReturnGoodsController < ApplicationController
  before_action :set_return_good, only: [ :update, :destroy] 
  
  def index
    @return_good = ReturnGood.new   
    @return_goods = ReturnGood.all
    
    respond_to do |format|
      format.html
      format.csv { send_data @return_goods.to_csv, type: 'text/csv; charset=shift_jis', filename: "return_goods.csv" }
    end  
  end
  
  def create
    @return_good = ReturnGood.new(return_good_params)
    @return_good.save
    redirect_to return_goods_path , notice: '保存しました'    
  end
  
  def update
    if @return_good.update(return_good_params)
      redirect_to return_goods_path , notice: '保存しました'
    end
  end
  
  def destroy
    @return_good.destroy
    redirect_to return_goods_path, notice: 'データを削除しました'
  end
  
  private
  def return_good_params
    params.require(:return_good).permit(:date, :order_num, :old_sku, :new_sku, :number, :disposal)
  end
  
  def set_return_good
    @return_good = ReturnGood.find(params[:id])
  end
  
end
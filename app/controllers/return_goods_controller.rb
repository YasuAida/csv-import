class ReturnGoodsController < ApplicationController
  before_action :set_return_good, only: [:edit, :update, :copy]
  before_action :logged_in_user
  
  def index
    @return_good = current_user.return_goods.build
    @q = current_user.return_goods.search(params[:q])
    @return_goods = @q.result(distinct: true).order(date: :desc).page(params[:page])
    @all_return_goods = current_user.return_goods.all
    
    respond_to do |format|
      format.html
      format.csv { send_data @all_return_goods.to_csv, type: 'text/csv; charset=shift_jis', filename: "return_goods.csv" }
    end  
  end
  
  def new
    @q = current_user.return_goods.search(params[:q])
    @return_goods = @q.result(distinct: true).order(date: :desc).page(params[:page])
    @return_good = current_user.return_goods.build   
  end
  
  def create
    @return_good = current_user.return_goods.build(return_good_params)
    if @return_good.save
      redirect_to return_goods_path , notice: 'データを保存しました'
    else
      redirect_to return_goods_path , notice: 'データの保存に失敗しました'  
    end
  end
  
  def edit
    @q = current_user.return_goods.search(params[:q])
    @return_goods = @q.result(distinct: true).order(date: :desc).page(params[:page])    
    @return_good = @update_return_good
  end
  
  def update
    if @update_return_good.update(return_good_params)    
      redirect_to :back 
    else
      redirect_to :back 
    end
  end

  def copy
    @copy_return_good = @update_return_good.dup
    @copy_return_goods = current_user.return_goods.where(date: @copy_return_good.date, sale_id: @copy_return_good.sale_id, stock_id: @copy_return_good.stock_id, order_num: @copy_return_good.order_num, old_sku: @copy_return_good.old_sku, number: @copy_return_good.number)
    @copy_return_good.new_sku = @copy_return_good.new_sku + "(" + @copy_return_goods.count.to_s + ")"
    if @copy_return_good.save 
      @copy_return_goods = current_user.return_goods.where(date: @copy_return_good.date, sale_id: @copy_return_good.sale_id, stock_id: @copy_return_good.stock_id, order_num: @copy_return_good.order_num, old_sku: @copy_return_good.old_sku, number: @copy_return_good.number)
    else
      redirect_to :back 
    end  
  end

  def destroy
    current_user.return_goods.where(destroy_check: true).destroy_all
    redirect_to return_goods_path, notice: 'データを削除しました'
  end
  
  private
  def return_good_params
    params.require(:return_good).permit(:date, :stock_id, :order_num, :old_sku, :new_sku, :number, :destroy_check)
  end
  
  def set_return_good
    @update_return_good = current_user.return_goods.find(params[:id])
  end
  
end
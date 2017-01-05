class StockreturnsController < ApplicationController
  before_action :set_stockreturn, only: [ :update]
  include StocksHelper
  include ApplicationHelper

  def index
    @stockreturn = Stockreturn.new
    @q = Stockreturn.search(params[:q])
    @stockreturns = @q.result(distinct: true).page(params[:page])
  end
  
  def create
    params[:stockreturn][:unit_price] = params[:stockreturn][:unit_price].gsub(",","") if params[:stockreturn][:unit_price].present?
    @stockreturn = Stockreturn.new(stockreturn_params)
    if @stockreturn.save
    #為替レートの付与
      rate_import_new_object(@stockreturn)
    #商品金額の確定
      goods_amount_new_stock(@stockreturn)
    #grandtotalの計算 
      allocation_amount_sum = Allocationcost.where(stock_id: @stockreturn.stock_id).sum(:allocation_amount)
      @stockreturn.grandtotal = @stockreturn.goods_amount + allocation_amount_sum
    
      @stockreturn.save
      
      redirect_to stockreturns_path , notice: 'データを保存しました'
    else
      redirect_to stockreturns_path , notice: 'データの保存に失敗しました'
    end
  end

  def update
    params[:stockreturn][:unit_price] = params[:stockreturn][:unit_price].gsub(",","") if params[:stockreturn][:unit_price].present?    
    if @update_stockreturn.update(stockreturn_params)
      flash.now[:alert] = "データを更新しました。"
      goods_amount_new_stock(@update_stockreturn)
    #grandtotalの計算 
      allocation_amount_sum = Allocationcost.where(stock_id: @update_stockreturn.stock_id).sum(:allocation_amount)
      @update_stockreturn.grandtotal = @update_stockreturn.goods_amount + allocation_amount_sum      
      @update_stockreturn.gl_flag = false
      @update_stockreturn.save
      
      redirect_to stockreturns_path , notice: 'データを保存しました'
    else
      redirect_to stockreturns_path , notice: 'データの保存に失敗しました'
    end
  end
  
  def destroy
    Stockreturn.where(destroy_check: true).destroy_all
    redirect_to stockreturns_path, notice: 'データを削除しました'
  end
  
  private
  def stockreturn_params
    params.require(:stockreturn).permit(:stock_id, :date, :sku, :asin, :goods_name, :number, :unit_price, :money_paid, :purchase_from, :currency, :destroy_check)
  end
  
  def set_stockreturn
    @update_stockreturn = Stockreturn.find(params[:id])
  end
end

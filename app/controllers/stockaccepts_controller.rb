class StockacceptsController < ApplicationController
  include StockacceptsHelper
  before_action :set_stockaccept, only: [:edit, :update]
  before_action :logged_in_user
  
  def index
    @q = current_user.stockaccepts.search(params[:q])
    @stockaccepts = @q.result(distinct: true).order(date: :desc).page(params[:page]).per(150)
  end
  
  def edit
    @q = current_user.stockaccepts.search(params[:q])
    @stockaccepts = @q.result(distinct: true).order(date: :desc).page(params[:page]).per(150)     
    @stockaccept = @update_stockaccept
  end
  
  def update 
    if @update_stockaccept.update(stockaccept_params)
      redirect_to :back
    else
      redirect_to :back 
    end
  end
  
  def upload
    data = params[:upload]
    #ファイルの登録
    file_open(data[:datafile])
    #ファイルのインポート
    file_import_stockaccept(data[:datafile])
    #ファイルの削除
    file_close(data[:datafile])
    #受領レポートに出品レポートからSKUを引っ張ってくる
    asin_addition_to_stockaccept

    redirect_to stockaccepts_path
  end

  private
  def stockaccept_params
    params.require(:stockaccept).permit(:date, :fnsku, :sku, :goods_name, :quantity, :fba_number, :fc, :asin)
  end
  
  def set_stockaccept
    @update_stockaccept = current_user.stockaccepts.find(params[:id])
  end
end


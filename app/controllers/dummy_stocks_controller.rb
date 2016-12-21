class DummyStocksController < ApplicationController
  include DummyStocksHelper
  include StockledgersHelper  
  before_action :set_dummy_stock, only: [ :update]

  def index
    #@dummy_stocks = DummyStock.all
    @dummy_stock = DummyStock.new
    @q = DummyStock.search(params[:q])
    @dummy_stocks = @q.result(distinct: true).page(params[:page])
  end
  
  def create
    @dummy_stock = DummyStock.new(dummy_stock_params)
    if @dummy_stock.save
    #stockledgerテーブルにレコードを追加
      add_stockledgers(@dummy_stock)
    #端数処理  
      rounding_fraction
      
      redirect_to dummy_stocks_path , notice: 'データを保存しました'
    else
      redirect_to dummy_stocks_path , notice: 'データの保存に失敗しました'
    end
  end

  def destroy
    DummyStock.where(destroy_check: true).destroy_all
    redirect_to dummy_stocks_path, notice: 'データを削除しました'
  end
  
  private
  def dummy_stock_params
    params.require(:dummy_stock).permit(:stock_id, :sale_date, :cancel_date, :number, :destroy_check)
  end
  
  def set_dummy_stock
    @update_dummy_stock = DummyStock.find(params[:id])
  end
end

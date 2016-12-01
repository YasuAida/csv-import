class StocksController < ApplicationController
  include StocksHelper
  include ApplicationHelper
  before_action :set_stock, only: [ :update, :destroy]

  def index
    #@stocks = Stock.all
    @q = Stock.search(params[:q])
    @stocks = @q.result(distinct: true).page(params[:page])
    @stock = Stock.new
    
    respond_to do |format|
      format.html
      format.csv { send_data @stocks.to_csv, type: 'text/csv; charset=shift_jis', filename: "stocks.csv" }
    end
  end

  def upload 
    data = params[:upload]
    #ファイルの登録
    file_open(data[:datafile])
    #ファイルのインポート
    file_import_stock(data[:datafile])
    #ファイルの削除
    file_close(data[:datafile])
    #為替レートのインポート
    rate_import(Stock.all)
    #商品金額の確定
    goods_amount(Stock.all)

    redirect_to stocks_path
  end

  def sku
    #SKUのインポート
    sku_import_to_stock
    redirect_to stocks_path
  end
  
  def create
    @stock = Stock.new(stock_params)
    if @stock.save
    #為替レートの付与
      rate_import_new_object(@stock)
    #商品金額の確定
      goods_amount_new_stock(@stock)
      @stock.save
      redirect_to stocks_path , notice: 'データを保存しました'
    else
      redirect_to stocks_path , notice: 'データの保存に失敗しました'
    end
  end

  # Ajax用にリダイレクトを破棄 
  def update
    if @update_stock.update(stock_params)
      render 'update_ajax'
      # redirect_to stocks_path, notice: "データを編集しました"
    else
      flash.now[:alert] = "データの編集に失敗しました。"
      render 'update_ajax'
      # render "update"
    end
  end
  
  def destroy
    @update_stock.destroy
    redirect_to stocks_path, notice: 'データを削除しました'
  end
  
  private
  def stock_params
    params.require(:stock).permit(:date, :sku, :asin, :goods_name, :number, :unit_price, :money_paid, :purchase_from, :currency)
  end
  
  def set_stock
    @update_stock = Stock.find(params[:id])
  end
end

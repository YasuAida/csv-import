class StocksController < ApplicationController
  include StocksHelper
  include ApplicationHelper
  before_action :set_stock, only: [:edit, :update, :copy]
  before_action :logged_in_user

  def index
    @all_stocks = current_user.stocks.all
    @q = current_user.stocks.search(params[:q])
    @stocks = @q.result(distinct: true).order(date: :desc).page(params[:page])
    @stock = current_user.stocks.new
    
    respond_to do |format|
      format.html
      format.csv { send_data @all_stocks.to_download, type: 'text/csv; charset=shift_jis', filename: "stocks.csv" }
    end
  end
  
  def new
    @q = current_user.stocks.search(params[:q])
    @stocks = @q.result(distinct: true).order(id: :desc).page(params[:page])
    @stock = current_user.stocks.build   
  end
  
  def create
    params[:stock][:unit_price] = params[:stock][:unit_price].gsub(",","") if params[:stock][:unit_price].present?
    @stock = current_user.stocks.build(stock_params)
    if @stock.save!
    #為替レートの付与
      rate_import_new_object(@stock)
    #商品金額の確定
      goods_amount_new_stock(@stock)
      @stock.save
      redirect_to new_stock_path , notice: 'データを保存しました'
    else
      redirect_to new_stock_path , notice: 'データの保存に失敗しました'
    end
  end
  
  def edit
    @q = current_user.stocks.search(params[:q])
    @stocks = @q.result(distinct: true).order(date: :desc).page(params[:page])     
    @stock = @update_stock
  end

  def update
    params[:stock][:unit_price] = params[:stock][:unit_price].gsub(",","") if params[:stock][:unit_price].present?    
    if @update_stock.update(stock_params)
      goods_amount_new_stock(@update_stock)
      @update_stock.stockledgers.destroy_all
      @update_stock.save
      
      redirect_to :back 
    else
      redirect_to :back 
    end
  end
  
  def copy
    @copy_stock = @update_stock.dup
    @copy_stocks = current_user.stocks.where(date: @copy_stock.date, asin: @copy_stock.asin, goods_name: @copy_stock.goods_name, unit_price: @copy_stock.unit_price, money_paid: @copy_stock.money_paid, purchase_from: @copy_stock.purchase_from)
    @copy_stock.sku = @copy_stock.sku + "(" + @copy_stocks.count.to_s + ")"
    if @copy_stock.save
    #為替レートの付与
      rate_import_new_object(@copy_stock)
    #商品金額の確定
      goods_amount_new_stock(@copy_stock)
      @copy_stock.save
 
    @copy_stocks = current_user.stocks.where(date: @copy_stock.date, asin: @copy_stock.asin, goods_name: @copy_stock.goods_name, unit_price: @copy_stock.unit_price, money_paid: @copy_stock.money_paid, purchase_from: @copy_stock.purchase_from)    
    else
      redirect_to :back 
    end  
  end
  
  def blank_form
    render "index"
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
    rate_import(current_user.stocks.all)
    #商品金額の確定
    goods_amount(current_user.stocks.all)

    redirect_to stocks_path
  end

  def sku
    #SKUのインポート
    sku_import_to_stock
    redirect_to stocks_path
  end
  
  def destroy
    current_user.stocks.where(destroy_check: true).destroy_all
    redirect_to stocks_path
  end
  
  private
  def stock_params
    params.require(:stock).permit(:date, :sku, :asin, :goods_name, :number, :unit_price, :money_paid, :purchase_from, :currency, :destroy_check)
  end
  
  def set_stock
    @update_stock = current_user.stocks.find(params[:id])
  end
end

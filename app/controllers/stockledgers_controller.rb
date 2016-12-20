class StockledgersController < ApplicationController
  include StockledgersHelper
  before_action :before_import, only: [ :import]
  before_action :set_stockledger, only: [ :destroy]
  
  def index
    @stockledger = Stockledger.new
    @q = Stockledger.search(params[:q])
    @stockledgers = @q.result(distinct: true).order(:transaction_date).page(params[:page])
    
    respond_to do |format|
      format.html
      format.csv { send_data @stockledgers.to_csv, type: 'text/csv; charset=shift_jis', filename: "stockledgers.csv" } 
    end 
  end
  
  def import
    #pladminsテーブルに原価データを付与
    sale_goods_import_to_stockledger

    #stocksテーブルの内容を移す。
    Stock.all.each do |stock|
      @stockledger = Stockledger.new(stock_id: stock.id, transaction_date: stock.date, sku: stock.sku, asin: stock.asin, goods_name: stock.goods_name, classification: "購入", number: stock.number, unit_price: (stock.grandtotal)/(stock.number), grandtotal: stock.grandtotal)
      @stockledger.save
    end

    #端数処理
    rounding_fraction

    @q = Stockledger.search(params[:q])
    @stockledgers = @q.result(distinct: true).order(:transaction_date).page(params[:page])
    render 'index'    
  end
  
  def create
    params[:stockledger][:number] = params[:stockledger][:number].gsub(",","") if params[:stockledger][:number].present?
    params[:stockledger][:unit_price] = params[:stockledger][:unit_price].gsub(",","") if params[:stockledger][:unit_price].present?    
    params[:stockledger][:grandtotal] = params[:stockledger][:grandtotal].gsub(",","") if params[:stockledger][:grandtotal].present?     
    if @stockledger = Stockledger.create(stockledger_params)
      redirect_to stockledgers_path, notice: 'データを保存しました'
    else
      redirect_to stockledgers, notice: 'データの保存に失敗しました'
    end
  end
  
  def destroy
    @stockledger.destroy
    redirect_to stockledgers_path
  end  

  def stock_list
    #@stocks = Stock.all
    @q = Stock.search(params[:q])
    @stocks = @q.result(distinct: true)
  end
  
  private
  def before_import
    Stockledger.destroy_all
    Stock.all.each do |stock|
      stock.sold_unit = 0
      stock.soldout_check = false
      stock.save
    end
  end

  def stockledger_params
    params.require(:stockledger).permit(:stock_id, :transaction_date, :sku, :asin, :goods_name, :classification, :number, :unit_price, :grandtotal)
  end
  
  def set_stockledger
    @stockledger = Stockledger.find(params[:id])
  end   
end
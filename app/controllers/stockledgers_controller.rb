class StockledgersController < ApplicationController
  include StockledgersHelper
  before_action :set_stockledger, only: [ :index]
  
  def index

  #pladminsテーブルに原価データを付与
    sale_goods_import_to_stockledger
  #マルチチャンネル発送分についてstockledgersテーブルにデータを入力する
    multi_channels_import_to_stockledger  
  #返還商品についてstockledgersテーブルにデータを入力する
    return_goods_import_to_stockledger
    
  #stocksテーブルの内容を移す。
  Stock.all.each do |stock|
    @stockledger = Stockledger.new(stock_id: stock.id, transaction_date: stock.date, sku: stock.sku, asin: stock.asin, goods_name: stock.goods_name, classification: "購入", number: stock.number, unit_price: (stock.grandtotal)/(stock.number), grandtotal: stock.grandtotal)
    @stockledger.save
  end

    @q = Stockledger.search(params[:q])
    @stockledgers = @q.result(distinct: true).order(:transaction_date).page(params[:page])
    render 'show'
  end
  
  def show
    @q = Stockledger.search(params[:q])
    @stockledgers = @q.result(distinct: true).order(:transaction_date).page(params[:page])
    
    respond_to do |format|
      format.html
      format.csv { send_data @stockledgers.to_csv, type: 'text/csv; charset=shift_jis', filename: "stockledgers.csv" }    
    end    
  end
  
  def stock_list
    @stocks = Stock.all
  end
  
  private
  def set_stockledger
    Stockledger.destroy_all
  end
end
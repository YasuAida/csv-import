class StockledgersController < ApplicationController
  include StockledgersHelper
  include DummyStocksHelper  
  
  def index
    #一旦stockledgersテーブルを空にして、stockテーブルのフラグをデフォルトに戻す
    Stockledger.where.not(classification: ["購入","仕入返品"]).destroy_all
    Stock.all.each do |stock|
      stock.sold_unit = 0
      stock.soldout_check = false
      stock.save
    end
    
    #pladminsテーブルに原価データを付与
    sale_goods_import_to_stockledger

    #端数処理
    rounding_fraction
    
    #売上のキャンセル処理がされる前に商品が売れてしまった時の補正
    @dummy_stocks = DummyStock.all
    if @dummy_stocks.present?
      @dummy_stocks.each do |dummy_stock|
        add_stockledgers(dummy_stock)
      end
    end
    
    @stockledger = Stockledger.new
    @q = Stockledger.search(params[:q])
    @stockledgers = @q.result(distinct: true).order(:transaction_date).page(params[:page])  

    render 'show' 
    
  end
  
  def show
    @q = Stockledger.search(params[:q])
    @stockledgers = @q.result(distinct: true).order(:transaction_date).page(params[:page])
    
    @all_stockledgers = Stockledger.all
    respond_to do |format|
      format.html
      format.csv { send_data @all_stockledgers.to_csv, type: 'text/csv; charset=shift_jis', filename: "stockledgers.csv" } 
    end 
  end
  
  def stock_list
    @q = Stock.search(params[:q])
    @stocks = @q.result(distinct: true)
  end

end
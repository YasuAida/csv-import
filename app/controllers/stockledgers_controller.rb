class StockledgersController < ApplicationController
  include StockledgersHelper
  include DummyStocksHelper  
  
  def index
    #一旦stockledgersテーブルを空にして、stockテーブルのフラグをデフォルトに戻す
    Stockledger.destroy_all
    Stock.all.each do |stock|
      stock.sold_unit = 0
      stock.soldout_check = false
      stock.save
    end
    
    #pladminsテーブルに原価データを付与
    sale_goods_import_to_stockledger

    #stocks及びstockreturnsテーブルの内容を移す。
    Stock.all.each do |stock|
      @stockledger = Stockledger.create(stock_id: stock.id, transaction_date: stock.date, sku: stock.sku, asin: stock.asin, goods_name: stock.goods_name, classification: "購入", number: stock.number, unit_price: (stock.grandtotal)/(stock.number), grandtotal: stock.grandtotal)
    end
    
    Stockreturn.all.each do |stockreturn|
      @stockledger = Stockledger.create(stock_id: stockreturn.stock_id, transaction_date: stockreturn.date, sku: stockreturn.sku, asin: stockreturn.asin, goods_name: stockreturn.goods_name, classification: "仕入返品", number: stockreturn.number * -1, unit_price: (stockreturn.grandtotal)/(stockreturn.number), grandtotal: stockreturn.grandtotal * -1)
    end    


    #端数処理
    rounding_fraction
    
    #売上のキャンセル処理がされる前に商品が売れてしまった時の補正
    DummyStock.all.each do |dummy_stock|
      add_stockledgers(dummy_stock)
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
class StockledgersController < ApplicationController
  include StockledgersHelper
  include DummyStocksHelper  
  
  def index
    #一旦stockledgersテーブルを空にして、stockテーブルのフラグをデフォルトに戻す
    Stockledger.where.not(classification: ["購入"]).destroy_all
    Stock.all.each do |stock|
      stock.sold_unit = 0
      stock.soldout_check = false
      stock.save
    end
    
    #pladminsテーブルに原価データを付与
    sale_goods_import_to_stockledger
    
    #「仕入返品」に係るstockledgersの作成
    Stockreturn.all.each do |stockreturn|
      Stockledger.create(stock_id: stockreturn.stock_id, transaction_date: stockreturn.date, sku: stockreturn.sku, asin: stockreturn.asin, goods_name: stockreturn.goods_name, classification: "仕入返品", number: stockreturn.number * -1, unit_price: (stockreturn.grandtotal)/(stockreturn.number), grandtotal: stockreturn.grandtotal * -1)    
    end
    
    #「返還」及び「SKU付替」に係るstockledgersの作成
     ReturnGood.all.each do |return_good|
      sku_stock = Stock.find(return_good.stock_id)
      ex_price_unit = sku_stock.grandtotal / sku_stock.number
      price_unit = BigDecimal(ex_price_unit.to_s).round(0)      
      Stockledger.create(stock_id: sku_stock.id, transaction_date: return_good.date,sku: return_good.old_sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "返還", number: return_good.number * -1, unit_price: price_unit, grandtotal: price_unit * return_good.number * -1)
      Stockledger.create(stock_id: sku_stock.id, transaction_date: return_good.date,sku: return_good.new_sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "SKU付替", number: return_good.number, unit_price: price_unit, grandtotal: price_unit * return_good.number)  
    end    

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
class StockledgersController < ApplicationController
  include StockledgersHelper
  include DummyStocksHelper
  before_action :logged_in_user
  
  def index
    #一旦stockledgersテーブルを空にして、stockテーブルのフラグをデフォルトに戻す
    current_user.stockledgers.where.not(classification: ["購入"]).destroy_all
    current_user.stocks.all.each do |stock|
      stock.sold_unit = 0
      stock.soldout_check = false
      stock.save
    end
    
    #pladminsテーブルに原価データを付与
    sale_goods_import_to_stockledger
    
    #「仕入返品」に係るstockledgersの作成
    current_user.stockreturns.all.each do |stockreturn|
      current_user.stockledgers.create(stock_id: stockreturn.stock_id, transaction_date: stockreturn.date, sku: stockreturn.sku, asin: stockreturn.asin, goods_name: stockreturn.goods_name, classification: "仕入返品", number: stockreturn.number * -1, unit_price: (stockreturn.grandtotal)/(stockreturn.number), grandtotal: stockreturn.grandtotal * -1)    
    end
    
    #「返還」及び「SKU付替」に係るstockledgersの作成
    @return_goods = current_user.return_goods.where.not(stock_id: nil)
    @return_goods.each do |return_good|
      sku_stock = current_user.stocks.find(return_good.stock_id)
      ex_price_unit = sku_stock.grandtotal / sku_stock.number
      price_unit = BigDecimal(ex_price_unit.to_s).round(0)      
      current_user.stockledgers.create(stock_id: sku_stock.id, transaction_date: return_good.date,sku: return_good.old_sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "返還", number: return_good.number * -1, unit_price: price_unit, grandtotal: price_unit * return_good.number * -1)
      current_user.stockledgers.create(stock_id: sku_stock.id, transaction_date: return_good.date,sku: return_good.new_sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "SKU付替", number: return_good.number, unit_price: price_unit, grandtotal: price_unit * return_good.number)  
    end    

    #端数処理
    rounding_fraction
    
    #売上のキャンセル処理がされる前に商品が売れてしまった時の補正
    @dummy_stocks = current_user.dummy_stocks.all
    if @dummy_stocks.present?
      @dummy_stocks.each do |dummy_stock|
        add_stockledgers(dummy_stock)
      end
    end
    
    @stockledger = current_user.stockledgers.new
    @q = current_user.stockledgers.search(params[:q])
    @stockledgers = @q.result(distinct: true).order(:transaction_date).page(params[:page])  

    render 'show' 
    
  end
  
  def show
    @q = current_user.stockledgers.search(params[:q])
    @stockledgers = @q.result(distinct: true).order(:transaction_date).page(params[:page])
    
    @all_stockledgers = current_user.stockledgers.all
    respond_to do |format|
      format.html
      format.csv { send_data @all_stockledgers.to_download, type: 'text/csv; charset=shift_jis', filename: "stockledgers.csv" } 
    end 
  end
  
  def stock_list
    @q = current_user.stocks.search(params[:q])
    @stocks = @q.result(distinct: true)
  end

end
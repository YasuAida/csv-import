class StocksController < ApplicationController
  include StocksHelper

  def index
    @stocks = Stock.all
  end

  def upload 
    data = params[:upload]
    #ファイルの登録
    file_open(data[:datafile])
    #ファイルのインポート
    file_import_stock(data[:datafile])
    #ファイルの削除
    file_close(data[:datafile])

    redirect_to stocks_path
  end
  
  def rate
    #為替レートのインポート
    rate_import_to_stock
  end   

  def sku
    #SKUのインポート
    sku_import_to_stock    
  end
end

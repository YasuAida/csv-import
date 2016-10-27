class StocksController < ApplicationController
  include StocksHelper

  def index
    @stocks = Stock.all
  end

  def upload 
    data = params[:uploadstock]
    #ファイルの登録
    file_open(data[:datafile])
    #ファイルのインポート
    file_import_stock(data[:datafile])
    #ファイルの削除
    file_close(data[:datafile])

    redirect_to root_path
  end
 
end

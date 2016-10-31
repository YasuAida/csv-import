class StockacceptsController < ApplicationController
  include StockacceptsHelper
  
  def index
    @stockaccepts = Stockaccept.all
  end
  
  def upload
    data = params[:upload]
    #ファイルの登録
    file_open(data[:datafile])
    #ファイルのインポート
    file_import_stockaccept(data[:datafile])
    # #ファイルの削除
    file_close(data[:datafile])

    redirect_to root_path
  end
  
  def sku
    #受領レポートに出品レポートからSKUを引っ張ってくる
    sku_addition_to_stockaccept
  end
end


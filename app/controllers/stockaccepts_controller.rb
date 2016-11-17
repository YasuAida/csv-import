class StockacceptsController < ApplicationController
  include StockacceptsHelper
  
  def index
    #@stockaccepts = Stockaccept.all
    @q = Stockaccept.search(params[:q])
    @stockaccepts = @q.result(distinct: true)
  end
  
  def upload
    data = params[:upload]
    #ファイルの登録
    file_open(data[:datafile])
    #ファイルのインポート
    file_import_stockaccept(data[:datafile])
    #ファイルの削除
    file_close(data[:datafile])
    #受領レポートに出品レポートからSKUを引っ張ってくる
    asin_addition_to_stockaccept

    redirect_to stockaccepts_index_path
  end

end


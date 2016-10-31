class ExchangesController < ApplicationController
  include ExchangesHelper
  
  def index
    @exchanges = Exchange.all 
  end
  
  def upload
    data = params[:upload]
    #ファイルの登録
    file_open(data[:datafile])
    #ファイルのインポート
    file_import_exchange(data[:datafile])
    # #ファイルの削除
    file_close(data[:datafile])
    
    redirect_to root_path
  end
end

class ListingreportsController < ApplicationController
  include ListingreportsHelper
  
  def index
    @listingreports = Listingreport.all
  end
  
  def upload
    data = params[:upload]
    #ファイルの登録
    file_open(data[:datafile])
    #ファイルのインポート
    file_import_listingreport(data[:datafile])
    # #ファイルの削除
    file_close(data[:datafile])

    redirect_to root_path
  end
end

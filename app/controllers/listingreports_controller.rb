class ListingreportsController < ApplicationController
  include ListingreportsHelper
  before_action :logged_in_user 
  
  def index
    @listingreports = current_user.listingreports.all
  end
  
  def upload
    data = params[:upload]
    #ファイルの登録
    file_open(data[:datafile])
    #ファイルのインポート
    file_import_listingreport(data[:datafile])
    # #ファイルの削除
    file_close(data[:datafile])

    redirect_to listingreports_path
  end
end

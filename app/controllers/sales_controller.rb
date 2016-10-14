class SalesController < ApplicationController
  include UploadHelper

  def index
    @sales = Sale.all
  end

  def upload
    data = params[:upload]
    #ファイルの登録
    file_open(data[:datafile])
    #ファイルのインポート
    file_import_transaction(data[:datafile])
    #ファイルの削除
    file_close(data[:datafile])

    redirect_to root_path
  end
end

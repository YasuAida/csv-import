class ListingreportsController < ApplicationController
  include ListingreportsHelper
  before_action :set_listingreport, only: [:edit, :update]
  before_action :logged_in_user 
  
  def index
    @q = current_user.listingreports.search(params[:q])
    @listingreports = @q.result(distinct: true).page(params[:page]).per(150)
  end

  def edit
    @q = current_user.listingreports.search(params[:q])
    @listingreports = @q.result(distinct: true).page(params[:page]).per(150)     
    @listingreport = @update_listingreport
  end
  
  def update 
    if @update_listingreport.update(listingreport_params)
      redirect_to :back
    else
      redirect_to :back 
    end
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
  
  private
  def listingreport_params
    params.require(:listingreport).permit(:sku, :asin, :price, :quantity)
  end
  
  def set_listingreport
    @update_listingreport = current_user.listingreports.find(params[:id])
  end
end

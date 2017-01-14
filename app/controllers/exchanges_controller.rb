class ExchangesController < ApplicationController
  include ExchangesHelper
  before_action :set_exchange, only: [ :update] 
  before_action :logged_in_user
  
  def index
    #@exchanges = current_user.exchanges.all
    @q = current_user.exchanges.search(params[:q])
    @exchanges = @q.result(distinct: true).order(date: :desc).page(params[:page]).per(300)
    @exchange = current_user.exchanges.build
  end
  
  def upload
    data = params[:upload]
    #ファイルの登録
    file_open(data[:datafile])
    #ファイルのインポート
    file_import_exchange(data[:datafile])
    # #ファイルの削除
    file_close(data[:datafile])
    
    redirect_to exchanges_path
  end
  
  def create
    @exchange = current_user.exchanges.build(exchange_params)
    @exchange.save
    redirect_to exchanges_path , notice: '保存しました'    
  end
  
  def update
    if @exchange.update(exchange_params)
      redirect_to exchanges_path , notice: '保存しました'
    end
  end
  
  def destroy
    current_user.exchanges.where(destroy_check: true).destroy_all
    redirect_to exchanges_path, notice: 'データを削除しました'
  end 
  
  private
  def exchange_params
    params.require(:exchange).permit(:date, :country, :rate, :destroy_check)
  end
  
  def set_exchange
    @exchange = current_user.exchanges.find(params[:id])
  end
end

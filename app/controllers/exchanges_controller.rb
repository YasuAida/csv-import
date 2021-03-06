class ExchangesController < ApplicationController
  include ExchangesHelper
  before_action :set_exchange, only: [ :update] 
  
  def index
    #@exchanges = Exchange.all
    @q = Exchange.search(params[:q])
    @exchanges = @q.result(distinct: true).order(date: :desc).page(params[:page]).per(300)
    @exchange = Exchange.new
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
    @exchange = Exchange.new(exchange_params)
    @exchange.save
    redirect_to exchanges_path , notice: '保存しました'    
  end
  
  def update
    if @exchange.update(exchange_params)
      redirect_to exchanges_path , notice: '保存しました'
    end
  end
  
  def destroy
    Exchange.where(destroy_check: true).destroy_all
    redirect_to exchanges_path, notice: 'データを削除しました'
  end 
  
  private
  def exchange_params
    params.require(:exchange).permit(:date, :country, :rate, :destroy_check)
  end
  
  def set_exchange
    @exchange = Exchange.find(params[:id])
  end
end

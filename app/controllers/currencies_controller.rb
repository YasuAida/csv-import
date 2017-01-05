class CurrenciesController < ApplicationController
  before_action :set_currency, only: [ :update]  
  
  def index
    @currency = Currency.new    
    @currencies = Currency.all
    @upload_currencies = Currency.where.not(name: "円")
  end
  
  def create
    Currency.create(currency_params)
    redirect_to currencies_path , notice: 'データを保存しました'
  end
  
  def update
    if @update_currency.update(currency_params)
      redirect_to currencies_path, notice: "データを編集しました"
    else
      redirect_to currencies_path, notice: "データの編集に失敗しました"
    end
  end
  
  def destroy
    Currency.where(destroy_check: true).destroy_all
    redirect_to currencies_path, notice: 'データを削除しました'
  end
  
  private
  def currency_params
    params.require(:currency).permit(:name, :method, :destroy_check)
  end
  
  def set_currency
    @update_currency = Currency.find(params[:id])
  end  
end

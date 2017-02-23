class CurrenciesController < ApplicationController
  before_action :set_currency, only: [ :update]
  before_action :logged_in_user
  
  def index
    @currency = current_user.currencies.build   
    @currencies = current_user.currencies.all
    @upload_currencies = current_user.currencies.where.not(name: "円")
  end
  
  def create
    current_user.currencies.create(currency_params)
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
    current_user.currencies.where(destroy_check: true).destroy_all
    redirect_to currencies_path, notice: 'データを削除しました'
  end
  
  private
  def currency_params
    params.require(:currency).permit(:name, :method, :destroy_check)
  end
  
  def set_currency
    @update_currency = current_user.currencies.find(params[:id])
  end  
end

class CurrenciesController < ApplicationController
  def index
    @currency = Currency.new    
    @currencies = Currency.all
    @upload_currencies = Currency.where.not(name: "円")
  end
  
  def create
    @currency = Currency.new(currency_params)
    @currency.save
    redirect_to currencies_path , notice: 'データを保存しました'
  end
  
  def destroy
    @currency = Currency.find(params[:id])
    @currency.destroy
    redirect_to currencies_path, notice: 'データを削除しました'
  end
  
  private
  def currency_params
    params.require(:currency).permit(:name, :method)
  end
end

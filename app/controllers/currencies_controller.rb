class CurrenciesController < ApplicationController
  def index
    @currency = Currency.new    
    @currencies = Currency.all
  end
  
  def create
    @currency = Currency.new(currency_params)
    @currency.save
    redirect_to currencies_path , notice: '保存しました'
  end
  
  private
  def currency_params
    params.require(:currency).permit(:name, :method)
  end
end

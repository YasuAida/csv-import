class YahooShoppingsController < ApplicationController
  include YahooShoppingsHelper
  before_action :set_yahoo_shopping, only: [ :update]  
  before_action :logged_in_user  
    
  def index
    @all_yahoo_shoppings = current_user.yahoo_shoppings.all
    @q = current_user.yahoo_shoppings.search(params[:q])
    @yahoo_shoppings = @q.result(distinct: true).order(date: :desc).page(params[:page]).per(150)
    @yahoo_shopping = current_user.yahoo_shoppings.build
    
    respond_to do |format|
      format.html
      format.csv { send_data @all_yahoo_shoppings.to_csv, type: 'text/csv; charset=shift_jis', filename: "yahoo_shoppings.csv" }
    end
  end
  
  def receipt_upload 
    data = params[:receipt_upload]
    #ファイルの登録
    data[:datafile].each do |datafile|
      file_open(datafile)
    #ファイルのインポート
      file_import_yahoo_shopping_receipt(datafile)
    #ファイルの削除
      file_close(datafile)
    end

    redirect_to yahoo_shoppings_path
  end
  
  def payment_upload 
    data = params[:payment_upload]
    #ファイルの登録
    data[:datafile].each do |datafile|
      file_open(datafile)
    #ファイルのインポート
      file_import_yahoo_shopping_payment(datafile)
    #ファイルの削除
      file_close(datafile)
    end

    redirect_to yahoo_shoppings_path
  end

  def create
    params[:yahoo_shopping][:unit_price] = params[:yahoo_shopping][:unit_price].gsub(",","") if params[:yahoo_shopping][:unit_price].present?
    params[:yahoo_shopping][:number] = params[:yahoo_shopping][:number].gsub(",","") if params[:yahoo_shopping][:number].present?   
    params[:yahoo_shopping][:sales_amount] = params[:yahoo_shopping][:sales_amount].gsub(",","") if params[:yahoo_shopping][:sales_amount].present?
    params[:yahoo_shopping][:cogs_amount] = params[:yahoo_shopping][:cogs_amount].gsub(",","") if params[:yahoo_shopping][:cogs_amount].present?
    params[:yahoo_shopping][:commission] = params[:yahoo_shopping][:commission].gsub(",","") if params[:yahoo_shopping][:commission].present?
    params[:yahoo_shopping][:shipping_cost] = params[:yahoo_shopping][:shipping_cost].gsub(",","") if params[:yahoo_shopping][:shipping_cost].present?    
    @yahoo_shopping = current_user.yahoo_shoppings.create(yahoo_shopping_params)
    redirect_to yahoo_shoppings_path, notice: 'データを保存しました'
  end
  
  def update
    params[:yahoo_shopping][:unit_price] = params[:yahoo_shopping][:unit_price].gsub(",","") if params[:yahoo_shopping][:unit_price].present?
    params[:yahoo_shopping][:number] = params[:yahoo_shopping][:number].gsub(",","") if params[:yahoo_shopping][:number].present?   
    params[:yahoo_shopping][:sales_amount] = params[:yahoo_shopping][:sales_amount].gsub(",","") if params[:yahoo_shopping][:sales_amount].present?
    params[:yahoo_shopping][:cogs_amount] = params[:yahoo_shopping][:cogs_amount].gsub(",","") if params[:yahoo_shopping][:cogs_amount].present?
    params[:yahoo_shopping][:commission] = params[:yahoo_shopping][:commission].gsub(",","") if params[:yahoo_shopping][:commission].present?
    params[:yahoo_shopping][:shipping_cost] = params[:yahoo_shopping][:shipping_cost].gsub(",","") if params[:yahoo_shopping][:shipping_cost].present? 
    if @update_yafuoku.update(yahoo_shopping_params)
      redirect_to yahoo_shoppings_path, notice: "データを編集しました"
    else
      render "update"
    end
  end

  def destroy
    current_user.yahoo_shoppings.where(destroy_check: true).destroy_all
    redirect_to yahoo_shoppings_path, notice: 'データを削除しました'
  end
  
  private
  def yahoo_shopping_params
    params.require(:yahoo_shopping).permit(:user_id, :date, :order_id, :sku, :goods_name, :unit_price, :number, :sales_amount, :cogs_amount, :commission, :shipping_cost, :money_receive_date, :shipping_pay_date, :destroy_check)
  end
  
  def set_yahoo_shopping
    @update_yafuoku = current_user.yahoo_shoppings.find(params[:id])
  end    
end

class YafuokusController < ApplicationController
  include YafuokusHelper
  before_action :set_yafuoku, only: [:edit, :update, :copy]
  before_action :logged_in_user 
  
  def index
    @all_yafuokus = current_user.yafuokus.all
    @q = current_user.yafuokus.search(params[:q])
    @yafuokus = @q.result(distinct: true).order(date: :desc).page(params[:page]).per(150)
    @yafuoku = current_user.yafuokus.build
    
    respond_to do |format|
      format.html
      format.csv { send_data @all_yafuokus.to_csv, type: 'text/csv; charset=shift_jis', filename: "yafuokus.csv" }
    end
  end
  
  def new
    @q = current_user.yafuokus.search(params[:q])
    @yafuokus = @q.result(distinct: true).order(date: :desc).page(params[:page]).per(150)
    @yafuoku = current_user.yafuokus.build   
  end
  
  def create
    params[:yafuoku][:unit_price] = params[:yafuoku][:unit_price].gsub(",","") if params[:yafuoku][:unit_price].present?
    params[:yafuoku][:number] = params[:yafuoku][:number].gsub(",","") if params[:yafuoku][:number].present?   
    params[:yafuoku][:sales_amount] = params[:yafuoku][:sales_amount].gsub(",","") if params[:yafuoku][:sales_amount].present?
    params[:yafuoku][:cogs_amount] = params[:yafuoku][:cogs_amount].gsub(",","") if params[:yafuoku][:cogs_amount].present?
    params[:yafuoku][:commission] = params[:yafuoku][:commission].gsub(",","") if params[:yafuoku][:commission].present?
    params[:yafuoku][:shipping_cost] = params[:yafuoku][:shipping_cost].gsub(",","") if params[:yafuoku][:shipping_cost].present?    
    current_user.yafuokus.create(yafuoku_params)
    redirect_to yafuokus_path, notice: 'データを保存しました'
  end
  
  def edit
    @q = current_user.yafuokus.search(params[:q])
    @yafuokus = @q.result(distinct: true).order(date: :desc).page(params[:page]).per(150)
    @yafuoku = @update_yafuoku
  end
  
  def update
    params[:yafuoku][:unit_price] = params[:yafuoku][:unit_price].gsub(",","") if params[:yafuoku][:unit_price].present?
    params[:yafuoku][:number] = params[:yafuoku][:number].gsub(",","") if params[:yafuoku][:number].present?   
    params[:yafuoku][:sales_amount] = params[:yafuoku][:sales_amount].gsub(",","") if params[:yafuoku][:sales_amount].present?
    params[:yafuoku][:cogs_amount] = params[:yafuoku][:cogs_amount].gsub(",","") if params[:yafuoku][:cogs_amount].present?
    params[:yafuoku][:commission] = params[:yafuoku][:commission].gsub(",","") if params[:yafuoku][:commission].present?
    params[:yafuoku][:shipping_cost] = params[:yafuoku][:shipping_cost].gsub(",","") if params[:yafuoku][:shipping_cost].present? 
    if @update_yafuoku.update(yafuoku_params)
      redirect_to :back
    else
      redirect_to :back
    end
  end
 
  def copy
    @copy_yafuoku = @update_yafuoku.dup
    @copy_yafuokus = current_user.yafuokus.where(date: @copy_yafuoku.date, order_num: @copy_yafuoku.order_num, goods_name: @copy_yafuoku.goods_name, unit_price: @copy_yafuoku.unit_price, money_receipt_date: @copy_yafuoku.money_receipt_date)
    @copy_yafuoku.sku = @copy_yafuoku.sku + "(" + @copy_yafuokus.count.to_s + ")"
    
    if @copy_yafuoku.save 
      @copy_yafuokus = current_user.yafuokus.where(date: @copy_yafuoku.date, order_num: @copy_yafuoku.order_num, goods_name: @copy_yafuoku.goods_name, unit_price: @copy_yafuoku.unit_price, money_receipt_date: @copy_yafuoku.money_receipt_date)
    else
      redirect_to :back 
    end  
  end
  
  def blank_form
    render "index"
  end

  def upload 
    data = params[:upload]
    #ファイルの登録
    file_open(data[:datafile])
    #ファイルのインポート
    file_import_yafuoku(data[:datafile])
    #ファイルの削除
    file_close(data[:datafile])

    redirect_to yafuokus_path
  end

  def destroy
    current_user.yafuokus.where(destroy_check: true).destroy_all
    redirect_to yafuokus_path, notice: 'データを削除しました'
  end
  
  private
  def yafuoku_params
    params.require(:yafuoku).permit(:user_id, :stock_id, :date, :order_num, :sku, :goods_name, :sale_place, :unit_price, :number, :sales_amount, :cogs_amount, :commission, :shipping_cost, :money_receipt_date, :commission_pay_date, :shipping_pay_date, :destroy_check)
  end
  
  def set_yafuoku
    @update_yafuoku = current_user.yafuokus.find(params[:id])
  end
  
end

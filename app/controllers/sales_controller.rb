class SalesController < ApplicationController
  include SalesHelper
  include ApplicationHelper #expenseledgerで為替レートを付与している
  before_action :set_sale, only: [:edit, :update]
  before_action :logged_in_user

  def index
    @all_sales = current_user.sales.all
    @q = current_user.sales.search(params[:q])
    @sales = @q.result(distinct: true).order(date: :desc).page(params[:page]).per(300)
  end

  def edit
    @q = current_user.sales.search(params[:q])
    @sales = @q.result(distinct: true).order(date: :desc).page(params[:page]).per(150)     
    @sale = @update_sale
  end

  def update 
    if @update_sale.update(sale_params)
      redirect_to :back
    else
      redirect_to :back 
    end
  end
  
  def upload
    data = params[:upload]
    #ファイルの登録
    data[:datafile].each do |datafile|
      file_open(datafile)
    #ファイルのインポート
      file_import_transaction(datafile)
    #ファイルの削除
      file_close(datafile)
    end

    redirect_to sales_path
  end
  
  def handling
    #「処理」欄を記入
    add_handling  
  end
  
  def pladmin  
    #損益管理シートへ売上・手数料の転記
    import_to_pladmin
      
    redirect_to pladmins_path      
  end

  private
  def sale_params
    params.require(:sale).permit(:date, :order_num, :sku, :kind_of_transaction, :kind_of_payment, :detail_of_payment, :amount, :quantity, :goods_name, :money_receive, :handling)
  end
  
  def set_sale
    @update_sale = current_user.sales.find(params[:id])
  end
end

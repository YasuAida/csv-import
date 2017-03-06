class ExpenseledgersController < ApplicationController
  include ApplicationHelper
  include ExpenseledgersHelper
  before_action :set_expenseledger, only: [:edit, :update, :copy]
  before_action :logged_in_user

  def index
    @all_expenseledgers = current_user.expenseledgers.all
    @q = current_user.expenseledgers.search(params[:q])
    @expenseledgers = current_user.expenseledgers.order(date: :desc).page(params[:page]).per(100)
    @expenseledger = current_user.expenseledgers.build
    
    respond_to do |format|
      format.html
      format.csv { send_data @all_expenseledgers.to_download, type: 'text/csv; charset=shift_jis', filename: "expenseledgers.csv" }
    end
  end
  
  def new
    @q = current_user.expenseledgers.search(params[:q])
    @expenseledgers = current_user.expenseledgers.order(date: :desc).page(params[:page]).per(100)
    @expenseledger = current_user.expenseledgers.build  
  end
  
  def create
    params[:expenseledger][:amount] = params[:expenseledger][:amount].gsub(",","") if params[:expenseledger][:amount].present?
    @expenseledger = current_user.expenseledgers.build(expenseledger_params)
    if @expenseledger.save
      rate_import_new_object(@expenseledger)
      ex_grandtotal = @expenseledger.amount * @expenseledger.rate 
      @expenseledger.grandtotal = BigDecimal(ex_grandtotal.to_s).round(0)
      @expenseledger.save
      redirect_to expenseledgers_path, notice: 'データを保存しました'
    else
      redirect_to expenseledgers, notice: 'データの保存に失敗しました'
    end
  end
  
  def edit
    @q = current_user.expenseledgers.search(params[:q])
    @expenseledgers = current_user.expenseledgers.order(date: :desc).page(params[:page]).per(100)     
    @expenseledger = @update_expenseledger
  end
  
  def update
    params[:expenseledger][:amount] = params[:expenseledger][:amount].gsub(",","") if params[:expenseledger][:amount].present?    
    if @update_expenseledger.update(expenseledger_params)
      @update_expenseledger.save
      redirect_to expenseledgers_path, notice: "データを編集しました"
    else
      redirect_to expenseledgers_path, notice: "データの編集に失敗しました"
    end
  end
  
  def copy
    @copy_expenseledger = @update_expenseledger.dup
    @copy_expenseledgers = current_user.expenseledgers.where(sale_id: @copy_expenseledger.sale_id, date: @copy_expenseledger.date, account_name: @copy_expenseledger.account_name, money_paid: @copy_expenseledger.money_paid, purchase_from: @copy_expenseledger.purchase_from)
    @copy_expenseledger.content = @copy_expenseledger.content + "(" + @copy_expenseledgers.count.to_s + ")"
    if @copy_expenseledger.save
    #為替レートの付与
      rate_import_new_object(@copy_expenseledger)
    #商品金額の確定
      ex_grandtotal = @copy_expenseledger.amount * @copy_expenseledger.rate 
      @copy_expenseledger.grandtotal = BigDecimal(ex_grandtotal.to_s).round(0)
      @copy_expenseledger.save
 
      @copy_expenseledgers = current_user.expenseledgers.where(sale_id: @copy_expenseledger.sale_id, date: @copy_expenseledger.date, account_name: @copy_expenseledger.account_name, money_paid: @copy_expenseledger.money_paid, purchase_from: @copy_expenseledger.purchase_from)
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
    file_import_expenseledger(data[:datafile])
    #為替レートの付与    
    rate_import(current_user.expenseledgers.where(rate: nil))
    #円金額の確定
    grandtotal(current_user.expenseledgers.where(grandtotal: nil))
    #ファイルの削除
    file_close(data[:datafile])

    redirect_to expenseledgers_path
  end
  
  def destroy
    current_user.expenseledgers.where(destroy_check: true).destroy_all
    redirect_to expenseledgers_path, notice: 'データを削除しました'
  end
  
  private
  def expenseledger_params
    params.require(:expenseledger).permit(:date, :account_name, :content, :amount, :money_paid, :purchase_from, :currency, :destroy_check)
  end
  
  def set_expenseledger
    @update_expenseledger = current_user.expenseledgers.find(params[:id])
  end  
  
end

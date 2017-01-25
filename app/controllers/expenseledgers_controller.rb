class ExpenseledgersController < ApplicationController
  include ApplicationHelper
  include ExpenseledgersHelper
  before_action :set_expenseledger, only: [ :update]
  before_action :logged_in_user

  def index
    @all_expenseledgers = current_user.expenseledgers.all
    @expenseledger = current_user.expenseledgers.build
    @expenseledgers = current_user.expenseledgers.all.order(date: :desc).page(params[:page]).per(300)
    
    respond_to do |format|
      format.html
      format.csv { send_data @all_expenseledgers.to_csv, type: 'text/csv; charset=shift_jis', filename: "expenseledgers.csv" }
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
  
  def update
    params[:expenseledger][:amount] = params[:expenseledger][:amount].gsub(",","") if params[:expenseledger][:amount].present?    
    if @update_expenseledger.update(expenseledger_params)
      @update_expenseledger.save
      redirect_to expenseledgers_path, notice: "データを編集しました"
    else
      redirect_to expenseledgers_path, notice: "データの編集に失敗しました"
    end
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

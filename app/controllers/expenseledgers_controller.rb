class ExpenseledgersController < ApplicationController
  include ApplicationHelper
  before_action :set_expenseledger, only: [ :update, :destroy]

  def index
    @expenseledger = Expenseledger.new
    @expenseledgers = Expenseledger.all.order(date: :desc).page(params[:page])
  end
  
  def create
    params[:expenseledger][:amount] = params[:expenseledger][:amount].gsub(",","") if params[:expenseledger][:amount].present?
    @expenseledger = Expenseledger.new(expenseledger_params)
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
      redirect_to expenseledgers_path, notice: "データを編集しました"
    else
      redirect_to expenseledgers_path, notice: "データの編集に失敗しました"
    end
  end
  
  def destroy
    @update_expenseledger.destroy
    redirect_to expenseledgers_path
  end
  
  private
  def expenseledger_params
    params.require(:expenseledger).permit(:date, :account_name, :content, :amount, :money_paid, :purchase_from, :currency)
  end
  
  def set_expenseledger
    @update_expenseledger = Expenseledger.find(params[:id])
  end  
  
end

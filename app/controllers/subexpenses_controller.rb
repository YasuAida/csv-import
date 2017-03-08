class SubexpensesController < ApplicationController
  include ApplicationHelper
  before_action :set_subexpense, only: [ :edit, :update]
  before_action :logged_in_user
  
  def index
    @subexpense = current_user.subexpenses.build
    @q = current_user.subexpenses.search(params[:q])
    @subexpenses = @q.result(distinct: true).order(date: :desc).page(params[:page])
  end
  
  def new
    @q = current_user.subexpenses.search(params[:q])
    @subexpenses = @q.result(distinct: true).order(id: :desc).page(params[:page])
    @subexpense = current_user.subexpenses.build
           
    if params[:q].present?
      @target_stocks = current_user.stocks.where(date: params[:q])
    else
      @target_stocks = current_user.stocks.all
    end
  end
  
  def create
    params[:subexpense][:amount] = params[:subexpense][:amount].gsub(",","") if params[:subexpense][:amount].present?
    @subexpense = current_user.subexpenses.build(subexpense_params)
    rate_import_new_object(@subexpense)

    params[:subexpense][:targetgood].each do |n|
      @subexpense.expense_relations.find_or_create_by(user_id: @subexpense.user_id, stock_id: n.to_i) if @subexpense.id.present?
    end

    redirect_to new_subexpense_path
  end
 
  def edit
    @q = current_user.subexpenses.search(params[:q])
    @subexpenses = @q.result(distinct: true).order(id: :desc).page(params[:page])     
    @subexpense = @update_subexpense
                   
    if params[:q].present?
      @target_stocks = current_user.stocks.where(date: params[:q])
    else
      @target_stocks = current_user.stocks.all
    end
  end

  def update
    params[:subexpense][:amount] = params[:subexpense][:amount].gsub(",","") if params[:subexpense][:amount].present?
    if @update_subexpense.update(subexpense_params)
      redirect_to subexpense_path(@update_subexpense), notice: 'データを更新しました'
    else
      redirect_to subexpense_path(@update_subexpense), notice: 'データの更新に失敗しました'
    end
  end
  
  def destroy
    current_user.subexpenses.where(destroy_check: true).destroy_all
    redirect_to subexpenses_path, notice: 'データを削除しました'
  end

  private
  def subexpense_params
    params.require(:subexpense).permit(:item, :date, :amount, :purchase_from, :rate, :currency, :money_paid, :destroy_check, targetgood: [])
  end

  def set_subexpense
    @update_subexpense = current_user.subexpenses.find(params[:id])
  end
end

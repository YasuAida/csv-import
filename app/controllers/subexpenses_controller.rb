class SubexpensesController < ApplicationController
  include ApplicationHelper
  before_action :set_subexpense, only: [ :update]  
  
  def index
    @subexpense = Subexpense.new
    @subexpenses = Subexpense.all
    
    if params[:q].present?
      @target_stocks = Stock.where(date: params[:q])
    else
      @target_stocks = Stock.all
    end
  end
  
  def create
    params[:subexpense][:amount] = params[:subexpense][:amount].gsub(",","") if params[:subexpense][:amount].present?
    @subexpense = Subexpense.new(subexpense_params)
    rate_import_new_object(@subexpense)

    params[:subexpense][:targetgood].each do |n|
      @subexpense.expense_relations.find_or_create_by(stock_id: n.to_i) if @subexpense.id.present?
    end

    redirect_to subexpense_path(@subexpense), notice: '保存しました'
  end

  def update
    params[:subexpense][:amount] = params[:subexpense][:amount].gsub(",","") if params[:subexpense][:amount].present?
    if @update_subexpense.update(subexpense_params)
      @update_subexpense.gl_flag = false
      @update_subexpense.expense_relations.gl_flag = false
      @update_subexpense.save
      @update_subexpense.expense_relations.save
      redirect_to subexpense_path(@update_subexpense), notice: 'データを更新しました'
    else
      redirect_to subexpense_path(@update_subexpense), notice: 'データの更新に失敗しました'
    end
  end
  
  def destroy
    Subexpense.where(destroy_check: true).destroy_all
    redirect_to subexpenses_path, notice: 'データを削除しました'
  end

  private
  def subexpense_params
    params.require(:subexpense).permit(:item, :date, :amount, :purchase_from, :currency, :money_paid, :destroy_check, targetgood: [])
  end

  def set_subexpense
    @update_subexpense = Subexpense.find(params[:id])
  end
end

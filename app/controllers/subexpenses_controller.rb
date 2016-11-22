class SubexpensesController < ApplicationController
  include SubexpensesHelper
  before_action :set_subexpense, only: [ :update, :destroy]  
  
  def index
    @subexpense = Subexpense.new
    @subexpenses = Subexpense.all
    
    if params[:q].present?
      @target_stocks = Stock.where(purchase_date: params[:q])
    else
      @target_stocks = Stock.all
    end
  end
  
  def create
    @subexpense = Subexpense.new(subexpense_params)
    @subexpense.save

    params[:subexpense][:targetgood].each do |n|
      @subexpense.expense_relations.find_or_create_by(stock_id: n.to_i) if @subexpense.id.present?
    end

    #為替レートのインポート
    rate_import_to_subexpense

    redirect_to subexpense_path(@subexpense), notice: '保存しました'
  end

  def update
    if @update_subexpense.update(subexpense_params)
      redirect_to subexpense_path(@update_subexpense), notice: 'データを更新しました'
    else
      redirect_to subexpense_path(@update_subexpense), notice: 'データの更新に失敗しました'
    end
  end
  
  def destroy
    @update_subexpense.destroy
    redirect_to subexpenses_path, notice: 'データを削除しました'
  end

  private
  def subexpense_params
    params.require(:subexpense).permit(:item, :date, :amount, :purchase_from, :currency, method: [], targetgood: [])
  end

  def set_subexpense
    @update_subexpense = Subexpense.find(params[:id])
  end
end

class SubexpensesController < ApplicationController
  include SubexpensesHelper
  
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

    redirect_to subexpenses_path, notice: '保存しました'
    #為替レートのインポート
    rate_import_to_subexpense
  end

  private
  def subexpense_params
    params.require(:subexpense).permit(:item, :date, :amount, :purchase_from, :currency, method: [], targetgood: [])
  end

end

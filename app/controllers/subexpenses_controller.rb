class SubexpensesController < ApplicationController
  def index
    @subexpense = Subexpense.new
    @subexpenses = Subexpense.all
  end
  
  def create
    @subexpense = Subexpense.new(subexpense_params)
    @subexpense.save
    redirect_to subexpense_path(@subexpense) , notice: '保存しました'
  end
  
  private
  def subexpense_params
    params.require(:subexpense).permit(:item, :date, :amount, :purchase_from, method: [], targetgood: [])
  end

end

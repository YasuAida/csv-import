class ExpenseTitlesController < ApplicationController
  before_action :set_expense_title, only: [ :update, :destroy]   
  
  def index
    @expense_title = ExpenseTitle.new
    @expense_titles = ExpenseTitle.all
  end
  
  def create
    @expense_title = ExpenseTitle.new(expense_title_params)
    @expense_title.save
    redirect_to expense_titles_path , notice: '保存しました'
  end
  
  def update
    if @expense_title.update(expense_title_params)
      redirect_to expense_titles_path , notice: '保存しました'
    end
  end
  
  def destroy
    @expense_title.destroy
    redirect_to expense_titles_path, notice: '削除しました'
  end

  private
  def expense_title_params
    params.require(:expense_title).permit(:item)
  end
  
  def set_expense_title
    @expense_title = ExpenseTitle.find(params[:id])
  end
end

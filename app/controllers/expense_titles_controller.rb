class ExpenseTitlesController < ApplicationController
  def index
    @expense_title = ExpenseTitle.new
    @expense_titles = ExpenseTitle.all
  end
  
  def create
    @expense_title = ExpenseTitle.new(expense_title_params)
    @expense_title.save
    redirect_to expense_titles_index_path , notice: '保存しました'
  end

  private
  def expense_title_params
    params.require(:expense_title).permit(:item)
  end
end

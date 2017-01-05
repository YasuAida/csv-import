class ExpenseTitlesController < ApplicationController
  before_action :set_expense_title, only: [ :destroy]   
  
  def index
    @expense_title = ExpenseTitle.new
    @expense_titles = ExpenseTitle.all
  end
  
  def create
    @expense_title = ExpenseTitle.new(expense_title_params)
    @expense_title.save
    redirect_to expense_titles_path , notice: '保存しました'
  end

  def show
    @expense_titles = ExpenseTitle.all
  end
  
  def update
    @update_expense_title = ExpenseTitle.find_by(item: params[:expense_title][:item])
    copy_method = params[:expense_title][:method].dup
    copy_method.shift  
    @update_expense_title.method = copy_method
    @update_expense_title.save
    redirect_to expense_titles_path , notice: '保存しました'
  end
  
  def destroy
    @update_expense_title.destroy
    redirect_to expense_titles_path, notice: '削除しました'
  end

  private
  def expense_title_params
    params.require(:expense_title).permit(:item, :method => [])
  end
  
  def set_expense_title
    @update_expense_title = ExpenseTitle.find(params[:id])
  end
end

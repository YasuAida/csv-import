class ExpenseShowsController < ApplicationController
  before_action :set_expense_title, only: [:edit, :update]
  before_action :logged_in_user
  
  def index
    @expense_titles = current_user.expense_titles.all
    @expense_title = current_user.expense_titles.build
  end
  
  def edit
    @q = current_user.expense_titles.search(params[:q])
    @expense_titles = @q.result(distinct: true).page(params[:page]) 
    @expense_title = @update_expense_title
  end
  
  def update
    if @update_expense_title.update(expense_title_params)
      redirect_to expense_shows_path
    else
      redirect_to expense_shows_path
    end
  end
  
  def destroy
    current_user.expense_titles.where(destroy_check: true).destroy_all
    redirect_to expense_shows_path
  end

  private
  def expense_title_params
    params.require(:expense_title).permit(:item, :destroy_check, :method => [])
  end
  
  def set_expense_title
    @update_expense_title = current_user.expense_titles.find(params[:id])
  end  
end

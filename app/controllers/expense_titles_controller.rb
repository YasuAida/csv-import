class ExpenseTitlesController < ApplicationController
  before_action :set_expense_title, only: [ :destroy] 
  before_action :logged_in_user
  
  def index
    @expense_title = current_user.expense_titles.build
    @expense_titles = current_user.expense_titles.all
  end
  
  def create
    @expense_title = current_user.expense_titles.build(expense_title_params)
    @expense_title.save
    redirect_to expense_titles_path , notice: '保存しました'
  end

  def show
    @expense_titles = current_user.expense_titles.all
  end
  
  def update
    @update_expense_title = current_user.expense_titles.find_by(item: params[:expense_title][:item])
    if @update_expense_title.save
      redirect_to expense_titles_show_path , notice: 'データを更新しました'
    else
      redirect_to expense_titles_show_path , notice: 'データの更新に失敗しました'
    end
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
    @update_expense_title = current_user.expense_titles.find(params[:id])
  end
end

class AccountsController < ApplicationController
  before_action :set_accounts, only: [:edit, :update, :copy]
  before_action :logged_in_user

  def index
    @q = current_user.accounts.order(:bs_pl).order(display_position: :desc).search(params[:q])
    @accounts = @q.result(distinct: true).page(params[:page])
    @account = current_user.accounts.build
  end
  
  def new
    @q = current_user.accounts.order(:bs_pl).order(display_position: :desc).search(params[:q])
    @accounts = @q.result(distinct: true).page(params[:page])
    @account = current_user.accounts.build 
  end
  
  def create
    @account = current_user.accounts.build(accounts_params)
    if @account.save
      redirect_to accounts_path, notice: 'データを保存しました'
    else
      redirect_to accounts, notice: 'データの保存に失敗しました'
    end
  end
  
  def edit
    @q = current_user.accounts.order(:bs_pl).order(display_position: :desc).search(params[:q])
    @accounts = @q.result(distinct: true).page(params[:page])
    @account = @update_account
  end
  
  def update 
    if @update_account.update(accounts_params)
      redirect_to accounts_path, notice: "データを編集しました"
    else
      redirect_to accounts_path, notice: "データの編集に失敗しました"
    end
  end
  
  def destroy
    current_user.accounts.where(destroy_check: true).destroy_all
    redirect_to accounts_path, notice: 'データを削除しました'
  end
  
  private
  def accounts_params
    params.require(:account).permit(:account, :debit_credit, :bs_pl, :display_position, :destroy_check)
  end
  
  def set_accounts
    @update_account = current_user.accounts.find(params[:id])
  end  
end
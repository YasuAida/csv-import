class AccountsController < ApplicationController
  before_action :set_accounts, only: [ :update]

  def index
    @account = Account.new
    @accounts = Account.all.order(:bs_pl).order(display_position: :desc)
  end
  
  def create
    @account = Account.new(accounts_params)
    if @account.save
      redirect_to accounts_path, notice: 'データを保存しました'
    else
      redirect_to accounts, notice: 'データの保存に失敗しました'
    end
  end
  
  def update 
    if @update_account.update(accounts_params)
      redirect_to accounts_path, notice: "データを編集しました"
    else
      redirect_to accounts_path, notice: "データの編集に失敗しました"
    end
  end
  
  def destroy
    Account.where(destroy_check: true).destroy_all
    redirect_to accounts_path, notice: 'データを削除しました'
  end
  
  private
  def accounts_params
    params.require(:account).permit(:account, :debit_credit, :bs_pl, :display_position, :destroy_check)
  end
  
  def set_accounts
    @update_account = Account.find(params[:id])
  end  
end
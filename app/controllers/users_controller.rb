class UsersController < ApplicationController
  before_action :correct_user, only: [ :show, :update]  
  
  def index
    @user = User.new
    render 'new'
  end

  def show 
   @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      
      CSV.foreach('db/entrypattern.txt') do |row|
        @entrypattern = current_user.entrypatterns.create(user_id: @user.id)
        @entrypattern.update(:sku => row[0], :kind_of_transaction => row[1], :kind_of_payment => row[2], :detail_of_payment => row[3], :handling => row[4])      
      end
      CSV.foreach('db/journalpattern.txt') do |row|
        @journalpattern = current_user.journalpatterns.create(user_id: @user.id)      
        @journalpattern.update(:taxcode => row[0], :ledger => row[1], :pattern => row[2], :debit_account => row[3], :debit_subaccount => row[4], :debit_taxcode => row[5], :credit_account => row[6], :credit_subaccount => row[7], :credit_taxcode => row[8])
      end
      CSV.foreach('db/account.txt') do |row|
        @account = current_user.accounts.create(user_id: @user.id) 
        @account.update(:account => row[0], :debit_credit => row[1], :bs_pl => row[2], :display_position => row[3])
      end
      current_user.currencies.create(name: '円', method: '換算無し', user_id: current_user.id)
      
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def update
    if @user.update(user_params)
      redirect_to user_path , notice: '保存しました'
    else
      redirect_to user_path , notice: '保存に失敗しました'
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :furigana, :postal_code, :address, :telephone_number, :email, :password, :password_confirmation)
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path if @user != current_user
  end
end

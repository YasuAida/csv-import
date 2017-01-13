class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update]  
  
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
      flash[:success] = "ユーザー登録が完了しました"
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
  
  def set_user
    @user = User.find(params[:id])
  end 
end

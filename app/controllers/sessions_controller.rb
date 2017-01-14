class SessionsController < ApplicationController

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      flash[:info] = "ユーザー名 #{@user.name}"
      redirect_to @user
    else
      flash[:danger] = '無効なメールアドレス／パスワードです'
      render 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end

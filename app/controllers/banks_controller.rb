class BanksController < ApplicationController
  before_action :set_bank, only: [:edit, :update]
  before_action :logged_in_user
  
  def index
    @banks = current_user.banks.all
    @bank = current_user.banks.build
  end
  
  def create
    @bank = current_user.banks.create(bank_params)
    redirect_to banks_path
  end
  
  def edit
    @q = current_user.banks.search(params[:q])
    @banks = @q.result(distinct: true).page(params[:page]) 
    @bank = @update_bank
  end
  
  def update
    if @update_bank.update(bank_params)
      redirect_to banks_path
    else
      redirect_to banks_path
    end
  end
  
  def destroy
    current_user.banks.where(destroy_check: true).destroy_all
    redirect_to banks_path
  end

  private
  def bank_params
    params.require(:bank).permit(:name, :destroy_check)
  end
  
  def set_bank
    @update_bank = current_user.banks.find(params[:id])
  end
end

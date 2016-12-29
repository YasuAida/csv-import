class VouchersController < ApplicationController
  before_action :set_voucher, only: [ :update]  
  
  def index
    @vouchers = Voucher.all.order(date: :desc).page(params[:page])
    @voucher = Voucher.new
  end

  def create
    params[:voucher][:amount] = params[:voucher][:amount].gsub(",","") if params[:voucher][:amount].present?
    @voucher = Voucher.new(voucher_params)
    if @voucher.save
      redirect_to vouchers_path, notice: 'データを保存しました'
    else
      redirect_to vouchers_path, notice: 'データの保存に失敗しました'
    end
  end
  
  def update
    params[:voucher][:amount] = params[:voucher][:amount].gsub(",","") if params[:voucher][:amount].present?
    if @update_voucher.update(voucher_params)
      render 'update_ajax'
    else
      flash.now[:alert] = "データの編集に失敗しました。"
      render 'update_ajax'
    end
  end
  
  def destroy
    Voucher.where(destroy_check: true).destroy_all
    redirect_to vouchers_path, notice: 'データを削除しました'
  end
  
  private
  def voucher_params
    params.require(:voucher).permit(:date, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode,:amount, :content, :trade_company, :destroy_check)
  end
  
  def set_voucher
    @update_voucher = Voucher.find(params[:id])
  end
end


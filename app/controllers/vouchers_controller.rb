class VouchersController < ApplicationController
  before_action :set_voucher, only: [ :update, :destroy]  
  
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
      redirect_to vouchers_path, notice: "データを更新しました"
    else
      render "update", notice: "データの更新に失敗しました"
    end
  end
  
  def destroy
    @update_voucher.destroy
    redirect_to vouchers_path  
  end
  
  private
  def voucher_params
    params.require(:voucher).permit(:date, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode,:amount, :content, :trade_company)
  end
  
  def set_voucher
    @update_voucher = Voucher.find(params[:id])
  end
end


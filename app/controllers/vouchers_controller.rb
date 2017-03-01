class VouchersController < ApplicationController
  include VouchersHelper
  before_action :set_voucher, only: [ :update]
  before_action :logged_in_user
  
  def index
    @all_vouchers = current_user.vouchers.all
    @vouchers = current_user.vouchers.all.order(date: :desc).page(params[:page])
    @voucher = current_user.vouchers.build    
  end

  def blank_form
    render "index"
  end

  def upload 
    data = params[:upload]
    #ファイルの登録
    file_open(data[:datafile])
    #ファイルのインポート
    file_import_voucher(data[:datafile])
    #ファイルの削除
    file_close(data[:datafile])

    redirect_to vouchers_path
  end

  def create
    params[:voucher][:amount] = params[:voucher][:amount].gsub(",","") if params[:voucher][:amount].present?
    @voucher = current_user.vouchers.build(voucher_params)
    if @voucher.save
      redirect_to vouchers_path, notice: 'データを保存しました'
    else
      redirect_to vouchers_path, notice: 'データの保存に失敗しました'
    end
  end
  
  def update
    params[:voucher][:amount] = params[:voucher][:amount].gsub(",","") if params[:voucher][:amount].present?
    if @update_voucher.update(voucher_params)
      @update_voucher.gl_flag = false
      @update_voucher.save
      render 'update_ajax'
    else
      flash.now[:alert] = "データの編集に失敗しました。"
      render 'update_ajax'
    end
  end
  
  def destroy
    current_user.vouchers.where(destroy_check: true).destroy_all
    redirect_to vouchers_path, notice: 'データを削除しました'
  end
  
  private
  def voucher_params
    params.require(:voucher).permit(:date, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode,:amount, :content, :trade_company, :destroy_check)
  end
  
  def set_voucher
    @update_voucher = current_user.vouchers.find(params[:id])
  end
end


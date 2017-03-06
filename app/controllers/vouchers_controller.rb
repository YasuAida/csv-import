class VouchersController < ApplicationController
  include VouchersHelper
  before_action :set_voucher, only: [:edit, :update, :copy]
  before_action :logged_in_user
  
  def index
    @all_vouchers = current_user.vouchers.all
    @q = current_user.vouchers.search(params[:q])
    @vouchers = @q.result(distinct: true).order(date: :desc).page(params[:page]).per(50)
    @voucher = current_user.vouchers.build    
  end 
  
  def new
    @q = current_user.vouchers.search(params[:q])
    @vouchers = @q.result(distinct: true).order(date: :desc).page(params[:page]).per(50)
    @voucher = current_user.vouchers.build   
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

  def edit
    @q = current_user.vouchers.search(params[:q])
    @vouchers = @q.result(distinct: true).order(date: :desc).page(params[:page]).per(50)
    @voucher = @update_voucher
  end
  
  def update
    params[:voucher][:amount] = params[:voucher][:amount].gsub(",","") if params[:voucher][:amount].present?
    if @update_voucher.update(voucher_params)
      redirect_to :back
    else
      redirect_to :back
    end
  end

  def copy
    @copy_voucher = @update_voucher.dup
    @copy_vouchers = current_user.vouchers.where(date: @copy_voucher.date, debit_account: @copy_voucher.debit_account, debit_subaccount: @copy_voucher.debit_subaccount, credit_account: @copy_voucher.credit_account, credit_subaccount: @copy_voucher.credit_subaccount, trade_company: @copy_voucher.trade_company)
    @copy_voucher.content = @copy_voucher.content + "(" + @copy_vouchers.count.to_s + ")"
    
    if @copy_voucher.save 
      @copy_vouchers = current_user.vouchers.where(date: @copy_voucher.date, debit_account: @copy_voucher.debit_account, debit_subaccount: @copy_voucher.debit_subaccount, credit_account: @copy_voucher.credit_account, credit_subaccount: @copy_voucher.credit_subaccount, trade_company: @copy_voucher.trade_company)
    else
      redirect_to :back 
    end  
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


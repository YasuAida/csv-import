class PladminsController < ApplicationController
  include PladminsHelper  
  before_action :set_pladmin, only: [ :update]
  before_action :logged_in_user
  
  def index
    @pladmin = current_user.pladmins.build
    
    @all_pladmins = current_user.pladmins.all
    @q = current_user.pladmins.order(date: :desc).search(params[:q])
    @pladmins = @q.result(distinct: true).page(params[:page]).per(100)
    
    respond_to do |format|
      format.html
      format.csv { send_data @all_pladmins.to_csv, type: 'text/csv; charset=shift_jis', filename: "pladmins.csv" }
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
    file_import_pladmin(data[:datafile])
    #マルチチャンネル発送取引をマージする
    merge_multi_channel
    #ファイルの削除
    file_close(data[:datafile])

    redirect_to pladmins_path
  end
  
  def create
    params[:pladmin][:sale_amount] = params[:pladmin][:sale_amount].gsub(",","") if params[:pladmin][:sale_amount].present?
    params[:pladmin][:commission] = params[:pladmin][:commission].gsub(",","") if params[:pladmin][:commission].present?
    params[:pladmin][:cgs_amount] = params[:pladmin][:cgs_amount].gsub(",","") if params[:pladmin][:cgs_amount].present?
    @pladmin = current_user.pladmins.build(pladmin_params)
    @pladmin.save
    redirect_to pladmins_path, notice: 'データを保存しました'
  end
  
  def update
    params[:pladmin][:sale_amount] = params[:pladmin][:sale_amount].gsub(",","") if params[:pladmin][:sale_amount].present?
    params[:pladmin][:commission] = params[:pladmin][:commission].gsub(",","") if params[:pladmin][:commission].present?
    params[:pladmin][:cgs_amount] = params[:pladmin][:cgs_amount].gsub(",","") if params[:pladmin][:cgs_amount].present?
    if @update_pladmin.update(pladmin_params)
      @update_pladmin.gl_flag = false
      @update_pladmin.save
      redirect_to pladmins_path, notice: "データを編集しました"
    else
      render "update"
    end
  end

  def destroy
    current_user.pladmins.where(destroy_check: true).destroy_all
    redirect_to pladmins_path, notice: 'データを削除しました'
  end
  
  private
  def pladmin_params
    params.require(:pladmin).permit(:date, :order_num, :sku, :goods_name, :quantity, :sale_amount, :commission, :cgs_amount, :money_receive, :sale_place, :shipping_cost, :commission_pay_date, :shipping_pay_date, :destroy_check)
  end
  
  def set_pladmin
    @update_pladmin = current_user.pladmins.find(params[:id])
  end
  
end

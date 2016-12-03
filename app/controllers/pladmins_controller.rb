class PladminsController < ApplicationController
  include PladminsHelper  
  before_action :set_pladmin, only: [ :update, :destroy]  
  
  def index
    @pladmin = Pladmin.new

    #@pladmins = Pladmin.all
    @q = Pladmin.search(params[:q])
    @pladmins = @q.result(distinct: true)
    
    respond_to do |format|
      format.html
      format.csv { send_data @pladmins.to_csv, type: 'text/csv; charset=shift_jis', filename: "pladmins.csv" }
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
    @pladmin = Pladmin.new(pladmin_params)
    @pladmin.save
    redirect_to pladmins_path, notice: 'データを保存しました'
  end
  
  def update
    if @update_pladmin.update(pladmin_params)
      redirect_to pladmins_path, notice: "データを編集しました"
    else
      render "update"
    end
  end
  
  private
  def pladmin_params
    params.require(:pladmin).permit(:date, :order_num, :sku, :goods_name, :sale_amount, :commission, :cgs_amount, :money_receive, :sale_place, :shipping_cost, :commission_pay_date, :shipping_pay_date)
  end
  
  def set_pladmin
    @update_pladmin = Pladmin.find(params[:id])
  end
  
  
end

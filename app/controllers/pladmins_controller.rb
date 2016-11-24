class PladminsController < ApplicationController
  before_action :set_pladmin, only: [ :update, :destroy]  
  
  def index
    @pladmin = Pladmin.new

    if params[:q].present?
      @pladmins = Pladmin.where(sku: params[:q]).order(:date)
    else
      @pladmins = Pladmin.all.order(:date)
    end
    
    respond_to do |format|
      format.html
      format.csv { send_data @pladmins.to_csv, type: 'text/csv; charset=shift_jis', filename: "pladmins.csv" }
    end
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
    params.require(:pladmin).permit(:date, :order_num, :sku, :goods_name, :sale_amount, :commission, :cgs_amount, :money_receive, :sale_place, :shipping_cost)
  end
  
  def set_pladmin
    @update_pladmin = Pladmin.find(params[:id])
  end
  
  
end

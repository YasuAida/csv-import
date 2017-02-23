class RakutenCostsController < ApplicationController
  include RakutenCostsHelper
  before_action :set_rakuten_cost, only: [ :update]
  before_action :logged_in_user
  
  def index
    @all_rakuten_costs = current_user.rakuten_costs.all
    @q = current_user.rakuten_costs.search(params[:q])
    @rakuten_costs = @q.result(distinct: true).page(params[:page]).per(150)
    @rakuten_cost = current_user.rakuten_costs.build  
  end

  def create
    params[:rakuten_cost][:pc_usage_fee] = params[:rakuten_cost][:pc_usage_fee].gsub(",","") if params[:rakuten_cost][:pc_usage_fee].present?
    params[:rakuten_cost][:mobile_usage_fee] = params[:rakuten_cost][:mobile_usage_fee].gsub(",","") if params[:rakuten_cost][:mobile_usage_fee].present?
    params[:rakuten_cost][:pc_vest_point] = params[:rakuten_cost][:pc_vest_point].gsub(",","") if params[:rakuten_cost][:pc_vest_point].present?
    params[:rakuten_cost][:mobile_vest_point] = params[:rakuten_cost][:mobile_vest_point].gsub(",","") if params[:rakuten_cost][:mobile_vest_point].present?
    params[:rakuten_cost][:affiliate_reward] = params[:rakuten_cost][:affiliate_reward].gsub(",","") if params[:rakuten_cost][:affiliate_reward].present?
    params[:rakuten_cost][:affiliate_system_fee] = params[:rakuten_cost][:affiliate_system_fee].gsub(",","") if params[:rakuten_cost][:affiliate_system_fee].present?    
    params[:rakuten_cost][:r_card_plus] = params[:rakuten_cost][:r_card_plus].gsub(",","") if params[:rakuten_cost][:r_card_plus].present?    
    params[:rakuten_cost][:system_improvement_fee] = params[:rakuten_cost][:system_improvement_fee].gsub(",","") if params[:rakuten_cost][:system_improvement_fee].present?
    params[:rakuten_cost][:open_shop_fee] = params[:rakuten_cost][:open_shop_fee].gsub(",","") if params[:rakuten_cost][:open_shop_fee].present?
    current_user.rakuten_costs.create(rakuten_cost_params)

    redirect_to rakuten_costs_path, notice: 'データを保存しました'
  end

  def update
    params[:rakuten_cost][:pc_usage_fee] = params[:rakuten_cost][:pc_usage_fee].gsub(",","") if params[:rakuten_cost][:pc_usage_fee].present?
    params[:rakuten_cost][:mobile_usage_fee] = params[:rakuten_cost][:mobile_usage_fee].gsub(",","") if params[:rakuten_cost][:mobile_usage_fee].present?
    params[:rakuten_cost][:pc_vest_point] = params[:rakuten_cost][:pc_vest_point].gsub(",","") if params[:rakuten_cost][:pc_vest_point].present?
    params[:rakuten_cost][:mobile_vest_point] = params[:rakuten_cost][:mobile_vest_point].gsub(",","") if params[:rakuten_cost][:mobile_vest_point].present?
    params[:rakuten_cost][:affiliate_reward] = params[:rakuten_cost][:affiliate_reward].gsub(",","") if params[:rakuten_cost][:affiliate_reward].present? 
    params[:rakuten_cost][:affiliate_system_fee] = params[:rakuten_cost][:affiliate_system_fee].gsub(",","") if params[:rakuten_cost][:affiliate_system_fee].present?
    params[:rakuten_cost][:r_card_plus] = params[:rakuten_cost][:r_card_plus].gsub(",","") if params[:rakuten_cost][:r_card_plus].present? 
    params[:rakuten_cost][:system_improvement_fee] = params[:rakuten_cost][:system_improvement_fee].gsub(",","") if params[:rakuten_cost][:system_improvement_fee].present?
    params[:rakuten_cost][:open_shop_fee] = params[:rakuten_cost][:open_shop_fee].gsub(",","") if params[:rakuten_cost][:open_shop_fee].present?
    
    if @update_rakuten_cost.update(rakuten_cost_params)
      redirect_to rakuten_costs_path, notice: "データを編集しました"
    else
      redirect_to rakuten_costs_path, notice: "データの編集に失敗しました"
    end
  end
  
  def destroy
    current_user.rakuten_costs.where(destroy_check: true).destroy_all
    redirect_to rakuten_costs_path, notice: 'データを削除しました'
  end

  def pc_upload
    data = params[:pc_upload]
    #ファイルの登録
    data[:datafile].each do |datafile|
      file_open(datafile)
      #ファイルのインポート
      file_import_pc_list(datafile)
      #ファイルの削除
      file_close(datafile)
    end

    redirect_to rakuten_costs_path
  end

  def mobile_upload
    data = params[:mobile_upload]
    #ファイルの登録
    data[:datafile].each do |datafile|
      file_open(datafile)
      #ファイルのインポート
      file_import_mobile_list(datafile)
      #ファイルの削除
      file_close(datafile)
    end

    redirect_to rakuten_costs_path
  end


  private
  def rakuten_cost_params
    params.require(:rakuten_cost).permit(:user_id, :billing_date, :pc_usage_fee, :mobile_usage_fee, :pc_vest_point, :mobile_vest_point, :affiliate_reward, :affiliate_system_fee, :r_card_plus, :system_improvement_fee, :open_shop_fee, :payment_date, :sales_bracket, :pc_rate, :mobile_rate, :destroy_check)
  end
  
  def set_rakuten_cost
    @update_rakuten_cost = current_user.rakuten_costs.find(params[:id])
  end  
end

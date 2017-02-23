class RakutenSettingsController < ApplicationController
  before_action :set_rakuten_setting, only: [ :update]
  before_action :logged_in_user
  
  def index
    @all_rakuten_settings = current_user.rakuten_settings.all
    @q = current_user.rakuten_settings.search(params[:q])
    @rakuten_settings = @q.result(distinct: true)
    @rakuten_setting = current_user.rakuten_settings.build  
  end

  def create
    params[:rakuten_setting][:end_sales] = params[:rakuten_setting][:end_sales].gsub(",","") if params[:rakuten_setting][:end_sales].present?    
    target_settings = current_user.rakuten_settings.where(start_date: params[:rakuten_setting][:start_date])
    if target_settings.blank?
      params[:rakuten_setting][:start_sales] = 1
    else
      params[:rakuten_setting][:start_sales] = target_settings.order(:end_sales).last.end_sales + 1
      if target_settings.order(:end_sales).last.pc_addition.present?
        params[:rakuten_setting][:pc_addition] = target_settings.order(:end_sales).last.end_sales * (target_settings.order(:end_sales).last.pc_rate.to_f - params[:rakuten_setting][:pc_rate].to_f) / 100 + target_settings.order(:end_sales).last.pc_addition
      else
        params[:rakuten_setting][:pc_addition] = target_settings.order(:end_sales).last.end_sales * (target_settings.order(:end_sales).last.pc_rate.to_f - params[:rakuten_setting][:pc_rate].to_f) / 100
      end
      if target_settings.order(:end_sales).last.mobile_addition.present?
        params[:rakuten_setting][:mobile_addition] = target_settings.order(:end_sales).last.end_sales * (target_settings.order(:end_sales).last.mobile_rate.to_f - params[:rakuten_setting][:mobile_rate].to_f) / 100 + target_settings.order(:end_sales).last.mobile_addition
      else
        params[:rakuten_setting][:mobile_addition] = target_settings.order(:end_sales).last.end_sales * (target_settings.order(:end_sales).last.mobile_rate.to_f - params[:rakuten_setting][:mobile_rate].to_f) / 100
      end
    end    
    current_user.rakuten_settings.create(rakuten_setting_params)

    redirect_to rakuten_settings_path, notice: 'データを保存しました'
  end

  def update
    params[:rakuten_setting][:end_sales] = params[:rakuten_setting][:end_sales].gsub(",","") if params[:rakuten_setting][:end_sales].present?
    
    if @update_rakuten_setting.update(rakuten_setting_params)
      target_settings = current_user.rakuten_settings.where(start_date: params[:rakuten_setting][:start_date])      
      sales = target_settings.pluck(:end_sales)
      pc_rates = target_settings.pluck(:pc_rate)
      mobile_rates = target_settings.pluck(:mobile_rate)
      array_sales = sales.sort
      array_pc_rates = pc_rates.reverse
      array_mobile_rates = mobile_rates.reverse
      target_settings.order(:end_sales).each.with_index(2) do |target_setting, index|
        if index == 2
          target_setting.update(start_sales: 1)
        elsif index == 3
          target_setting.start_sales = array_sales[index - 3] + 1
          target_setting.pc_addition = array_sales[index - 3] * (array_pc_rates[index - 3] - array_pc_rates[index - 4]) / 100
          target_setting.pc_addition = array_sales[index - 3] * (array_mobile_rates[index - 3] - array_mobile_rates[index - 4]) / 100
          target_setting.save
        else
          target_setting.start_sales = array_sales[index - 3] + 1 
          target_setting.pc_addition = array_sales[index - 3] * (array_pc_rates[index - 3] - array_pc_rates[index - 4]) / 100 + target_settings.order(:end_sales).last.pc_addition
          target_setting.pc_addition = array_sales[index - 3] * (array_mobile_rates[index - 3] - array_mobile_rates[index - 4]) / 100 + target_settings.order(:end_sales).last.mobile_addition
          target_setting.save          
        end
      end

      redirect_to rakuten_settings_path, notice: "データを編集しました"
    else
      redirect_to rakuten_settings_path, notice: "データの編集に失敗しました"
    end
  end
  
  def destroy
    current_user.rakuten_settings.where(destroy_check: true).destroy_all
    redirect_to rakuten_settings_path, notice: 'データを削除しました'
  end

  private
  def rakuten_setting_params
    params.require(:rakuten_setting).permit(:user_id, :start_date, :end_date, :start_sales, :end_sales, :pc_rate, :mobile_rate, :pc_addition, :mobile_addition, :destroy_check)
  end
  
  def set_rakuten_setting
    @update_rakuten_setting = current_user.rakuten_settings.find(params[:id])
  end  
end

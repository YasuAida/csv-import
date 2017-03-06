class RakutensController < ApplicationController
  include RakutensHelper
  before_action :set_rakuten, only: [:edit, :edit_nyukin, :update, :copy]
  before_action :logged_in_user
  
  def index
    @all_rakutens = current_user.rakutens.all
    @q = current_user.rakutens.search(params[:q])
    @rakutens = @q.result(distinct: true).page(params[:page]).per(150)
    @rakuten = current_user.rakutens.build
    
    respond_to do |format|
      format.html
      format.csv { send_data @all_rakutens.to_download, type: 'text/csv; charset=shift_jis', filename: "rakutens.csv" }
    end
  end

  def nyukin
    @q = current_user.rakutens.search(params[:q])
    @rakutens = @q.result(distinct: true).page(params[:page]).per(150)    
  end
 
  def new
    @q = current_user.rakutens.search(params[:q])
    @rakutens = @q.result(distinct: true).page(params[:page]).per(150)
    @rakuten = current_user.rakutens.build   
  end

  def create
    params[:rakuten][:unit_price] = params[:rakuten][:unit_price].gsub(",","") if params[:rakuten][:unit_price].present?
    params[:rakuten][:shipping_cost] = params[:rakuten][:shipping_cost].gsub(",","") if params[:rakuten][:shipping_cost].present?
    params[:rakuten][:consumption_tax] = params[:rakuten][:consumption_tax].gsub(",","") if params[:rakuten][:consumption_tax].present?
    params[:rakuten][:cod_fee] = params[:rakuten][:cod_fee].gsub(",","") if params[:rakuten][:cod_fee].present?
    params[:rakuten][:shop_coupon] = params[:rakuten][:shop_coupon].gsub(",","") if params[:rakuten][:shop_coupon].present?
    params[:rakuten][:commission] = params[:rakuten][:commission].gsub(",","") if params[:rakuten][:commission].present?
    params[:rakuten][:vest_point] = params[:rakuten][:vest_point].gsub(",","") if params[:rakuten][:vest_point].present?
    params[:rakuten][:system_improvement] = params[:rakuten][:system_improvement].gsub(",","") if params[:rakuten][:system_improvement].present?
    params[:rakuten][:credit_commission] = params[:rakuten][:credit_commission].gsub(",","") if params[:rakuten][:credit_commission].present?
    params[:rakuten][:use_point] = params[:rakuten][:use_point].gsub(",","") if params[:rakuten][:use_point].present?
    params[:rakuten][:use_coupon] = params[:rakuten][:use_coupon].gsub(",","") if params[:rakuten][:use_coupon].present?
    params[:rakuten][:receipt_amount] = params[:rakuten][:receipt_amount].gsub(",","") if params[:rakuten][:receipt_amount].present?
   
    if params[:rakuten][:kind_of_card].present? && params[:rakuten][:kind_of_card] == '楽天カード'

      receipt_amount = params[:rakuten][:total_sales].to_i - @update_rakuten.use_point.to_i - @update_rakuten.use_coupon.to_i
      credit_commission = receipt_amount * 0.0265
      params[:rakuten][:credit_commission] = BigDecimal(credit_commission.to_s).round(0)
    end
    if params[:rakuten][:kind_of_card].present? && params[:rakuten][:kind_of_card] == '一般カード'
      receipt_amount = params[:rakuten][:total_sales].to_i - @update_rakuten.use_point.to_i - @update_rakuten.use_coupon.to_i
      credit_commission = receipt_amount * 0.0360
      params[:rakuten][:credit_commission] = BigDecimal(credit_commission.to_s).round(0)
    end
    
    params[:rakuten][:total_sales] = params[:rakuten][:unit_price].to_i * params[:rakuten][:number].to_i + params[:rakuten][:shipping_cost].to_i + params[:rakuten][:consumption_tax].to_i + params[:rakuten][:cod_fee].to_i + params[:rakuten][:shop_coupon].to_i
    params[:rakuten][:total_commissions] = params[:rakuten][:commission].to_i * params[:rakuten][:vest_point].to_i + params[:rakuten][:system_improvement].to_i + params[:rakuten][:credit_commission].to_i
    
    @rakuten = current_user.rakutens.build(rakuten_params)
    if @rakuten.save
      redirect_to new_stock_path
    else
      redirect_to new_stock_path
    end
  end
  
  def edit
    @q = current_user.rakutens.search(params[:q])
    @rakutens = @q.result(distinct: true).page(params[:page]).per(150)     
    @rakuten = @update_rakuten
  end

  def edit_nyukin
    @q = current_user.rakutens.search(params[:q])
    @rakutens = @q.result(distinct: true).page(params[:page]).per(150)     
    @rakuten = @update_rakuten
  end

  def update
    params[:rakuten][:unit_price] = params[:rakuten][:unit_price].gsub(",","") if params[:rakuten][:unit_price].present?
    params[:rakuten][:shipping_cost] = params[:rakuten][:shipping_cost].gsub(",","") if params[:rakuten][:shipping_cost].present?
    params[:rakuten][:consumption_tax] = params[:rakuten][:consumption_tax].gsub(",","") if params[:rakuten][:consumption_tax].present?
    params[:rakuten][:cod_fee] = params[:rakuten][:cod_fee].gsub(",","") if params[:rakuten][:cod_fee].present?
    params[:rakuten][:shop_coupon] = params[:rakuten][:shop_coupon].gsub(",","") if params[:rakuten][:shop_coupon].present?
    params[:rakuten][:commission] = params[:rakuten][:commission].gsub(",","") if params[:rakuten][:commission].present?
    params[:rakuten][:vest_point] = params[:rakuten][:vest_point].gsub(",","") if params[:rakuten][:vest_point].present?
    params[:rakuten][:system_improvement] = params[:rakuten][:system_improvement].gsub(",","") if params[:rakuten][:system_improvement].present?
    params[:rakuten][:credit_commission] = params[:rakuten][:credit_commission].gsub(",","") if params[:rakuten][:credit_commission].present?
    params[:rakuten][:data_processing] = params[:rakuten][:data_processing].gsub(",","") if params[:rakuten][:data_processing].present?
    params[:rakuten][:use_point] = params[:rakuten][:use_point].gsub(",","") if params[:rakuten][:use_point].present?
    params[:rakuten][:use_coupon] = params[:rakuten][:use_coupon].gsub(",","") if params[:rakuten][:use_coupon].present?
    params[:rakuten][:receipt_amount] = params[:rakuten][:receipt_amount].gsub(",","") if params[:rakuten][:receipt_amount].present?
   
    if params[:rakuten][:kind_of_card].present? && params[:rakuten][:kind_of_card] == '楽天カード'

      receipt_amount = params[:rakuten][:total_sales].to_i - @update_rakuten.use_point.to_i - @update_rakuten.use_coupon.to_i
      credit_commission = receipt_amount * 0.0265
      params[:rakuten][:credit_commission] = BigDecimal(credit_commission.to_s).round(0)
    end
    if params[:rakuten][:kind_of_card].present? && params[:rakuten][:kind_of_card] == '一般カード'
      receipt_amount = params[:rakuten][:total_sales].to_i - @update_rakuten.use_point.to_i - @update_rakuten.use_coupon.to_i
      credit_commission = receipt_amount * 0.0360
      params[:rakuten][:credit_commission] = BigDecimal(credit_commission.to_s).round(0)
    end
    
    params[:rakuten][:total_sales] = params[:rakuten][:unit_price].to_i * params[:rakuten][:number].to_i + params[:rakuten][:shipping_cost].to_i + params[:rakuten][:consumption_tax].to_i + params[:rakuten][:cod_fee].to_i + params[:rakuten][:shop_coupon].to_i
    params[:rakuten][:total_commissions] = params[:rakuten][:commission].to_i * params[:rakuten][:vest_point].to_i + params[:rakuten][:system_improvement].to_i + params[:rakuten][:credit_commission].to_i
    
    if @update_rakuten.update(rakuten_params)
      redirect_to rakutens_path, notice: "データを編集しました"
    else
      redirect_to rakutens_path, notice: "データの編集に失敗しました"
    end
  end
  
  def copy
    @copy_rakuten = @update_rakuten.dup
    @copy_rakutens = current_user.rakutens.where(order_num: @copy_rakuten.order_num, sale_date: @copy_rakuten.sale_date, goods_name: @copy_rakuten.goods_name, unit_price: @copy_rakuten.unit_price, money_receipt_date: @copy_rakuten.money_receipt_date)
    @copy_rakuten.sku = @copy_rakuten.sku + "(" + @copy_rakutens.count.to_s + ")"
    if @copy_rakuten.save
      @copy_rakutens = current_user.rakutens.where(order_num: @copy_rakuten.order_num, sale_date: @copy_rakuten.sale_date, goods_name: @copy_rakuten.goods_name, unit_price: @copy_rakuten.unit_price, money_receipt_date: @copy_rakuten.money_receipt_date)
    else
      redirect_to :back 
    end  
  end
  
  def blank_form
    render "index"
  end

  def upload
    @q = current_user.rakutens.search(params[:q])
    @rakutens = @q.result(distinct: true).page(params[:page]).per(150)  
  end

  def past_data_upload 
    data = params[:past_data_upload]
    #ファイルの登録
    file_open(data[:datafile])
    #ファイルのインポート
    file_import_past_data_rakuten(data[:datafile])
    #ファイルの削除
    file_close(data[:datafile])

    redirect_to rakutens_path
  end
  
  def past_point_upload 
    data = params[:past_point_upload]
    #ファイルの登録
    file_open(data[:datafile])
    #ファイルのインポート
    file_import_past_point_rakuten(data[:datafile])
    #ファイルの削除
    file_close(data[:datafile])
    #同一注文における店舗クーポンの分解
    dividing_shop_coupon_amount
    #同一注文におけるポイントによる支払額の分解
    dividing_use_point_amount    
    #同一注文における楽天クーポンによる支払額の分解
    dividing_use_coupon_amount

    redirect_to rakutens_path
  end  
  
  def csv_upload
    data = params[:csv_upload]
    #ファイルの登録
    file_open(data[:datafile])
    #ファイルのインポート
    file_import_rakuten_csv(data[:datafile])
    #ファイルの削除
    file_close(data[:datafile])
    #同一注文における店舗クーポンの分解
    dividing_shop_coupon_amount
    #同一注文におけるポイントによる支払額の分解
    dividing_use_point_amount    
    #同一注文における楽天クーポンによる支払額の分解
    dividing_use_coupon_amount
    
    redirect_to rakutens_path
  end
  
  def point_upload
    data = params[:point_upload]
    #ファイルの登録
    data[:datafile].each do |datafile|
      file_open(datafile)
      #ファイルのインポート
      file_import_invest_list(datafile)
      #ファイルの削除
      file_close(datafile)
    end

    redirect_to rakutens_path
  end
  
  def credit_upload
    data = params[:credit_upload]
    #ファイルの登録
    data[:datafile].each do |datafile|
      file_open(datafile)
      #ファイルのインポート
      file_import_credit_data(datafile)
      #ファイルの削除
      file_close(datafile)
    end

    redirect_to rakutens_path
  end
  
  def bank_upload
    data = params[:bank_upload]
    #ファイルの登録
    data[:datafile].each do |datafile|
      file_open(datafile)
      #ファイルのインポート
      file_import_bank_data(datafile)
      #ファイルの削除
      file_close(datafile)
    end

    redirect_to rakutens_path
  end
  
  def multi_upload
    data = params[:multi_upload]
    #ファイルの登録
    data[:datafile].each do |datafile|
      file_open(datafile)
      #ファイルのインポート
      file_import_multi_data(datafile)
      #ファイルの削除
      file_close(datafile)
    end

    redirect_to rakutens_path
  end
  
  def rakuten_upload
    data = params[:rakuten_upload]
    #ファイルの登録
    data[:datafile].each do |datafile|
      file_open(datafile)
      #ファイルのインポート
      file_import_rakuten_bank_data(datafile)
      #ファイルの削除
      file_close(datafile)
    end

    redirect_to rakutens_path
  end
  
  def commission
    @pc_rakutens = current_user.rakutens.where(pc_mobile: "PC")
    @pc_rakutens.group(:billing_date).each do |pc_rakuten|
      total_pc_sales = @pc_rakutens.where(billing_date: pc_rakuten.billing_date).sum(:total_sales)
      
      start_date_settings = current_user.rakuten_settings.where("start_date <= ?", pc_rakuten.billing_date)
      end_date_settings = start_date_settings.where("end_date <= ?", pc_rakuten.billing_date) if start_date_settings.present?
      if end_date_settings.present?
        start_sales_settings = end_date_settings.where("start_sales <= ?", total_pc_sales)
        end_sales_setting = start_sales_settings.find_by("end_sales >= ?", total_pc_sales)
        if end_sales_setting.blank?
          end_sales_setting = start_sales_setting.find_by(end_sales: nil)
        end
      else
        end_date_settings = start_date_settings.where(end_date: nil)
        start_sales_settings = end_date_settings.where("start_sales <= ?", total_pc_sales)
        end_sales_setting = start_sales_settings.find_by("end_sales >= ?", total_pc_sales)
        if end_sales_setting.blank?
          end_sales_setting = start_sales_settings.find_by(end_sales: nil)
        end 
      end
    
      ex_pc_commission = total_pc_sales * end_sales_setting.pc_rate / 100 * 1.08 + end_sales_setting.pc_addition.to_i * 1.08
      total_pc_commission = BigDecimal(ex_pc_commission.to_s).round(0)
      
      @billing_pc_rakutens = current_user.rakutens.where(pc_mobile: "PC", billing_date: pc_rakuten.billing_date)
      @billing_pc_rakutens.each do |billing_pc_rakuten|
        each_commission = total_pc_commission * billing_pc_rakuten.total_sales / total_pc_sales
        billing_pc_rakuten.commission = BigDecimal(each_commission.to_s).round(0)
        billing_pc_rakuten.save
      end
    end
    
    @mobile_rakutens = current_user.rakutens.where(pc_mobile: "Mobile")
    @mobile_rakutens.group(:billing_date).each do |mobile_rakuten|
      total_mobile_sales = @mobile_rakutens.where(billing_date: mobile_rakuten.billing_date).sum(:total_sales)
      
      start_date_settings = current_user.rakuten_settings.where("start_date <= ?", mobile_rakuten.billing_date)
      end_date_settings = start_date_settings.where("end_date <= ?", mobile_rakuten.billing_date) if start_date_settings.present?
      if end_date_settings.present?
        start_sales_settings = end_date_settings.where("start_sales <= ?", total_mobile_sales)
        end_sales_setting = start_sales_settings.find_by("end_sales >= ?", total_mobile_sales)
        if end_sales_setting.blank?
          end_sales_setting = start_sales_settings.find_by(end_sales: nil)
        end
      else
        end_date_settings = start_date_settings.where(end_date: nil)
        start_sales_settings = end_date_settings.where("start_sales <= ?", total_mobile_sales)
        end_sales_setting = start_sales_settings.find_by("end_sales >= ?", total_mobile_sales)
        if end_sales_setting.blank?
          end_sales_setting = start_sales_settings.find_by(end_sales: nil)
        end 
      end
    
      ex_mobile_commission = total_mobile_sales * end_sales_setting.mobile_rate / 100 * 1.08 + end_sales_setting.mobile_addition.to_i * 1.08
      total_mobile_commission = BigDecimal(ex_mobile_commission.to_s).round(0)
     
      @billing_mobile_rakutens = current_user.rakutens.where(pc_mobile: "Mobile", billing_date: mobile_rakuten.billing_date)
      @billing_mobile_rakutens.each do |billing_mobile_rakuten|
        each_commission = total_mobile_commission * billing_mobile_rakuten.total_sales / total_mobile_sales
        billing_mobile_rakuten.commission = BigDecimal(each_commission.to_s).round(0)
        billing_mobile_rakuten.save
      end
    end
    
    @all_rakutens = current_user.rakutens.all
    @all_rakutens.group(:billing_date).each do |billing_rakuten|
      total_billing_sales = @all_rakutens.where(billing_date: billing_rakuten.billing_date).sum(:total_sales)
      ex_system_improvement = total_billing_sales / 1000 * 1.08
      total_system_improvement = BigDecimal(ex_system_improvement.to_s).round(0)      
      @all_rakutens.where(billing_date: billing_rakuten.billing_date).each do |each_billing|
        if each_billing.total_sales.present?
          each_system_improvement = total_system_improvement * each_billing.total_sales / total_billing_sales
          each_billing.system_improvement = BigDecimal(each_system_improvement).round(0)
          each_billing.save
        end
      end
    end

    @all_rakutens = current_user.rakutens.all
    @all_rakutens.each do |rakuten|
      total_commissions = rakuten.commission.to_i + rakuten.vest_point.to_i + rakuten.system_improvement.to_i + rakuten.credit_commission.to_i
      rakuten.update(total_commissions: total_commissions)
    end    
    
  redirect_to rakutens_path    
  end
  
  def destroy
    current_user.rakutens.where(destroy_check: true).destroy_all
    redirect_to rakutens_path, notice: 'データを削除しました'
  end

  private
  def rakuten_params
    params.require(:rakuten).permit(:user_id, :order_num, :sale_date, :kind_of_card, :sku, :goods_name, :pc_mobile, :unit_price, :number, :shipping_cost, :consumption_tax, :cod_fee, :shop_coupon, :commission, :vest_point, :system_improvement, :credit_commission, :data_processing, :settlement, :use_point, :use_coupon, :receipt_date, :total_sales, :total_commissions, :closing_date, :option, :order_date, :receipt_amount, :point_receipt_date, :destroy_check)
  end
  
  def set_rakuten
    @update_rakuten = current_user.rakutens.find(params[:id])
  end  
end

module TopPagesHelper
  def file_open(file_name)
      File.open('./tmp/top_page/'+ file_name.original_filename, 'wb') do |file|
        file.write(file_name.read)
      end
  end
  
  def file_close(file_name)
      File.delete('./tmp/top_page/' + file_name.original_filename)
  end
  
  def accounts_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:account, :debit_credit, :bs_pl, :display_position]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h     

        current_user.accounts.create(row_hash)
      end
  end

  def allocationcosts_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:stock_id, :title, :allocation_amount]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:stock_id] = row_hash[:stock_id].to_i if row_hash[:stock_id].present?
        row_hash[:allocation_amount] = row_hash[:allocation_amount].to_i if row_hash[:allocation_amount].present?
        
        current_user.allocationcosts.create(row_hash)
      end
  end

  def currencies_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:name, :method]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        
        current_user.currencies.create(row_hash)
      end
  end

  def disposals_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:sale_id, :stock_id, :date, :order_num, :sku, :number]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:sale_id] = row_hash[:sale_id].to_i if row_hash[:sale_id].present?           
        row_hash[:stock_id] = row_hash[:stock_id].to_i if row_hash[:stock_id].present?        
        row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present?
        row_hash[:number] = row_hash[:number].to_i if row_hash[:number].present?
        
        current_user.disposals.create(row_hash)
      end
  end

  def dummy_stocks_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:stock_id, :sale_date, :cancel_date, :number]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換     
        row_hash[:stock_id] = row_hash[:stock_id].to_i if row_hash[:stock_id].present?        
        row_hash[:sale_date] = Date.parse(row_hash[:sale_date]).to_date if row_hash[:sale_date].present?
        row_hash[:cancel_date] = Date.parse(row_hash[:cancel_date]).to_date if row_hash[:cancel_date].present?        
        row_hash[:number] = row_hash[:number].to_i if row_hash[:number].present?
        
        current_user.dummy_stocks.create(row_hash)
      end
  end

  
  def entrypatterns_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:sku, :kind_of_transaction, :kind_of_payment, :detail_of_payment, :handling]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        
        current_user.entrypatterns.create(row_hash)
      end
  end

  def exchanges_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:date, :country, :rate]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present? 
        row_hash[:rate] = row_hash[:rate].to_f if row_hash[:rate].present? 
        
        current_user.exchanges.create(row_hash)
      end
  end

  def expense_methods_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:method]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        
        current_user.expense_methods.create(row_hash)
      end
  end
  
  def expense_relations_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:stock_id, :subexpense_id]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h       
        
        current_user.expense_relations.create(row_hash)
      end
  end

  def expense_titles_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:item, :method]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
      
        current_user.expense_titles.create(row_hash)
      end
  end
  
  def expenseledgers_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:sale_id, :date, :account_name, :content, :amount, :rate, :money_paid, :purchase_from, :currency, :grandtotal]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:sale_id] = row_hash[:sale_id].to_i if row_hash[:sale_id].present?        
        row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present? 
        row_hash[:amount] = row_hash[:amount].to_f if row_hash[:amount].present? 
        row_hash[:rate] = row_hash[:rate].to_f if row_hash[:rate].present? 
        row_hash[:money_paid] = Date.parse(row_hash[:money_paid]).to_date if row_hash[:money_paid].present? 
        row_hash[:grandtotal] = row_hash[:grandtotal].to_i if row_hash[:grandtotal].present?      
        
        current_user.expenseledgers.create(row_hash)
      end
  end
  
  def financial_statements_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:period_start, :monthly_yearly, :account, :amount]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:period_start] = Date.parse(row_hash[:period_start]).to_date if row_hash[:period_start].present? 
        row_hash[:amount] = row_hash[:amount].to_i if row_hash[:amount].present?
        
        current_user.financial_statements.create(row_hash)
      end
  end
  
  def generalledgers_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:pladmin_id, :stock_id, :stockreturn_id, :return_good_id, :disposal_id, :expenseledger_id, :voucher_id, :subexpense_id, :expense_relation_id, :date, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode, :amount, :content, :trade_company]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:pladmin_id] = row_hash[:pladmin_id].to_i if row_hash[:pladmin_id].present?
        row_hash[:stock_id] = row_hash[:stock_id].to_i if row_hash[:stock_id].present?
        row_hash[:stockreturn_id] = row_hash[:stockreturn_id].to_i if row_hash[:stockreturn_id].present?
        row_hash[:return_good_id] = row_hash[:return_good_id].to_i if row_hash[:return_good_id].present?
        row_hash[:disposal_id] = row_hash[:disposal_id].to_i if row_hash[:disposal_id].present?
        row_hash[:expenseledger_id] = row_hash[:expenseledger_id].to_i if row_hash[:expenseledger_id].present?
        row_hash[:voucher_id] = row_hash[:voucher_id].to_i if row_hash[:voucher_id].present?
        row_hash[:subexpense_id] = row_hash[:subexpense_id].to_i if row_hash[:subexpense_id].present?
        row_hash[:expense_relation_id] = row_hash[:expense_relation_id].to_i if row_hash[:expense_relation_id].present?
        row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present?
        row_hash[:amount] = row_hash[:amount].to_i
       
        current_user.generalledgers.create(row_hash)
      end
  end

  def journalpatterns_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:taxcode, :ledger, :pattern, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        
        current_user.journalpatterns.create(row_hash)
      end
  end

  def listingreports_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:sku, :asin, :price, :quantity]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:price] = row_hash[:price].to_i if row_hash[:price].present?
        row_hash[:quantity] = row_hash[:quantity].to_i if row_hash[:quantity].present?
        
        current_user.listingreports.create(row_hash)
      end
  end

  def multi_channels_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:sale_id, :date, :order_num, :sku, :number]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:sale_id] = row_hash[:sale_id].to_i if row_hash[:sale_id].present?  
        row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present? 
        row_hash[:number] = row_hash[:number].to_i if row_hash[:number].present?
        
        current_user.multi_channels.create(row_hash)
      end
  end

  def periods_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:period_start, :period_end, :monthly_yearly]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:period_start] = Date.parse(row_hash[:period_start]).to_date if row_hash[:period_start].present? 
        row_hash[:period_end] = Date.parse(row_hash[:period_end]).to_date if row_hash[:period_end].present?         
        
        current_user.periods.create(row_hash)
      end
  end
  
  def pladmins_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:sale_id, :stock_id, :date, :order_num, :sku, :goods_name, :quantity, :sale_place, :sale_amount, :commission, :cgs_amount, :shipping_cost, :money_receive, :commission_pay_date, :shipping_pay_date]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:sale_id] = row_hash[:sale_id].to_i if row_hash[:sale_id].present? 
        row_hash[:stock_id] = row_hash[:stock_id].to_i if row_hash[:stock_id].present?        
        row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present?
        row_hash[:quantity] = row_hash[:quantity].to_i if row_hash[:quantity].present?        
        row_hash[:sale_amount] = row_hash[:sale_amount].to_i if row_hash[:sale_amount].present? 
        row_hash[:commission] = row_hash[:commission].to_i if row_hash[:commission].present?
        row_hash[:cgs_amount] = row_hash[:cgs_amount].to_i if row_hash[:cgs_amount].present? 
        row_hash[:shipping_cost] = row_hash[:shipping_cost].to_i if row_hash[:shipping_cost].present?        
        row_hash[:money_receive] = Date.parse(row_hash[:money_receive]).to_date if row_hash[:money_receive].present?
        row_hash[:commission_pay_date] = Date.parse(row_hash[:commission_pay_date]).to_date if row_hash[:commission_pay_date].present?
        row_hash[:shipping_pay_date] = Date.parse(row_hash[:shipping_pay_date]).to_date if row_hash[:commission_pay_date].present?
        
        current_user.pladmins.create(row_hash)
      end
  end

  def point_coupons_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:order_num, :shop_coupon, :use_point, :use_coupon]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:shop_coupon] = row_hash[:shop_coupon].to_i if row_hash[:shop_coupon].present?
        row_hash[:use_point] = row_hash[:use_point].to_i if row_hash[:use_point].present?      
        row_hash[:use_coupon] = row_hash[:use_coupon].to_i if row_hash[:use_coupon].present?
        
        current_user.point_coupons.create(row_hash)
      end
  end

  def rakuten_costs_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:billing_date, :pc_usage_fee, :mobile_usage_fee, :pc_vest_point, :mobile_vest_point, :affiliate_reward, :affiliate_system_fee, :r_card_plus, :system_improvement_fee, :open_shop_fee, :payment_date]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:billing_date] = Date.parse(row_hash[:billing_date]).to_date if row_hash[:billing_date].present?
        row_hash[:pc_usage_fee] = row_hash[:pc_usage_fee].to_i if row_hash[:pc_usage_fee].present?
        row_hash[:mobile_usage_fee] = row_hash[:mobile_usage_fee].to_i if row_hash[:mobile_usage_fee].present?      
        row_hash[:pc_vest_point] = row_hash[:pc_vest_point].to_i if row_hash[:pc_vest_point].present?
        row_hash[:mobile_vest_point] = row_hash[:mobile_vest_point].to_i if row_hash[:mobile_vest_point].present?
        row_hash[:affiliate_reward] = row_hash[:affiliate_reward].to_i if row_hash[:affiliate_reward].present?
        row_hash[:affiliate_system_fee] = row_hash[:affiliate_system_fee].to_i if row_hash[:affiliate_system_fee].present?
        row_hash[:r_card_plus] = row_hash[:r_card_plus].to_i if row_hash[:r_card_plus].present?
        row_hash[:system_improvement_fee] = row_hash[:system_improvement_fee].to_i if row_hash[:system_improvement_fee].present?
        row_hash[:open_shop_fee] = row_hash[:open_shop_fee].to_i if row_hash[:open_shop_fee].present?
        row_hash[:payment_date] = Date.parse(row_hash[:payment_date]).to_date if row_hash[:payment_date].present?
        
        current_user.rakuten_costs.create(row_hash)
      end
  end
  
  def rakuten_settings_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:start_date, :end_date, :start_sales, :end_sales, :pc_rate, :mobile_rate, :pc_addition, :mobile_addition]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:start_date] = Date.parse(row_hash[:start_date]).to_date if row_hash[:start_date].present?
        row_hash[:end_date] = Date.parse(row_hash[:end_date]).to_date if row_hash[:end_date].present?
        row_hash[:start_sales] = row_hash[:start_sales].to_i if row_hash[:start_sales].present?
        row_hash[:end_sales] = row_hash[:end_sales].to_i if row_hash[:end_sales].present?      
        row_hash[:pc_rate] = row_hash[:pc_rate].to_f if row_hash[:pc_rate].present? 
        row_hash[:mobile_rate] = row_hash[:mobile_rate].to_f if row_hash[:mobile_rate].present?
        row_hash[:pc_addition] = row_hash[:pc_addition].to_i if row_hash[:pc_addition].present?
        row_hash[:mobile_addition] = row_hash[:mobile_addition].to_i if row_hash[:mobile_addition].present?

        current_user.rakuten_settings.create(row_hash)
      end
  end

  def rakutens_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:order_num, :order_date, :sale_date, :sku, :goods_name, :option, :kind_of_card, :pc_mobile, :unit_price, :number, :shipping_cost, :consumption_tax, :cod_fee, :shop_coupon, :total_sales, :commission, :vest_point, :system_improvement, :credit_commission, :data_processing, :total_commissions, :settlement, :receipt_amount, :use_point, :use_coupon, :closing_date, :money_receipt_date, :point_receipt_date, :billing_date, :minyukin]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:order_date] = Date.parse(row_hash[:order_date]).to_date if row_hash[:order_date].present?
        row_hash[:sale_date] = Date.parse(row_hash[:sale_date]).to_date if row_hash[:sale_date].present?
        row_hash[:pc_mobile] = row_hash[:pc_mobile].to_i if row_hash[:pc_mobile].present?
        row_hash[:unit_price] = row_hash[:unit_price].to_i if row_hash[:unit_price].present?      
        row_hash[:number] = row_hash[:number].to_i if row_hash[:number].present? 
        row_hash[:shipping_cost] = row_hash[:shipping_cost].to_i if row_hash[:shipping_cost].present? 
        row_hash[:consumption_tax] = row_hash[:consumption_tax].to_i if row_hash[:consumption_tax].present?
        row_hash[:cod_fee] = row_hash[:cod_fee].to_i if row_hash[:cod_fee].present?
        row_hash[:shop_coupon] = row_hash[:shop_coupon].to_i if row_hash[:shop_coupon].present?
        row_hash[:total_sales] = row_hash[:total_sales].to_i if row_hash[:total_sales].present? 
        row_hash[:commission] = row_hash[:commission].to_i if row_hash[:commission].present?
        row_hash[:vest_point] = row_hash[:vest_point].to_i if row_hash[:vest_point].present?
        row_hash[:system_improvement] = row_hash[:system_improvement].to_i if row_hash[:system_improvement].present?
        row_hash[:credit_commission] = row_hash[:credit_commission].to_i if row_hash[:credit_commission].present?
        row_hash[:data_processing] = row_hash[:data_processing].to_i if row_hash[:data_processing].present?
        row_hash[:total_commissions] = row_hash[:total_commissions].to_i if row_hash[:total_commissions].present?
        row_hash[:receipt_amount] = row_hash[:receipt_amount].to_i if row_hash[:receipt_amount].present?        
        row_hash[:use_point] = row_hash[:use_point].to_i if row_hash[:use_point].present?
        row_hash[:use_coupon] = row_hash[:use_coupon].to_i if row_hash[:use_coupon].present?
        row_hash[:closing_date] = Date.parse(row_hash[:closing_date]).to_date if row_hash[:closing_date].present?        
        row_hash[:money_receipt_date] = Date.parse(row_hash[:money_receipt_date]).to_date if row_hash[:money_receipt_date].present?
        row_hash[:point_receipt_date] = Date.parse(row_hash[:point_receipt_date]).to_date if row_hash[:point_receipt_date].present?
        row_hash[:billing_date] = Date.parse(row_hash[:billing_date]).to_date if row_hash[:billing_date].present?
        row_hash[:minyukin] = row_hash[:minyukin].to_i if row_hash[:minyukin].present?       

        current_user.rakutens.create(row_hash)
      end
  end
  
  def return_goods_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:sale_id, :stock_id, :date, :order_num, :old_sku, :new_sku, :number]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:sale_id] = row_hash[:sale_id].to_i if row_hash[:sale_id].present?
        row_hash[:stock_id] = row_hash[:stock_id].to_i if row_hash[:stock_id].present?  
        row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present?   
        row_hash[:number] = row_hash[:number].to_i

        current_user.return_goods.create(row_hash)
      end
  end

  def sales_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:date, :order_num, :sku, :kind_of_transaction, :kind_of_payment, :detail_of_payment, :amount, :quantity, :goods_name, :money_receive, :handling]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present?
        row_hash[:amount] = row_hash[:amount].to_i if row_hash[:amount].present?
        row_hash[:quantity] = row_hash[:quantity].to_i if row_hash[:quantity].present?     
        row_hash[:money_receive] = Date.parse(row_hash[:money_receive]).to_date if row_hash[:money_receive].present?
        
        current_user.sales.create(row_hash)
      end
  end

  def selfstorages_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:sku]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        
        current_user.selfstorages.create(row_hash)
      end
  end
  
  def stockaccepts_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:date, :fnsku, :sku, :goods_name, :quantity, :fba_number, :fc, :asin]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present?
        row_hash[:quantity] = row_hash[:quantity].to_i if row_hash[:quantity].present?

        current_user.stockaccepts.create(row_hash)
      end
  end

  def stockledgers_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:stock_id, :transaction_date, :sku, :asin, :goods_name, :classification, :number, :unit_price, :grandtotal]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:stock_id] = row_hash[:stock_id].to_i if row_hash[:stock_id].present?
        row_hash[:transaction_date] = Date.parse(row_hash[:transaction_date]).to_date if row_hash[:transaction_date].present?
        row_hash[:number] = row_hash[:number].to_i if row_hash[:number].present?
        row_hash[:unit_price] = row_hash[:unit_price].gsub(/,/, "").to_f if row_hash[:unit_price].present?
        row_hash[:grandtotal] = row_hash[:grandtotal].to_i if row_hash[:grandtotal].present?
   
        current_user.stockledgers.create(row_hash)
      end
  end

  def stockreturns_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:stock_id, :date, :sku, :asin, :goods_name, :number, :unit_price, :rate, :goods_amount, :money_paid, :purchase_from, :currency, :grandtotal]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換       
        row_hash[:stock_id] = row_hash[:stock_id].to_i if row_hash[:stock_id].present?
        row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present?
        row_hash[:number] = row_hash[:number].to_i if row_hash[:number].present?
        row_hash[:unit_price] = row_hash[:unit_price].gsub(/,/, "").to_f if row_hash[:unit_price].present?
        row_hash[:rate] = row_hash[:rate].to_f if row_hash[:rate].present?
        row_hash[:goods_amount] = row_hash[:goods_amount].to_i if row_hash[:goods_amount].present?
        row_hash[:money_paid] = Date.parse(row_hash[:money_paid]).to_date if row_hash[:money_paid].present?
        row_hash[:grandtotal] = row_hash[:grandtotal].to_i if row_hash[:grandtotal].present?       
        
        current_user.stockreturns.create(row_hash)
      end
  end

  def stocks_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:date, :sku, :asin, :goods_name, :unit_price, :number, :rate, :goods_amount, :money_paid, :purchase_from, :currency, :grandtotal]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present?
        row_hash[:unit_price] = row_hash[:unit_price].gsub(/,/, "").to_f if row_hash[:unit_price].present?
        row_hash[:number] = row_hash[:number].to_i if row_hash[:number].present?
        row_hash[:rate] = row_hash[:rate].to_f if row_hash[:rate].present?
        row_hash[:goods_amount] = row_hash[:goods_amount].to_i if row_hash[:goods_amount].present?
        row_hash[:money_paid] = Date.parse(row_hash[:money_paid]).to_date if row_hash[:money_paid].present?
        row_hash[:grandtotal] = row_hash[:grandtotal].to_i if row_hash[:grandtotal].present?     
        
        current_user.stocks.create(row_hash)
      end
  end

  def subexpenses_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:item, :targetgood, :date, :amount, :rate, :purchase_from, :currency, :money_paid]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present?
        row_hash[:amount] = row_hash[:amount].to_f if row_hash[:amount].present?
        row_hash[:rate] = row_hash[:rate].to_f if row_hash[:rate].present?
        row_hash[:money_paid] = Date.parse(row_hash[:money_paid]).to_date if row_hash[:money_paid].present?
        
        current_user.subexpenses.create(row_hash)
      end
  end
  
  def vouchers_import(file_name)
    # 先にDBのカラム名を用意
    @column = [:sale_id, :date, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode, :amount, :content, :trade_company]
    
    CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
      # rowの値のみを配列化
      row_value = row.to_h.values
      # Zipで合体後にハッシュ化
      row_hash = @column.zip(row_value).to_h
      # データー型の変換
      row_hash[:sale_id] = row_hash[:sale_id].to_i if row_hash[:sale_id].present?
      row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present?
      row_hash[:amount] = row_hash[:amount].to_i if row_hash[:amount].present?
   
      current_user.vouchers.create(row_hash)
    end
  end
  
  def yafuokus_import(file_name)
    # 先にDBのカラム名を用意
    @column = [:date, :order_num, :sku, :goods_name, :sale_place, :unit_price, :number, :sales_amount, :cogs_amount, :commission, :shipping_cost, :money_receipt_date, :shipping_pay_date, :commission_pay_date]
    
    CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
      # rowの値のみを配列化
      row_value = row.to_h.values
      # Zipで合体後にハッシュ化
      row_hash = @column.zip(row_value).to_h
      # データー型の変換    
      row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present?
      row_hash[:unit_price] = row_hash[:unit_price].to_i if row_hash[:unit_price].present?      
      row_hash[:number] = row_hash[:number].to_i if row_hash[:number].present?      
      row_hash[:sales_amount] = row_hash[:sales_amount].to_i if row_hash[:sales_amount].present? 
      row_hash[:cogs_amount] = row_hash[:cogs_amount].to_i if row_hash[:cogs_amount].present? 
      row_hash[:commission] = row_hash[:commission].to_i if row_hash[:commission].present? 
      row_hash[:shipping_cost] = row_hash[:shipping_cost].to_i if row_hash[:shipping_cost].present?       
      row_hash[:money_receipt_date] = Date.parse(row_hash[:money_receipt_date]).to_date if row_hash[:money_receipt_date].present?
      row_hash[:shipping_pay_date] = Date.parse(row_hash[:shipping_pay_date]).to_date if row_hash[:shipping_pay_date].present?
      row_hash[:commission_pay_date] = Date.parse(row_hash[:commission_pay_date]).to_date if row_hash[:commission_pay_date].present?
      
      current_user.yafuokus.create(row_hash)
    end
  end

  def yahoo_shoppings_import(file_name)
    # 先にDBのカラム名を用意
    @column = [:date, :order_id, :sku, :goods_name, :unit_price, :number, :sales_amount, :cogs_amount, :commission, :shipping_cost, :money_receipt_date, :shipping_pay_date]
    
    CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
      # rowの値のみを配列化
      row_value = row.to_h.values
      # Zipで合体後にハッシュ化
      row_hash = @column.zip(row_value).to_h
      # データー型の変換  
      row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present?
      row_hash[:unit_price] = row_hash[:unit_price].to_i if row_hash[:unit_price].present?      
      row_hash[:number] = row_hash[:number].to_i if row_hash[:number].present?      
      row_hash[:sales_amount] = row_hash[:sales_amount].to_i if row_hash[:sales_amount].present? 
      row_hash[:cogs_amount] = row_hash[:cogs_amount].to_i if row_hash[:cogs_amount].present? 
      row_hash[:commission] = row_hash[:commission].to_i if row_hash[:commission].present? 
      row_hash[:shipping_cost] = row_hash[:shipping_cost].to_i if row_hash[:shipping_cost].present?       
      row_hash[:money_receipt_date] = Date.parse(row_hash[:money_receipt_date]).to_date if row_hash[:money_receipt_date].present?
      row_hash[:shipping_pay_date] = Date.parse(row_hash[:shipping_pay_date]).to_date if row_hash[:shipping_pay_date].present?
      
      current_user.yahoo_shoppings.create(row_hash)
    end
  end
end

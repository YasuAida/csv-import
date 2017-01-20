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
      @column = [:id, :user_id, :account, :debit_credit, :bs_pl, :display_position]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i        

        current_user.accounts.create(row_hash)
      end
  end

  def allocationcosts_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :stock_id, :title, :allocation_amount]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i
        row_hash[:stock_id] = row_hash[:stock_id].to_i
        row_hash[:allocation_amount] = row_hash[:allocation_amount].to_i
        
        current_user.allocationcosts.create(row_hash)
      end
  end

  def currencies_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :name, :method]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i
        
        current_user.currencies.create(row_hash)
      end
  end

  def disposals_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :stock_id, :date, :order_num, :sku, :number]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i
        row_hash[:stock_id] = row_hash[:stock_id].to_i        
        row_hash[:date] = Date.parse(row_hash[:date]).to_date     
        row_hash[:number] = row_hash[:number].to_i
        
        current_user.disposals.create(row_hash)
      end
  end

  def dummy_stocks_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :stock_id, :sale_date, :cancel_date, :number]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i        
        row_hash[:stock_id] = row_hash[:stock_id].to_i        
        row_hash[:sale_date] = Date.parse(row_hash[:sale_date]).to_date
        row_hash[:cancel_date] = Date.parse(row_hash[:cancel_date]).to_date        
        row_hash[:number] = row_hash[:number].to_i
        
        current_user.dummy_stocks.create(row_hash)
      end
  end

  
  def entrypatterns_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :sku, :kind_of_transaction, :kind_of_payment, :detail_of_payment, :handling]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i 
        
        current_user.entrypatterns.create(row_hash)
      end
  end

  def exchanges_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :date, :country, :rate]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i 
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:rate] = row_hash[:rate].to_f
        
        current_user.exchanges.create(row_hash)
      end
  end

  def expense_methods_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :method]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i 
        
        current_user.expense_methods.create(row_hash)
      end
  end
  
  def expense_relations_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :stock_id, :subexpense_id]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i         
        
        current_user.expense_relations.create(row_hash)
      end
  end

  def expense_titles_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :item, :method]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i 
      
        current_user.expense_titles.create(row_hash)
      end
  end
  
  def expenseledgers_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :date, :account_name, :content, :amount, :rate, :money_paid, :purchase_from, :currency, :grandtotal]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:amount] = row_hash[:amount].to_f
        row_hash[:rate] = row_hash[:rate].to_f
        row_hash[:money_paid] = Date.parse(row_hash[:money_paid]).to_date
        row_hash[:grandtotal] = row_hash[:grandtotal].to_i      
        
        current_user.expenseledgers.create(row_hash)
      end
  end
  
  def financial_statements_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :period_start, :monthly_yearly, :account, :amount]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i
        row_hash[:period_start] = Date.parse(row_hash[:period_start]).to_date
        row_hash[:amount] = row_hash[:amount].to_i
        
        current_user.financial_statements.create(row_hash)
      end
  end
  
  def generalledgers_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :pladmin_id, :stock_id, :stockreturn_id, :return_good_id, :disposal_id, :expenseledger_id, :voucher_id, :subexpense_id, :expense_relation_id, :date, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode, :amount, :content, :trade_company]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i
        row_hash[:pladmin_id] = row_hash[:pladmin_id].to_i if row_hash[:pladmin_id].present?
        row_hash[:stock_id] = row_hash[:stock_id].to_i if row_hash[:stock_id].present?
        row_hash[:stockreturn_id] = row_hash[:stockreturn_id].to_i if row_hash[:stockreturn_id].present?
        row_hash[:return_good_id] = row_hash[:return_good_id].to_i if row_hash[:return_good_id].present?
        row_hash[:disposal_id] = row_hash[:disposal_id].to_i if row_hash[:disposal_id].present?
        row_hash[:expenseledger_id] = row_hash[:expenseledger_id].to_i if row_hash[:expenseledger_id].present?
        row_hash[:voucher_id] = row_hash[:voucher_id].to_i if row_hash[:voucher_id].present?
        row_hash[:subexpense_id] = row_hash[:subexpense_id].to_i if row_hash[:subexpense_id].present?
        row_hash[:expense_relation_id] = row_hash[:expense_relation_id].to_i if row_hash[:expense_relation_id].present?
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:amount] = row_hash[:amount].to_i
       
        current_user.generalledgers.create(row_hash)
      end
  end

  def journalpatterns_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :taxcode, :ledger, :pattern, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i
        
        current_user.journalpatterns.create(row_hash)
      end
  end

  def listingreports_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :sku, :asin, :price, :quantity]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i
        row_hash[:price] = row_hash[:price].to_i
        row_hash[:quantity] = row_hash[:quantity].to_i
        
        current_user.listingreports.create(row_hash)
      end
  end

  def multi_channels_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :date, :order_num, :sku, :number]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:number] = row_hash[:number].to_i
        
        current_user.multi_channels.create(row_hash)
      end
  end

  def periods_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :period_start, :period_end, :monthly_yearly]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i
        row_hash[:period_start] = Date.parse(row_hash[:period_start]).to_date
        row_hash[:period_end] = Date.parse(row_hash[:period_end]).to_date        
        
        current_user.periods.create(row_hash)
      end
  end
  
  def pladmins_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :stock_id, :date, :order_num, :sku, :goods_name, :quantity, :sale_place, :sale_amount, :commission, :cgs_amount, :shipping_cost, :money_receive, :commission_pay_date, :shipping_pay_date]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i
        row_hash[:stock_id] = row_hash[:stock_id].to_i if row_hash[:stock_id].present?        
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:quantity] = row_hash[:quantity].to_i        
        row_hash[:sale_amount] = row_hash[:sale_amount].to_i
        row_hash[:commission] = row_hash[:commission].to_i
        row_hash[:cgs_amount] = row_hash[:cgs_amount].to_i 
        row_hash[:shipping_cost] = row_hash[:shipping_cost].to_i         
        row_hash[:money_receive] = Date.parse(row_hash[:money_receive]).to_date
        row_hash[:commission_pay_date] = Date.parse(row_hash[:commission_pay_date]).to_date if row_hash[:commission_pay_date].present?
        row_hash[:shipping_pay_date] = Date.parse(row_hash[:shipping_pay_date]).to_date if row_hash[:commission_pay_date].present?
        
        current_user.pladmins.create(row_hash)
      end
  end

  def return_goods_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :stock_id, :date, :order_num, :old_sku, :new_sku, :number]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i
        row_hash[:stock_id] = row_hash[:stock_id].to_i
        row_hash[:date] = Date.parse(row_hash[:date]).to_date   
        row_hash[:number] = row_hash[:number].to_i

        current_user.return_goods.create(row_hash)
      end
  end

  def sales_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :date, :order_num, :sku, :kind_of_transaction, :kind_of_payment, :detail_of_payment, :amount, :quantity, :goods_name, :money_receive, :handling]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:amount] = row_hash[:amount].to_i
        row_hash[:quantity] = row_hash[:quantity].to_i        
        row_hash[:money_receive] = Date.parse(row_hash[:money_receive]).to_date
        
        current_user.sales.create(row_hash)
      end
  end

  def selfstorages_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :sku]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i
        
        current_user.selfstorages.create(row_hash)
      end
  end
  
  def stockaccepts_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :date, :fnsku, :sku, :goods_name, :quantity, :fba_number, :fc, :asin]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:quantity] = row_hash[:quantity].to_i

        current_user.stockaccepts.create(row_hash)
      end
  end

  def stockledgers_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :stock_id, :transaction_date, :sku, :asin, :goods_name, :classification, :number, :unit_price, :grandtotal]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i
        row_hash[:stock_id] = row_hash[:stock_id].to_i
        row_hash[:transaction_date] = Date.parse(row_hash[:transaction_date]).to_date
        row_hash[:number] = row_hash[:number].to_i
        row_hash[:unit_price] = row_hash[:unit_price].gsub(/,/, "").to_f
        row_hash[:grandtotal] = row_hash[:grandtotal].to_i
   
        current_user.stockledgers.create(row_hash)
      end
  end

  def stockreturns_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :stock_id, :date, :sku, :asin, :goods_name, :number, :unit_price, :rate, :goods_amount, :money_paid, :purchase_from, :currency, :grandtotal]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i        
        row_hash[:stock_id] = row_hash[:stock_id].to_i
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:number] = row_hash[:number].to_i
        row_hash[:unit_price] = row_hash[:unit_price].gsub(/,/, "").to_f
        row_hash[:rate] = row_hash[:rate].to_f
        row_hash[:goods_amount] = row_hash[:goods_amount].to_i
        row_hash[:money_paid] = Date.parse(row_hash[:money_paid]).to_date
        row_hash[:grandtotal] = row_hash[:grandtotal].to_i        
        
        current_user.stockreturns.create(row_hash)
      end
  end

  def stocks_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :date, :sku, :asin, :goods_name, :number, :unit_price, :rate, :goods_amount, :money_paid, :purchase_from, :currency, :grandtotal]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i 
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:number] = row_hash[:number].to_i
        row_hash[:unit_price] = row_hash[:unit_price].gsub(/,/, "").to_f
        row_hash[:rate] = row_hash[:rate].to_f
        row_hash[:goods_amount] = row_hash[:goods_amount].to_i
        row_hash[:money_paid] = Date.parse(row_hash[:money_paid]).to_date
        row_hash[:grandtotal] = row_hash[:grandtotal].to_i        
        
        current_user.stocks.create(row_hash)
      end
  end

  def subexpenses_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :item, :targetgood, :date, :amount, :rate, :purchase_from, :currency, :money_paid]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i 
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:amount] = row_hash[:amount].to_f
        row_hash[:rate] = row_hash[:rate].to_f
        row_hash[:money_paid] = Date.parse(row_hash[:money_paid]).to_date
        
        current_user.subexpenses.create(row_hash)
      end
  end

  def users_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :name, :postal_code, :address, :telephone_number, :email, :password_digest]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i

        User.create(row_hash)
      end
  end
  
  def vouchers_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :user_id, :date, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode, :amount, :content, :trade_company]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:user_id] = row_hash[:user_id].to_i        
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:amount] = row_hash[:amount].to_i
     
        current_user.vouchers.create(row_hash)
      end
  end
end

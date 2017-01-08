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
      @column = [:id, :account, :debit_credit, :bs_pl, :display_position]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i

        Account.create(row_hash)
      end
  end

  def allocationcosts_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :stock_id, :title, :allocation_amount]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:stock_id] = row_hash[:stock_id].to_i
        row_hash[:allocation_amount] = row_hash[:allocation_amount].to_i
        
        Allocationcost.create(row_hash)
      end
  end

  def currencies_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :name, :method]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        
        Currency.create(row_hash)
      end
  end

  def disposals_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :stock_id, :date, :order_num, :sku, :number]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:stock_id] = row_hash[:stock_id].to_i        
        row_hash[:date] = Date.parse(row_hash[:date]).to_date     
        row_hash[:number] = row_hash[:number].to_i
        
        Disposal.create(row_hash)
      end
  end

  def dummy_stocks_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :stock_id, :sale_date, :cancel_date, :number]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:stock_id] = row_hash[:stock_id].to_i        
        row_hash[:sale_date] = Date.parse(row_hash[:sale_date]).to_date
        row_hash[:cancel_date] = Date.parse(row_hash[:cancel_date]).to_date        
        row_hash[:number] = row_hash[:number].to_i
        
        DummyStock.create(row_hash)
      end
  end

  
  def entrypatterns_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :sku, :kind_of_transaction, :kind_of_payment, :detail_of_payment, :handling]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        
        Entrypattern.create(row_hash)
      end
  end

  def exchanges_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :date, :country, :rate]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:rate] = row_hash[:rate].to_f
        
        Exchange.create(row_hash)
      end
  end

  def expense_methods_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :method]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        
        ExpenseMethod.create(row_hash)
      end
  end
  
  def expense_relations_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :stock_id, :subexpense_id]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        
        ExpenseRelation.create(row_hash)
      end
  end

  def expense_titles_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :item, :method]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
      
        ExpenseTitle.create(row_hash)
      end
  end
  
  def expenseledgers_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :date, :account_name, :content, :amount, :rate, :money_paid, :purchase_from, :currency, :grandtotal]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:amount] = row_hash[:amount].to_f
        row_hash[:rate] = row_hash[:rate].to_f
        row_hash[:money_paid] = Date.parse(row_hash[:money_paid]).to_date
        row_hash[:grandtotal] = row_hash[:grandtotal].to_i      
        
        Expenseledger.create(row_hash)
      end
  end
  
  def financial_statements_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :period_start, :monthly_yearly, :account, :amount]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:period_start] = Date.parse(row_hash[:period_start]).to_date
        row_hash[:amount] = row_hash[:amount].to_i
        
        FinancialStatement.create(row_hash)
      end
  end
  
  def generalledgers_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :date, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode, :amount, :content, :trade_company, :reference]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:amount] = row_hash[:amount].to_i
       
        Generalledger.create(row_hash)
      end
  end

  def journalpatterns_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :taxcode, :ledger, :pattern, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        
        Journalpattern.create(row_hash)
      end
  end

  def listingreports_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :sku, :asin, :price, :quantity]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:price] = row_hash[:price].to_i
        row_hash[:quantity] = row_hash[:quantity].to_i
        
        Listingreport.create(row_hash)
      end
  end

  def multi_channels_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :order_num, :sku]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        
        MultiChannel.create(row_hash)
      end
  end

  def periods_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :period_start, :period_end, :monthly_yearly]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:period_start] = Date.parse(row_hash[:period_start]).to_date
        row_hash[:period_end] = Date.parse(row_hash[:period_end]).to_date        
        
        Period.create(row_hash)
      end
  end
  
  def pladmins_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :stock_id, :date, :order_num, :sku, :goods_name, :quantity, :sale_place, :sale_amount, :commission, :cgs_amount, :shipping_cost, :money_receive, :commission_pay_date, :shipping_pay_date]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:stock_id] = row_hash[:stock_id].to_i        
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:quantity] = row_hash[:quantity].to_i        
        row_hash[:sale_amount] = row_hash[:sale_amount].to_i
        row_hash[:commission] = row_hash[:commission].to_i
        row_hash[:cgs_amount] = row_hash[:cgs_amount].to_i 
        row_hash[:shipping_cost] = row_hash[:shipping_cost].to_i         
        row_hash[:money_receive] = Date.parse(row_hash[:money_receive]).to_date
        row_hash[:commission_pay_date] = Date.parse(row_hash[:commission_pay_date]).to_date if row_hash[:commission_pay_date].present?
        row_hash[:shipping_pay_date] = Date.parse(row_hash[:shipping_pay_date]).to_date if row_hash[:commission_pay_date].present?
        
        Pladmin.create(row_hash)
      end
  end

  def return_goods_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :date, :order_num, :old_sku, :new_sku, :number]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:date] = Date.parse(row_hash[:date]).to_date   
        row_hash[:number] = row_hash[:number].to_i

        ReturnGood.create(row_hash)
      end
  end

  def sales_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :date, :order_num, :sku, :kind_of_transaction, :kind_of_payment, :detail_of_payment, :amount, :quantity, :goods_name, :money_receive, :handling]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:amount] = row_hash[:amount].to_i
        row_hash[:quantity] = row_hash[:quantity].to_i        
        row_hash[:money_receive] = Date.parse(row_hash[:money_receive]).to_date
        
        Sale.create(row_hash)
      end
  end

  def selfstorages_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :sku]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        
        Selfstorage.create(row_hash)
      end
  end
  
  def stockaccepts_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :date, :fnsku, :sku, :goods_name, :quantity, :fba_number, :fc, :asin]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:quantity] = row_hash[:quantity].to_i

        Stockaccept.create(row_hash)
      end
  end

  def stockledgers_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :stock_id, :transaction_date, :sku, :asin, :goods_name, :classification, :number, :unit_price, :grandtotal]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:stock_id] = row_hash[:stock_id].to_i
        row_hash[:transaction_date] = Date.parse(row_hash[:transaction_date]).to_date
        row_hash[:number] = row_hash[:number].to_i
        row_hash[:unit_price] = row_hash[:unit_price].gsub(/,/, "").to_f
        row_hash[:grandtotal] = row_hash[:grandtotal].to_i
   
        Stockledger.create(row_hash)
      end
  end

  def stockreturns_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :stock_id, :date, :sku, :asin, :goods_name, :number, :unit_price, :rate, :goods_amount, :money_paid, :purchase_from, :currency, :grandtotal]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:stock_id] = row_hash[:stock_id].to_i
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:number] = row_hash[:number].to_i
        row_hash[:unit_price] = row_hash[:unit_price].gsub(/,/, "").to_f
        row_hash[:rate] = row_hash[:rate].to_f
        row_hash[:goods_amount] = row_hash[:goods_amount].to_i
        row_hash[:money_paid] = Date.parse(row_hash[:money_paid]).to_date
        row_hash[:grandtotal] = row_hash[:grandtotal].to_i        
        
        Stockreturn.create(row_hash)
      end
  end

  def stocks_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :date, :sku, :asin, :goods_name, :number, :unit_price, :rate, :goods_amount, :money_paid, :purchase_from, :currency, :grandtotal]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:number] = row_hash[:number].to_i
        row_hash[:unit_price] = row_hash[:unit_price].gsub(/,/, "").to_f
        row_hash[:rate] = row_hash[:rate].to_f
        row_hash[:goods_amount] = row_hash[:goods_amount].to_i
        row_hash[:money_paid] = Date.parse(row_hash[:money_paid]).to_date
        row_hash[:grandtotal] = row_hash[:grandtotal].to_i        
        
        Stock.create(row_hash)
      end
  end

  def subexpenses_import(file_name)
      # 先にDBのカラム名を用意
      @column = [:id, :item, :targetgood, :date, :amount, :rate, :purchase_from, :currency, :money_paid]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:amount] = row_hash[:amount].to_f
        row_hash[:rate] = row_hash[:rate].to_f
        row_hash[:money_paid] = Date.parse(row_hash[:money_paid]).to_date
        
        Subexpense.create(row_hash)
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
      @column = [:id, :date, :debit_account, :credit_account, :content, :trade_company, :amount]
      
      CSV.foreach('./tmp/top_page/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:id] = row_hash[:id].to_i
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:amount] = row_hash[:amount].to_i
     
        Voucher.create(row_hash)
      end
  end
end

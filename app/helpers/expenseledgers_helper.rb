module ExpenseledgersHelper
  def file_open(file_name)
      File.open('./tmp/expenseledger/'+ file_name.original_filename, 'wb') do |file|
        file.write(file_name.read)
      end
  end
  
  def file_import_expenseledger(file_name)
    # 先にDBのカラム名を用意
    @column = [:date, :account_name, :amount, :money_paid, :purchase_from, :currency, :content]
    
    CSV.foreach('./tmp/expenseledger/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
      # rowの値のみを配列化
      row_value = row.to_h.values
      # row_valueからカンマを除く
      row_value = row_value.map{|o| o.gsub(",","").gsub("¥","").gsub("\\","") if o.present? } 
      # Zipで合体後にハッシュ化
      row_hash = @column.zip(row_value).to_h
      # データー型の変換
      row_hash[:date] = Date.parse(row_hash[:date]).to_date
      row_hash[:amount] = row_hash[:amount].to_i 
      row_hash[:money_paid] = Date.parse(row_hash[:money_paid]).to_date
      
      Expenseledger.create(row_hash)
    end
  end

  def grandtotal(expenseledgers)
    expenseledgers.each do |expenseledger|
      ex_currency = Currency.find_by(name: expenseledger.currency)
      if ex_currency.method == "外貨×為替レート"
        ex_grandtotal = BigDecimal(expenseledger.amount.to_s).round(2) * expenseledger.rate
        expenseledger.grandtotal = BigDecimal(ex_grandtotal.to_s).round(0)
        expenseledger.save
      else
        ex_grandtotal = BigDecimal(expenseledger.amount.to_s).round(0) * expenseledger.rate
        expenseledger.grandtotal = BigDecimal(ex_grandtotal.to_s).round(0)
        expenseledger.save
      end
    end
  end

  def file_close(file_name)
      File.delete('./tmp/expenseledger/' + file_name.original_filename)
  end
end
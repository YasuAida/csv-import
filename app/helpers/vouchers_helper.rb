module VouchersHelper
  def file_open(file_name)
      File.open('./tmp/voucher/'+ file_name.original_filename, 'wb') do |file|
        file.write(file_name.read)
      end
  end
  
  def file_import_voucher(file_name)
    # 先にDBのカラム名を用意
    @column = [:date, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode, :amount, :content, :trade_company]
    
    CSV.foreach('./tmp/voucher/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
      # rowの値のみを配列化
      row_value = row.to_h.values
      # row_valueからカンマを除く
      row_value = row_value.map{|o| o.gsub(",","").gsub("¥","").gsub("\\","") if o.present? } 
      # Zipで合体後にハッシュ化
      row_hash = @column.zip(row_value).to_h
      # データー型の変換
      row_hash[:date] = Date.parse(row_hash[:date]).to_date
      row_hash[:amount] = row_hash[:amount].to_i 
      
      current_user.vouchers.create(row_hash)
    end
  end

  def file_close(file_name)
      File.delete('./tmp/voucher/' + file_name.original_filename)
  end
end


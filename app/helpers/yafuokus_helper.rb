module YafuokusHelper
  def file_open(file_name)
      File.open('./tmp/yafuoku/'+ file_name.original_filename, 'wb') do |file|
        file.write(file_name.read)
      end
  end
  
  def file_import_yafuoku(file_name)
    # 先にDBのカラム名を用意
    @column = [:date, :order_num, :sku, :goods_name, :sale_place, :unit_price, :number, :commission, :shipping_cost, :money_receipt_date, :commission_pay_date, :shipping_pay_date]
    
    CSV.foreach('./tmp/yafuoku/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
      # rowの値のみを配列化
      row_value = row.to_h.values
      # row_valueからカンマを除く
      row_value = row_value.map{|o| o.gsub(",","").gsub("¥","").gsub("\\","") if o.present? } 
      # Zipで合体後にハッシュ化
      row_hash = @column.zip(row_value).to_h
      # データー型の変換
      row_hash[:date] = Date.parse(row_hash[:date]).to_date
      row_hash[:unit_price] = row_hash[:unit_price].to_i
      row_hash[:number] = row_hash[:number].to_i
      row_hash[:commission] = row_hash[:commission].to_i if row_hash[:commission].present?
      row_hash[:shipping_cost] = row_hash[:shipping_cost].to_i if row_hash[:shipping_cost].present?        
      row_hash[:money_receipt_date] = Date.parse(row_hash[:money_receipt_date]).to_date if row_hash[:money_receipt_date].present?  
      row_hash[:commission_pay_date] = Date.parse(row_hash[:commission_pay_date]).to_date if row_hash[:commission_pay_date].present?        
      row_hash[:shipping_pay_date] = Date.parse(row_hash[:shipping_pay_date]).to_date if row_hash[:shipping_pay_date].present? 
      
      current_user.yafuokus.create(row_hash)
    end
  end

  def file_close(file_name)
      File.delete('./tmp/yafuoku/' + file_name.original_filename)
  end
end

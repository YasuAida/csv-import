module YahooShoppingsHelper
  def file_open(file_name)
    File.open('./tmp/yahoo_shopping/'+ file_name.original_filename, 'wb') do |file|
      file.write(file_name.read)
    end
  end

  def file_import_yahoo_shopping_receipt(file_name)
    File.open('./tmp/yahoo_shopping/'+ file_name.original_filename, 'r') do |file|
      # 先にDBのカラム名を用意
      @column = [:date, :order_id, :receipt_detail, :reference, :pre_tax_amount, :consumption_tax, :sales_amount, :unit_price]
      
      CSV.foreach('./tmp/yahoo_shopping/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # row_valueからカンマを除く
        row_value = row_value.map{|o| o.gsub(",","").gsub("¥","").gsub("\\","") if o.present? } 
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present?
        row_hash[:sales_amount] = row_hash[:sales_amount].to_i if row_hash[:sales_amount].present?
        row_hash[:unit_price] = row_hash[:sales_amount].to_i if row_hash[:sales_amount].present?        

        target_shopping = current_user.yahoo_shoppings.find_by(date: row_hash[:date], order_id: row_hash[:order_id])
        if target_shopping.blank?
          current_user.yahoo_shoppings.create(date: row_hash[:date], order_id: row_hash[:order_id], sales_amount: row_hash[:sales_amount], unit_price: row_hash[:unit_price])
        else
          total_sales = target_shopping.sales_amount.to_i + row_hash[:sales_amount]
          total_unit_price = target_shopping.unit_price.to_i + row_hash[:unit_price]
          target_shopping.update(date: row_hash[:date], sales_amount: total_sales, unit_price: total_unit_price)
        end
      end
    end
  end

  def file_import_yahoo_shopping_payment(file_name)
    File.open('./tmp/yahoo_shopping/'+ file_name.original_filename, 'r') do |file|
      # 先にDBのカラム名を用意
      @column = [:date, :order_id, :payment_detail, :reference, :pre_tax_amount, :consumption_tax, :commission]
      
      CSV.foreach('./tmp/yahoo_shopping/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # row_valueからカンマを除く
        row_value = row_value.map{|o| o.gsub(",","").gsub("¥","").gsub("\\","") if o.present? } 
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present?
        row_hash[:commission] = row_hash[:commission].to_i if row_hash[:commission].present?
        
        target_shopping = current_user.yahoo_shoppings.find_by(order_id: row_hash[:order_id])
        if target_shopping.blank?
          current_user.yahoo_shoppings.create(order_id: row_hash[:order_id], commission: row_hash[:commission])
        else
          commission = target_shopping.commission.to_i + row_hash[:commission]
          target_shopping.update(commission: commission)
        end  
      end
    end
  end

  def file_close(file_name)
    File.delete('./tmp/yahoo_shopping/' + file_name.original_filename)
  end
end

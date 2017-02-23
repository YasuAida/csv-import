module RakutensHelper
  def file_open(file_name)
    File.open('./tmp/rakuten/'+ file_name.original_filename, 'wb') do |file|
      file.write(file_name.read)
    end
  end

  def file_import_past_data_rakuten(file_name)
    # 先にDBのカラム名を用意
    @column = [:order_num, :order_date, :sale_date, :sku, :goods_name, :kind_of_card, :pc_mobile, :unit_price, :number, :shipping_cost,:consumption_tax, :cod_fee, :vest_point, :settlement, :total_sales, :billing_date, :minyukin]
    
    CSV.foreach('./tmp/rakuten/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
      # rowの値のみを配列化
      row_value = row.to_h.values
      # row_valueからカンマを除く
      row_value = row_value.map{|o| o.gsub(",","").gsub("¥","").gsub("\\","") if o.present? } 
      # Zipで合体後にハッシュ化
      row_hash = @column.zip(row_value).to_h
      # データー型の変換
      row_hash[:order_date] = Date.parse(row_hash[:order_date]).to_date if row_hash[:order_date].present?
      row_hash[:sale_date] = Date.parse(row_hash[:sale_date]).to_date if row_hash[:sale_date].present?      
      row_hash[:unit_price] = row_hash[:unit_price].to_i if row_hash[:unit_price].present?
      row_hash[:number] = row_hash[:number].to_i if row_hash[:number].present?
      row_hash[:shipping_cost] = row_hash[:shipping_cost].to_i if row_hash[:shipping_cost].present?
      row_hash[:consumption_tax] = row_hash[:consumption_tax].to_i if row_hash[:consumption_tax].present?        
      row_hash[:cod_fee] = row_hash[:cod_fee].to_i if row_hash[:cod_fee].present?  
      row_hash[:vest_point] = row_hash[:vest_point].to_i if row_hash[:vest_point].present?  
      row_hash[:billing_date] = row_hash[:order_date].end_of_month
      
      row_hash[:total_sales] = row_hash[:unit_price].to_i * row_hash[:number].to_i + row_hash[:shipping_cost].to_i + row_hash[:consumption_tax].to_i + row_hash[:cod_fee].to_i
      row_hash[:minyukin] = row_hash[:total_sales]  
      current_user.rakutens.create(row_hash)
    end
  end

  def file_import_past_point_rakuten(file_name)
    # 先にDBのカラム名を用意
    @column = [:order_num, :shop_coupon, :use_point, :use_coupon]
    
    CSV.foreach('./tmp/rakuten/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
      # rowの値のみを配列化
      row_value = row.to_h.values
      # row_valueからカンマを除く
      row_value = row_value.map{|o| o.gsub(",","").gsub("¥","").gsub("\\","") if o.present? } 
      # Zipで合体後にハッシュ化
      row_hash = @column.zip(row_value).to_h
      # データー型の変換
      row_hash[:shop_coupon] = row_hash[:shop_coupon].to_i * -1 if row_hash[:shop_coupon].present?      
      row_hash[:use_point] = row_hash[:use_point].to_i if row_hash[:use_point].present?  
      row_hash[:use_coupon] = row_hash[:use_coupon].to_i if row_hash[:use_coupon].present?
      
      current_user.point_coupons.create(row_hash)
      
      target_order_nums = current_user.rakutens.where(order_num: row_hash[:order_num])
      plus_order_nums = target_order_nums.where("total_sales > ?", 0)
      minus_order_nums = target_order_nums.where("total_sales < ?", 0)
      if plus_order_nums.present?
        plus_order_nums.each do |plus_order_num|
          if row_hash[:shop_coupon].present?
            total_sales = plus_order_num.unit_price.to_i * plus_order_num.number.to_i + plus_order_num.shipping_cost.to_i + plus_order_num.consumption_tax.to_i + plus_order_num.cod_fee.to_i + row_hash[:shop_coupon]
          else
            total_sales = plus_order_num.unit_price.to_i * plus_order_num.number.to_i + plus_order_num.shipping_cost.to_i + plus_order_num.consumption_tax.to_i + plus_order_num.cod_fee.to_i           
          end
          plus_order_num.total_sales = total_sales
          plus_order_num.shop_coupon = row_hash[:shop_coupon] if row_hash[:shop_coupon].present?
          plus_order_num.use_point = row_hash[:use_point] if row_hash[:use_point].present?
          plus_order_num.use_coupon = row_hash[:use_coupon] if row_hash[:use_coupon].present?
          plus_order_num.minyukin = plus_order_num.total_sales.to_i - plus_order_num.use_point.to_i - plus_order_num.use_coupon.to_i
          plus_order_num.save 
        end
      end
      if minus_order_nums.present?
        minus_order_nums.each do |minus_order_num|
          if row_hash[:shop_coupon].present?
            total_sales = minus_order_num.unit_price.to_i * minus_order_num.number.to_i + minus_order_num.shipping_cost.to_i + minus_order_num.consumption_tax.to_i + minus_order_num.cod_fee.to_i - row_hash[:shop_coupon]
          else
            total_sales = minus_order_num.unit_price.to_i * minus_order_num.number.to_i + minus_order_num.shipping_cost.to_i + minus_order_num.consumption_tax.to_i + minus_order_num.cod_fee.to_i           
          end
          minus_order_num.total_sales = total_sales
          minus_order_num.shop_coupon = row_hash[:shop_coupon] * -1 if row_hash[:shop_coupon].present?
          minus_order_num.use_point = row_hash[:use_point] * -1 if row_hash[:use_point].present?
          minus_order_num.use_coupon = row_hash[:use_coupon] * -1 if row_hash[:use_coupon].present?
          minus_order_num.minyukin = minus_order_num.total_sales.to_i - minus_order_num.use_point.to_i - minus_order_num.use_coupon.to_i
          minus_order_num.save 
        end
      end      
    end
  end

  def file_import_rakuten_csv(file_name)
    require 'kconv'

    File.open('./tmp/rakuten/'+ file_name.original_filename, 'r') do |file|
      part_line = ""
      index_memo = 0
      file.each_line.with_index(1) do |line, index|
        line = line.toutf8
        if index == 1
          @col_line = [:order_date, :order_num, :goods_name, :option, :sku, :unit_price,:number,:settlement,:consumption_tax, :shipping_cost, :cod_fee, :use_point, :use_coupon, :shop_coupon, :pc_mobile, :sale_date, :total_sales, :billing_date, :minyukin]
        elsif line.count(",") < 14 && part_line.blank?
          part_line = line.gsub(/\n/,"")
          index_memo = index
        elsif part_line.present? && index == index_memo + 1
          line = part_line + line
          part_line = ""
          #rakutensレコードの作成         
          create_rakutens(line, @col_line)      
        else
          #rakutensレコードの作成 
          create_rakutens(line, @col_line)
        end
      end
    end
  end
  
  def create_rakutens(line, col_line)
    if line =~ /\"(.*),(.*)\"/
      pre_match = Regexp.last_match.pre_match
      match = Regexp.last_match(0)
      post_match = Regexp.last_match.post_match
      match = match.gsub(",","")
      line = pre_match + match + post_match          
    end
    decorate_line = @col_line.zip(line.gsub(/\r\n/, "").gsub("\"","").split(","))
    line_hash = Hash[*decorate_line.flatten]
    line_hash[:order_date] = Date.parse(line_hash[:order_date]).to_date       
    line_hash[:sale_date] = line_hash[:order_date]           
    line_hash[:unit_price] = line_hash[:unit_price].to_i
    line_hash[:number] = line_hash[:number].to_i
    line_hash[:consumption_tax] = line_hash[:consumption_tax].to_i
    line_hash[:shipping_cost] = line_hash[:shipping_cost].to_i
    line_hash[:cod_fee] = line_hash[:cod_fee].to_i
    line_hash[:use_point] = line_hash[:use_point].to_i if line_hash[:use_point].present?
    line_hash[:use_coupon] = line_hash[:use_coupon].to_i if line_hash[:use_coupon].present?
    line_hash[:shop_coupon] = (line_hash[:shop_coupon].to_i * -1) if line_hash[:shop_coupon].present?
    if line_hash[:pc_mobile] == "0"
      line_hash[:pc_mobile] = "PC"
    else
      line_hash[:pc_mobile] = "Mobile"
    end
    line_hash[:total_sales] = line_hash[:unit_price].to_i * line_hash[:number].to_i + line_hash[:shipping_cost].to_i + line_hash[:consumption_tax].to_i + line_hash[:cod_fee].to_i + line_hash[:shop_coupon].to_i
    line_hash[:billing_date] = line_hash[:order_date].end_of_month
    line_hash[:minyukin] = line_hash[:total_sales].to_i - line_hash[:use_point].to_i - line_hash[:use_coupon].to_i

    current_user.rakutens.create(line_hash)

    point_coupon = current_user.point_coupons.build(order_num: line_hash[:order_num])
    point_coupon.shop_coupon = line_hash[:shop_coupon] if line_hash[:shop_coupon].present?
    point_coupon.use_point = line_hash[:use_point] if line_hash[:use_point].present?
    point_coupon.use_coupon = line_hash[:use_coupon] if line_hash[:use_coupon].present?
    point_coupon.save
    
  end

  def dividing_shop_coupon_amount
    point_coupons = current_user.point_coupons.where("shop_coupon < ?", 0)
    point_coupons.each do |point_coupon|
      target_order_nums = current_user.rakutens.where(order_num: point_coupon.order_num)
      plus_order_nums = target_order_nums.where("total_sales > ?", 0)
      minus_order_nums = target_order_nums.where("total_sales < ?", 0)
      if plus_order_nums.present? && plus_order_nums.count != 1
        total_shop_coupon = point_coupon.shop_coupon
        ex_shop_coupon = total_shop_coupon / plus_order_nums.count
        new_shop_coupon = BigDecimal(ex_shop_coupon.to_s).round(0)
        
        plus_order_nums.each do |plus_order_num|
          plus_order_num.update(shop_coupon: new_shop_coupon)
        end
        
        shop_coupon_fraction = total_shop_coupon - plus_order_nums.sum(:shop_coupon)
        if shop_coupon_fraction != 0
          new_coupon_amount = new_shop_coupon + shop_coupon_fraction
          plus_order_nums.last.update(shop_coupon: new_coupon_amount) 
        end

        plus_order_nums.each do |plus_order_num|
          new_total_sales = plus_order_num.unit_price.to_i * plus_order_num.number.to_i + plus_order_num.shipping_cost.to_i + plus_order_num.consumption_tax.to_i + plus_order_num.cod_fee.to_i + plus_order_num.shop_coupon.to_i
          new_minyukin = new_total_sales - plus_order_num.credit_commission.to_i - plus_order_num.receipt_amount.to_i - plus_order_num.use_point.to_i - plus_order_num.use_coupon.to_i          
          plus_order_num.update(total_sales: new_total_sales, minyukin: new_minyukin)
        end                
      end
      if minus_order_nums.present? && minus_order_nums.count != 1
        total_shop_coupon = point_coupon.shop_coupon * -1
        ex_shop_coupon = total_shop_coupon / minus_order_nums.count
        new_shop_coupon = BigDecimal(ex_shop_coupon.to_s).round(0)
        
        minus_order_nums.each do |minus_order_num|
          minus_order_num.update(shop_coupon: new_shop_coupon)
        end
        
        shop_coupon_fraction = total_shop_coupon - minus_order_nums.sum(:shop_coupon)
        if shop_coupon_fraction != 0
          new_coupon_amount = new_shop_coupon + shop_coupon_fraction
          minus_order_nums.last.update(shop_coupon: new_coupon_amount) 
        end

        minus_order_nums.each do |minus_order_num|
          new_total_sales = minus_order_num.unit_price.to_i * minus_order_num.number.to_i + minus_order_num.shipping_cost.to_i + minus_order_num.consumption_tax.to_i + minus_order_num.cod_fee.to_i + minus_order_num.shop_coupon.to_i
          new_minyukin = new_total_sales - minus_order_num.credit_commission.to_i - minus_order_num.receipt_amount.to_i - minus_order_num.use_point.to_i - minus_order_num.use_coupon.to_i               
          minus_order_num.update(total_sales: new_total_sales, minyukin: new_minyukin)
        end                
      end
    end
  end
 
  def dividing_use_point_amount
    point_coupons = current_user.point_coupons.where("use_point > ?", 0)
    point_coupons.each do |point_coupon|
      target_order_nums = current_user.rakutens.where(order_num: point_coupon.order_num)
      plus_order_nums = target_order_nums.where("total_sales > ?", 0)
      minus_order_nums = target_order_nums.where("total_sales < ?", 0)
      if plus_order_nums.present? && plus_order_nums.count != 1
        total_use_point = point_coupon.use_point
        plus_order_nums.each do |plus_order_num|
          ex_use_point = total_use_point * plus_order_num.total_sales / plus_order_nums.sum(:total_sales)
          @new_use_point = BigDecimal(ex_use_point.to_s).round(0)        
          plus_order_num.update(use_point: @new_use_point)
        end          
        use_point_fraction = total_use_point - plus_order_nums.sum(:use_point)
        if use_point_fraction == 0
          @new_use_point = ""
        else
          new_point_amount = @new_use_point + use_point_fraction
          plus_order_nums.last.update(use_point: new_point_amount) 
          @new_use_point = ""
        end
        target_order_nums = current_user.rakutens.where(order_num: point_coupon.order_num)
        plus_order_nums = target_order_nums.where("total_sales > ?", 0)
        plus_order_nums.each do |plus_order_num|       
          new_minyukin = plus_order_num.total_sales.to_i - plus_order_num.credit_commission.to_i - plus_order_num.receipt_amount.to_i - plus_order_num.use_point.to_i - plus_order_num.use_coupon.to_i               
          plus_order_num.update(minyukin: new_minyukin)
        end
      end
      if minus_order_nums.present? && minus_order_nums.count != 1
        total_use_point = point_coupon.use_point * -1
        minus_order_nums.each do |minus_order_num|
          ex_use_point = total_use_point * minus_order_num.total_sales / minus_order_nums.sum(:total_sales)
          @new_use_point = BigDecimal(ex_use_point.to_s).round(0)        
          minus_order_num.update(use_point: @new_use_point)
        end          
        use_point_fraction = total_use_point - minus_order_nums.sum(:use_point)
        if use_point_fraction == 0
          @new_use_point = ""
        else
          new_point_amount = @new_use_point + use_point_fraction
          minus_order_nums.last.update(use_point: new_point_amount) 
          @new_use_point = ""
        end
        target_order_nums = current_user.rakutens.where(order_num: point_coupon.order_num)
        minus_order_nums = target_order_nums.where("total_sales < ?", 0)
        minus_order_nums.each do |minus_order_num|
          new_minyukin = minus_order_num.total_sales.to_i - minus_order_num.credit_commission.to_i - minus_order_num.receipt_amount.to_i - minus_order_num.use_point.to_i - minus_order_num.use_coupon.to_i               
          minus_order_num.update(minyukin: new_minyukin)
        end
      end
    end
  end
 
  def dividing_use_coupon_amount
    point_coupons = current_user.point_coupons.where("use_coupon > ?", 0)
    point_coupons.each do |point_coupon|   
      target_order_nums = current_user.rakutens.where(order_num: point_coupon.order_num)
      plus_order_nums = target_order_nums.where("total_sales > ?", 0)
      minus_order_nums = target_order_nums.where("total_sales < ?", 0)
      if plus_order_nums.present? && plus_order_nums.count != 1
        total_use_coupon = point_coupon.use_coupon
        plus_order_nums.each do |plus_order_num|
          ex_use_coupon = total_use_coupon * plus_order_num.total_sales / plus_order_nums.sum(:total_sales)
          @new_use_coupon = BigDecimal(ex_use_coupon.to_s).round(0)
          plus_order_num.update(use_coupon: @new_use_coupon)
        end          
        use_coupon_fraction = total_use_coupon - plus_order_nums.sum(:use_coupon)
        if use_coupon_fraction == 0
          @new_use_coupon = ""
        else
          new_rakuten_coupon = @new_use_coupon + use_coupon_fraction
          plus_order_nums.last.update(use_coupon: new_rakuten_coupon) 
          @new_use_coupon = ""
        end
        target_order_nums = current_user.rakutens.where(order_num: point_coupon.order_num)
        plus_order_nums = target_order_nums.where("total_sales > ?", 0)
        plus_order_nums.each do |plus_order_num|
          new_minyukin = plus_order_num.total_sales.to_i - plus_order_num.credit_commission.to_i - plus_order_num.receipt_amount.to_i - plus_order_num.use_point.to_i - plus_order_num.use_coupon.to_i               
          plus_order_num.update(minyukin: new_minyukin)
        end
      end
      if minus_order_nums.present? && minus_order_nums.count != 1
        total_use_coupon = point_coupon.use_coupon * -1
        minus_order_nums.each do |minus_order_num|
          ex_use_coupon = total_use_coupon * minus_order_num.total_sales / minus_order_nums.sum(:total_sales)
          @new_use_coupon = BigDecimal(ex_use_coupon.to_s).round(0)
          minus_order_num.update(use_coupon: @new_use_coupon)
        end          
        use_coupon_fraction = total_use_coupon - minus_order_nums.sum(:use_coupon)
        if use_coupon_fraction == 0
          @new_use_coupon = ""
        else
          new_rakuten_coupon = @new_use_coupon + use_coupon_fraction
          minus_order_nums.last.update(use_coupon: new_rakuten_coupon) 
          @new_use_coupon = ""
        end
        target_order_nums = current_user.rakutens.where(order_num: point_coupon.order_num)
        minus_order_nums = target_order_nums.where("total_sales < ?", 0)
        minus_order_nums.each do |minus_order_num|
          new_minyukin = minus_order_num.total_sales.to_i - minus_order_num.credit_commission.to_i - minus_order_num.receipt_amount.to_i - minus_order_num.use_point.to_i - minus_order_num.use_coupon.to_i               
          minus_order_num.update(minyukin: new_minyukin)
        end
      end
    end
  end
  
  def file_import_invest_list(file_name)
    require 'kconv'

    File.open('./tmp/rakuten/'+ file_name.original_filename, 'r') do |file|
      file.each_line.with_index(1) do |line, index|
        line = line.toutf8
        if index == 1
          @col_line = [:order_num, :order_date, :vest_point]
        else
          decorate_line = @col_line.zip(line.gsub(/\r\n/, "").split(","))
          line_hash = Hash[*decorate_line.flatten]
          line_hash[:order_date] = Date.parse(line_hash[:order_date]).to_date           
          line_hash[:vest_point] = line_hash[:vest_point].to_i if line_hash[:vest_point].present?
          
          target_rakutens = current_user.rakutens.where(order_date: line_hash[:order_date], order_num: line_hash[:order_num])
          target_rakutens = target_rakutens.where("total_sales > ?", 0)
          if target_rakutens.present? && target_rakutens.count == 1 && line_hash[:vest_point] != 0
            target_rakutens.first.update(vest_point: line_hash[:vest_point])
          elsif target_rakutens.present? && target_rakutens.count > 1 && line_hash[:vest_point] != 0
            target_rakutens.each do |target_rakuten|                      
              ex_vest_point = line_hash[:vest_point] * target_rakuten.total_sales / target_rakutens.sum(:total_sales)
              @target_vest_point = BigDecimal(ex_vest_point.to_s).round(0)
              target_rakuten.update(vest_point: @target_vest_point)
            end           
            vest_point_fraction = line_hash[:vest_point] - target_rakutens.sum(:vest_point)
            if vest_point_fraction == 0
              @target_vest_point = ""
            else
              new_vest_point = @target_vest_point + vest_point_fraction
              target_rakutens.last.update(vest_point: new_vest_point)
              @target_vest_point = ""
            end
          end
        end
      end
    end
  end

  def file_import_credit_data(file_name)
    require 'kconv'
    
    current_user.rakuten_temps.destroy_all
    File.open('./tmp/rakuten/'+ file_name.original_filename, 'r') do |file|
      file.each_line.with_index(1) do |line, index|
        line = line.toutf8
        if index == 1
          @col_line = [:order_num, :order_date, :sale_date, :kind_of_card, :brand, :content, :installment, :receipt_amount, :rate, :closing_date, :money_receipt_date]
        elsif line.include?("総件数")
          break
        else
          decorate_line = @col_line.zip(line.gsub(/\r\n/, "").split(","))
          line_hash = Hash[*decorate_line.flatten]
          line_hash[:order_date] = Date.parse(line_hash[:order_date]).to_date  
          line_hash[:sale_date] = Date.parse(line_hash[:sale_date]).to_date          
          line_hash[:receipt_amount] = line_hash[:receipt_amount].to_i if line_hash[:receipt_amount].present?
          line_hash[:rate] = line_hash[:rate].to_f if line_hash[:rate].present?

          if file_name.original_filename =~ /TransferDetail_\d{6}26-\d{6}10.csv/ || file_name.original_filename =~ /TransferDetail_\d{6}11-\d{6}25.csv/
            closing_date_portion = file_name.original_filename.gsub(/TransferDetail_\d{8}-/,"").gsub(/.csv/,"") 
            line_hash[:closing_date] = Date.parse(closing_date_portion).to_date
          end
                  
          if line_hash[:closing_date].present? && line_hash[:closing_date].next_month.wday != 0 && line_hash[:closing_date].next_month.wday != 6
            line_hash[:money_receipt_date] = line_hash[:closing_date].next_month
          elsif line_hash[:closing_date].present? && line_hash[:closing_date].next_month.wday == 0
            line_hash[:money_receipt_date] = line_hash[:closing_date].next_month + 1
          elsif line_hash[:closing_date].present? && line_hash[:closing_date].next_month.wday == 6  
            line_hash[:money_receipt_date] = line_hash[:closing_date].next_month + 2
          end          
          
          current_user.rakuten_temps.create(line_hash) 
        end  
      end
    end          
    
    rakuten_temps = current_user.rakuten_temps.all
    rakuten_temps.each do |temp|
      if temp.content == "請求取消"
        erase_temp = rakuten_temps.find_by(order_num: temp.order_num, order_date: temp.order_date, kind_of_card: temp.kind_of_card, brand: temp.brand, content: "売上請求", installment: temp.installment, receipt_amount: temp.receipt_amount * -1, rate: temp.rate)
        if erase_temp.present?
          erase_temp.destroy
          temp.destroy
        end
      end
    end      

    revised_temps = current_user.rakuten_temps.all          
    revised_temps.each do |temp|
      if temp.content == "売上請求" 
        target_rakutens = current_user.rakutens.where(order_date: temp.order_date, order_num: temp.order_num)
        csv_rakutens = target_rakutens.where("total_sales > ?", 0)
          
        ex_commission = temp.receipt_amount * (temp.rate / 100) 
        total_credit_commission = BigDecimal(ex_commission.to_s).round(0)
      
        if csv_rakutens.present?
          csv_rakutens.each do |csv_rakuten|
            csv_rakuten.kind_of_card = temp.kind_of_card
            csv_rakuten.sale_date = temp.sale_date
            csv_rakuten.closing_date= temp.closing_date
            csv_rakuten.money_receipt_date= temp.money_receipt_date          
            
            each_commission = total_credit_commission * csv_rakuten.total_sales / csv_rakutens.sum(:total_sales)
            csv_rakuten.credit_commission = BigDecimal(each_commission.to_s).round(0)          
            each_receipt_amount = temp.receipt_amount * csv_rakuten.total_sales / csv_rakutens.sum(:total_sales)
            csv_rakuten.receipt_amount = BigDecimal(each_receipt_amount.to_s).round(0) - csv_rakuten.credit_commission       
          
            csv_rakuten.save
          end
          target_rakutens = current_user.rakutens.where(order_date: temp.order_date, order_num: temp.order_num)
          csv_rakutens = target_rakutens.where("total_sales > ?", 0)    
          csv_rakutens.group(:order_num).each do |csv_rakuten| 
            credit_commission_fraction = total_credit_commission - csv_rakutens.sum(:credit_commission)
            if credit_commission_fraction != 0
              new_credit_commission = csv_rakutens.first.credit_commission + credit_commission_fraction
              csv_rakutens.first.update(credit_commission: new_credit_commission) 
            end
            receipt_amount_fraction = temp.receipt_amount - total_credit_commission - csv_rakutens.sum(:receipt_amount)
            if receipt_amount_fraction != 0
              new_receipt_amount = csv_rakutens.first.receipt_amount + receipt_amount_fraction
              csv_rakutens.first.update(receipt_amount: new_receipt_amount) 
            end
          end       
        end
      elsif temp.content == "請求取消" 
        target_rakutens = current_user.rakutens.where(order_date: temp.order_date, order_num: temp.order_num)
        minus_rakutens = target_rakutens.where("total_sales < ?", 0)
          
        ex_commission = temp.receipt_amount * (temp.rate / 100) 
        total_credit_commission = BigDecimal(ex_commission.to_s).round(0)
      
        if minus_rakutens.present?
          minus_rakutens.each do |minus_rakuten|
            minus_rakuten.kind_of_card = temp.kind_of_card
            minus_rakuten.sale_date = temp.sale_date
            minus_rakuten.closing_date= temp.closing_date
            minus_rakuten.money_receipt_date= temp.money_receipt_date          
            
            each_commission = total_credit_commission * minus_rakuten.total_sales / minus_rakutens.sum(:total_sales)
            minus_rakuten.credit_commission = BigDecimal(each_commission.to_s).round(0)          
            each_receipt_amount = temp.receipt_amount * minus_rakuten.total_sales / minus_rakutens.sum(:total_sales)
            minus_rakuten.receipt_amount = BigDecimal(each_receipt_amount.to_s).round(0) - minus_rakuten.credit_commission       
          
            minus_rakuten.save
          end
          target_rakutens = current_user.rakutens.where(order_date: temp.order_date, order_num: temp.order_num)
          minus_rakutens = target_rakutens.where("total_sales < ?", 0)    
          minus_rakutens.group(:order_num).each do |minus_rakuten| 
            credit_commission_fraction = total_credit_commission - minus_rakutens.sum(:credit_commission)
            if credit_commission_fraction != 0
              new_credit_commission = minus_rakutens.first.credit_commission + credit_commission_fraction
              minus_rakutens.first.update(credit_commission: new_credit_commission) 
            end
            receipt_amount_fraction = temp.receipt_amount - total_credit_commission - minus_rakutens.sum(:receipt_amount)
            if receipt_amount_fraction != 0
              new_receipt_amount = minus_rakutens.first.receipt_amount + receipt_amount_fraction
              minus_rakutens.first.update(receipt_amount: new_receipt_amount) 
            end
          end
        end
      end
      target_rakutens = current_user.rakutens.where(order_date: temp.order_date, order_num: temp.order_num)
      target_rakutens.each do |target_rakuten|
        minyukin = target_rakuten.total_sales.to_i - target_rakuten.credit_commission.to_i - target_rakuten.receipt_amount.to_i - target_rakuten.use_point.to_i - target_rakuten.use_coupon.to_i
        target_rakuten.update(minyukin: minyukin)
      end
      target_rakutens = current_user.rakutens.where(order_date: temp.order_date, order_num: temp.order_num)
      minyukin_rakutens = target_rakutens.where.not(minyukin: 0)
      while minyukin_rakutens.present? && minyukin_rakutens.count > 1 && minyukin_rakutens.sum(:minyukin) == 0 && minyukin_rakutens.first.minyukin != 0 do
        if minyukin_rakutens.first.minyukin > 0
          minyukin_rakutens.first.update(receipt_amount: (minyukin_rakutens.first.receipt_amount - 1))
          minyukin_rakutens.first.update(minyukin: (minyukin_rakutens.first.minyukin - 1))
          minus_rakuten = minyukin_rakutens.where("minyukin < ?", 0).first
          minus_rakuten.update(receipt_amount: (minus_rakuten.receipt_amount + 1))
          minus_rakuten.update(minyukin: (minus_rakuten.minyukin + 1))
        elsif minyukin_rakutens.first.minyukin < 0
          minyukin_rakutens.first.update(receipt_amount: (minyukin_rakutens.first.receipt_amount + 1))
          minyukin_rakutens.first.update(minyukin: (minyukin_rakutens.first.minyukin + 1))
          plus_rakuten = minyukin_rakutens.where("minyukin > ?", 0).first
          plus_rakuten.update(receipt_amount: (plus_rakuten.receipt_amount - 1))
          plus_rakuten.update(minyukin: (plus_rakuten.minyukin - 1))
        end
        target_rakutens = current_user.rakutens.where(order_date: temp.order_date, order_num: temp.order_num)
        minyukin_rakutens = target_rakutens.where.not(minyukin: 0)
      end
      temp.destroy
    end
  end
  
  def file_import_bank_data(file_name)
    require 'kconv'

    File.open('./tmp/rakuten/'+ file_name.original_filename, 'r') do |file|
      file.each_line.with_index(1) do |line, index|
        line = line.toutf8
        if index == 1
          @col_line = [:link_date, :order_time, :closing_date, :customer_name, :receipt_amount, :order_num, :settlement_status, :memo, :money_receipt_date, :order_date]
        else
          decorate_line = @col_line.zip(line.gsub(/\r\n/, "").gsub("\"", "").split(","))
          line_hash = Hash[*decorate_line.flatten]      
          line_hash[:closing_date] = Date.parse(line_hash[:closing_date]).to_date if line_hash[:closing_date].present?
          line_hash[:receipt_amount] = line_hash[:receipt_amount].to_i if line_hash[:receipt_amount].present?          
        
          if line_hash[:closing_date].present? && line_hash[:closing_date].wday != 5 && line_hash[:closing_date].wday != 6 && line_hash[:closing_date].wday != 0
            line_hash[:money_receipt_date] = line_hash[:closing_date] + 1
          elsif line_hash[:closing_date].present? && line_hash[:closing_date].wday == 5
            line_hash[:money_receipt_date] = line_hash[:closing_date] + 3
          elsif line_hash[:closing_date].present? && line_hash[:closing_date].wday == 6  
            line_hash[:money_receipt_date] = line_hash[:closing_date] + 2
          elsif line_hash[:closing_date].present? && line_hash[:closing_date].wday == 0  
            line_hash[:money_receipt_date] = line_hash[:closing_date] + 1            
          end  
          
          if line_hash[:order_num] =~ /-\d{8}-/
            match = Regexp.last_match(0)
            match_date = match.gsub("-", "")
            line_hash[:order_date] = Date.parse(match_date).to_date if match_date.present?
          end
           
          target_rakutens = current_user.rakutens.where(order_num: line_hash[:order_num])
          csv_rakutens = target_rakutens.where("total_sales > ?", 0)
          
          if csv_rakutens.present?
            csv_rakutens.each do |csv_rakuten|                   
              csv_rakuten.sale_date = line_hash[:closing_date]
              csv_rakuten.closing_date = line_hash[:closing_date]
              csv_rakuten.money_receipt_date = line_hash[:money_receipt_date]                  
                
              each_receipt_amount = line_hash[:receipt_amount] * csv_rakuten.total_sales / csv_rakutens.sum(:total_sales)
              csv_rakuten.receipt_amount = BigDecimal(each_receipt_amount.to_s).round(0)
              
              csv_rakuten.save
            end
            target_rakutens = current_user.rakutens.where(order_num: line_hash[:order_num])
            csv_rakutens = target_rakutens.where("total_sales > ?", 0)
            csv_rakutens.group(:order_num).each do |csv_rakuten|            
              receipt_amount_fraction = line_hash[:receipt_amount] - csv_rakutens.sum(:receipt_amount)
              if receipt_amount_fraction != 0
                new_receipt_amount = csv_rakutens.first.receipt_amount + receipt_amount_fraction
                csv_rakutens.first.update(receipt_amount: new_receipt_amount) 
              end
            end
            
            csv_rakutens.each do |csv_rakuten|
              minyukin = csv_rakuten.total_sales.to_i - csv_rakuten.credit_commission.to_i - csv_rakuten.receipt_amount.to_i - csv_rakuten.use_point.to_i - csv_rakuten.use_coupon.to_i
              csv_rakuten.update(minyukin: minyukin)
            end
          end
          
          target_rakutens = current_user.rakutens.where(order_num: line_hash[:order_num])
          minyukin_rakutens = target_rakutens.where.not(minyukin: 0)
          while minyukin_rakutens.present? && minyukin_rakutens.count > 1 && minyukin_rakutens.sum(:minyukin) == 0 && minyukin_rakutens.first.minyukin != 0 do
            if minyukin_rakutens.first.minyukin > 0
              minyukin_rakutens.first.update(receipt_amount: (minyukin_rakutens.first.receipt_amount - 1))
              minyukin_rakutens.first.update(minyukin: (minyukin_rakutens.first.minyukin - 1))
              minus_rakuten = minyukin_rakutens.where("minyukin < ?", 0).first
              minus_rakuten.update(receipt_amount: (minus_rakuten.receipt_amount + 1))
              minus_rakuten.update(minyukin: (minus_rakuten.minyukin + 1))
            elsif minyukin_rakutens.first.minyukin < 0
              minyukin_rakutens.first.update(receipt_amount: (minyukin_rakutens.first.receipt_amount + 1))
              minyukin_rakutens.first.update(minyukin: (minyukin_rakutens.first.minyukin + 1))
              plus_rakuten = minyukin_rakutens.where("minyukin > ?", 0).first
              plus_rakuten.update(receipt_amount: (plus_rakuten.receipt_amount - 1))
              plus_rakuten.update(minyukin: (plus_rakuten.minyukin - 1))
            end
            target_rakutens = current_user.rakutens.where(order_num: line_hash[:order_num])
            minyukin_rakutens = target_rakutens.where.not(minyukin: 0)
          end
        end
      end
    end
  end
            
  def file_import_multi_data(file_name)
    require 'kconv'

    File.open('./tmp/rakuten/'+ file_name.original_filename, 'r') do |file|
      file.each_line.with_index(1) do |line, index|
        line = line.toutf8
        if index == 1
          @col_line = [:order_num, :order_date, :accept_date, :content, :payment_method, :sale_amount, :credit_commission, :consumption_tax, :stamp_duty, :receipt_amount, :closing_date, :money_receipt_date, :billing_date]
        elsif line.include?("総件数")
          break          
        else
          decorate_line = @col_line.zip(line.gsub(/\r\n/, "").split(","))
          line_hash = Hash[*decorate_line.flatten]
          line_hash[:order_date] = Date.parse(line_hash[:order_date]).to_date          
          line_hash[:accept_date] = Date.parse(line_hash[:accept_date]).to_date
          line_hash[:closing_date] = line_hash[:accept_date].end_of_month
          line_hash[:billing_date] = line_hash[:order_date].end_of_month
          line_hash[:credit_commission] = line_hash[:credit_commission].to_i if line_hash[:credit_commission].present?          
          line_hash[:consumption_tax] = line_hash[:consumption_tax].to_i if line_hash[:consumption_tax].present? 
          line_hash[:stamp_duty] = line_hash[:stamp_duty].to_i if line_hash[:stamp_duty].present? 
          line_hash[:receipt_amount] = line_hash[:receipt_amount].to_i if line_hash[:receipt_amount].present? 
        
          if line_hash[:closing_date].present? && line_hash[:closing_date].since(10.days).wday != 0 && line_hash[:closing_date].since(10.days).wday != 6
            line_hash[:money_receipt_date] = line_hash[:closing_date].since(10.days)
          elsif line_hash[:closing_date].present? && line_hash[:closing_date].since(10.days).wday == 0  
            line_hash[:money_receipt_date] = line_hash[:closing_date].since(10.days) + 1 
          elsif line_hash[:closing_date].present? && line_hash[:closing_date].since(10.days).wday == 6  
            line_hash[:money_receipt_date] = line_hash[:closing_date].since(10.days) + 2          
          end  
            
          target_rakutens = current_user.rakutens.where(order_date: line_hash[:order_date], order_num: line_hash[:order_num])
          csv_rakutens = target_rakutens.where("total_sales > ?", 0)
          total_commission = line_hash[:credit_commission] + line_hash[:consumption_tax] 
          total_stamp_duty = line_hash[:stamp_duty]
          commission_amount = total_commission + total_stamp_duty

          if csv_rakutens.present?    
            csv_rakutens.each do |csv_rakuten|                   
              csv_rakuten.sale_date = line_hash[:accept_date]
              csv_rakuten.closing_date = line_hash[:closing_date]
              csv_rakuten.money_receipt_date = line_hash[:money_receipt_date]
  
              each_commission = commission_amount * csv_rakuten.total_sales / csv_rakutens.sum(:total_sales)
              csv_rakuten.credit_commission = BigDecimal(each_commission.to_s).round(0)
              each_receipt_amount = line_hash[:receipt_amount] * csv_rakuten.total_sales / csv_rakutens.sum(:total_sales)
              csv_rakuten.receipt_amount = BigDecimal(each_receipt_amount.to_s).round(0)
              
              csv_rakuten.save
            end
            target_rakutens = current_user.rakutens.where(order_date: line_hash[:order_date], order_num: line_hash[:order_num])
            csv_rakutens = target_rakutens.where("total_sales > ?", 0)
            csv_rakutens.group(:order_num).each do |csv_rakuten| 
              commission_fraction = commission_amount - csv_rakutens.sum(:credit_commission)
              if commission_fraction != 0
                new_commission = csv_rakutens.first.credit_commission + commission_fraction
                csv_rakutens.first.update(credit_commission: new_commission) 
              end
              receipt_amount_fraction = line_hash[:receipt_amount] - csv_rakutens.sum(:receipt_amount)
              if receipt_amount_fraction != 0
                new_receipt_amount = csv_rakutens.first.receipt_amount + receipt_amount_fraction
                csv_rakutens.first.update(receipt_amount: new_receipt_amount) 
              end              
            end
            csv_rakutens.each do |csv_rakuten|
              minyukin = csv_rakuten.total_sales.to_i - csv_rakuten.credit_commission.to_i - csv_rakuten.receipt_amount.to_i - csv_rakuten.use_point.to_i - csv_rakuten.use_coupon.to_i
              csv_rakuten.update(minyukin: minyukin)
            end
          end
          
          target_rakutens = current_user.rakutens.where(order_num: line_hash[:order_num])
          minyukin_rakutens = target_rakutens.where.not(minyukin: 0)
          while minyukin_rakutens.present? && minyukin_rakutens.count > 1 && minyukin_rakutens.sum(:minyukin) == 0 && minyukin_rakutens.first.minyukin != 0 do
            if minyukin_rakutens.first.minyukin > 0
              minyukin_rakutens.first.update(receipt_amount: (minyukin_rakutens.first.receipt_amount - 1))
              minyukin_rakutens.first.update(minyukin: (minyukin_rakutens.first.minyukin - 1))
              minus_rakuten = minyukin_rakutens.where("minyukin < ?", 0).first
              minus_rakuten.update(receipt_amount: (minus_rakuten.receipt_amount + 1))
              minus_rakuten.update(minyukin: (minus_rakuten.minyukin + 1))
            elsif minyukin_rakutens.first.minyukin < 0
              minyukin_rakutens.first.update(receipt_amount: (minyukin_rakutens.first.receipt_amount + 1))
              minyukin_rakutens.first.update(minyukin: (minyukin_rakutens.first.minyukin + 1))
              plus_rakuten = minyukin_rakutens.where("minyukin > ?", 0).first
              plus_rakuten.update(receipt_amount: (plus_rakuten.receipt_amount - 1))
              plus_rakuten.update(minyukin: (plus_rakuten.minyukin - 1))
            end
            target_rakutens = current_user.rakutens.where(order_num: line_hash[:order_num])
            minyukin_rakutens = target_rakutens.where.not(minyukin: 0)
          end
        end
      end
    end
  end
  
  def file_import_rakuten_bank_data(file_name)
    require 'kconv'

    File.open('./tmp/rakuten/'+ file_name.original_filename, 'r') do |file|
      file.each_line.with_index(1) do |line, index|
        line = line.toutf8
        if index == 1
          @col_line = [:order_num, :order_date, :money_receipt_date, :sale_amount, :receipt_amount, :credit_commission, :billing_date]      
        else
          decorate_line = @col_line.zip(line.gsub(/\r\n/, "").gsub("\"", "").split(","))
          line_hash = Hash[*decorate_line.flatten]
          line_hash[:order_date] = Date.parse(line_hash[:order_date]).to_date
          line_hash[:billing_date] = line_hash[:order_date].end_of_month
          line_hash[:money_receipt_date] = Date.parse(line_hash[:money_receipt_date]).to_date
          line_hash[:receipt_amount] = line_hash[:receipt_amount].to_i if line_hash[:receipt_amount].present?
          line_hash[:credit_commission] = line_hash[:credit_commission].to_i if line_hash[:credit_commission].present?          
            
          target_rakutens = current_user.rakutens.where(order_date: line_hash[:order_date], order_num: line_hash[:order_num])
          csv_rakutens = target_rakutens.where("total_sales > ?", 0)
          commission_amount = line_hash[:credit_commission]

          if csv_rakutens.present?    
            csv_rakutens.each do |csv_rakuten|                   
              csv_rakuten.money_receipt_date = line_hash[:money_receipt_date]
  
              each_commission = commission_amount * csv_rakuten.total_sales / csv_rakutens.sum(:total_sales)
              csv_rakuten.credit_commission = BigDecimal(each_commission.to_s).round(0) 
              each_receipt_amount = line_hash[:receipt_amount] * csv_rakuten.total_sales / csv_rakutens.sum(:total_sales) - each_commission
              csv_rakuten.receipt_amount = BigDecimal(each_receipt_amount.to_s).round(0)           
              
              csv_rakuten.save
            end
            target_rakutens = current_user.rakutens.where(order_date: line_hash[:order_date], order_num: line_hash[:order_num])
            csv_rakutens = target_rakutens.where("total_sales > ?", 0)
            csv_rakutens.group(:order_num).each do |csv_rakuten|            
              receipt_amount_fraction = line_hash[:receipt_amount] - commission_amount - csv_rakutens.sum(:receipt_amount)
              commission_fraction = commission_amount - csv_rakutens.sum(:credit_commission)
              if commission_fraction != 0
                new_commission = csv_rakutens.first.credit_commission + commission_fraction
                csv_rakutens.first.update(credit_commission: new_commission) 
              end
              if receipt_amount_fraction != 0
                new_receipt_amount = csv_rakutens.first.receipt_amount + receipt_amount_fraction
                csv_rakutens.first.update(receipt_amount: new_receipt_amount) 
              end
            end
          end
          csv_rakutens.each do |csv_rakuten| 
            minyukin = csv_rakuten.total_sales.to_i - csv_rakuten.credit_commission.to_i - csv_rakuten.receipt_amount.to_i - csv_rakuten.use_point.to_i - csv_rakuten.use_coupon.to_i
            csv_rakuten.update(minyukin: minyukin)
          end
          target_rakutens = current_user.rakutens.where(order_num: line_hash[:order_num])
          minyukin_rakutens = target_rakutens.where.not(minyukin: 0)
          while minyukin_rakutens.present? && minyukin_rakutens.count > 1 && minyukin_rakutens.sum(:minyukin) == 0 && minyukin_rakutens.first.minyukin != 0 do
            if minyukin_rakutens.first.minyukin > 0
              minyukin_rakutens.first.update(receipt_amount: (minyukin_rakutens.first.receipt_amount - 1))
              minyukin_rakutens.first.update(minyukin: (minyukin_rakutens.first.minyukin - 1))
              minus_rakuten = minyukin_rakutens.where("minyukin < ?", 0).first
              minus_rakuten.update(receipt_amount: (minus_rakuten.receipt_amount + 1))
              minus_rakuten.update(minyukin: (minus_rakuten.minyukin + 1))
            elsif minyukin_rakutens.first.minyukin < 0
              minyukin_rakutens.first.update(receipt_amount: (minyukin_rakutens.first.receipt_amount + 1))
              minyukin_rakutens.first.update(minyukin: (minyukin_rakutens.first.minyukin + 1))
              plus_rakuten = minyukin_rakutens.where("minyukin > ?", 0).first
              plus_rakuten.update(receipt_amount: (plus_rakuten.receipt_amount - 1))
              plus_rakuten.update(minyukin: (plus_rakuten.minyukin - 1))
            end
            target_rakutens = current_user.rakutens.where(order_num: line_hash[:order_num])
            minyukin_rakutens = target_rakutens.where.not(minyukin: 0)
          end          
        end
      end
    end
  end

  def file_close(file_name)
    File.delete('./tmp/rakuten/' + file_name.original_filename)
  end
end

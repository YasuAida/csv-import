module StocksHelper
  def file_open(file_name)
      File.open('./tmp/stock/'+ file_name.original_filename, 'wb') do |file|
        file.write(file_name.read)
      end
  end
  
  def file_import_stock(file_name)
    # 先にDBのカラム名を用意
    @column = [:date, :asin, :goods_name, :unit_price, :number, :money_paid, :purchase_from, :currency, :sku, :rate, :goods_amount]
    
    CSV.foreach('./tmp/stock/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
      # rowの値のみを配列化
      row_value = row.to_h.values
      # Zipで合体後にハッシュ化
      row_hash = @column.zip(row_value).to_h
      # データー型の変換
      row_hash[:date] = Date.parse(row_hash[:date]).to_date if row_hash[:date].present?
      row_hash[:number] = row_hash[:number].to_i if row_hash[:number].present?
      row_hash[:unit_price] = row_hash[:unit_price].gsub(/,/, "").to_f if row_hash[:unit_price].present?
      row_hash[:money_paid] = Date.parse(row_hash[:money_paid]).to_date if row_hash[:money_paid].present?
      row_hash[:rate] = row_hash[:rate].to_f if row_hash[:rate].present?        
      row_hash[:goods_amount] = row_hash[:goods_amount].to_i if row_hash[:goods_amount].present?
      
      current_user.stocks.create(row_hash)

    end
  end

  def file_close(file_name)
      File.delete('./tmp/stock/' + file_name.original_filename)
  end

  def goods_amount(stocks)
    stocks.each do |stock|
      ex_currency = current_user.currencies.find_by(name: stock.currency)
      if ex_currency.method == "外貨×為替レート"
        ex_goods_amount = stock.number * BigDecimal(stock.unit_price.to_s).round(2) * stock.rate
        stock.goods_amount = BigDecimal(ex_goods_amount.to_s).round(0)
      else
        ex_goods_amount = stock.number * BigDecimal(stock.unit_price.to_s).round(0) * stock.rate
        stock.goods_amount = BigDecimal(ex_goods_amount.to_s).round(0)      
      end
      stock.save
    end
  end

  def goods_amount_new_stock(stock)
    ex_currency = current_user.currencies.find_by(name: stock.currency)
    if ex_currency.method == "外貨×為替レート"
      ex_goods_amount = stock.number * BigDecimal(stock.unit_price.to_s).round(2) * stock.rate
      stock.goods_amount = BigDecimal(ex_goods_amount.to_s).round(0)
    else
      ex_goods_amount = stock.number * BigDecimal(stock.unit_price.to_s).round(0) * stock.rate
      stock.goods_amount = BigDecimal(ex_goods_amount.to_s).round(0)      
    end
  end

  def sku_import_to_stock
    #購入からFBA納品まで45日を見込む 
    base_difference = 45

    @stocks = current_user.stocks.where(sku: nil)
    @stocks.each do |stock|

      @check_stockaccepts = current_user.stockaccepts.where(asin: stock.asin)
      if @check_stockaccepts.any?
        @check_stockaccepts.each do |check_stockaccept| 
          if stock.number == check_stockaccept.quantity && base_difference > (check_stockaccept.date - stock.date)
            stock.sku = check_stockaccept.sku
            stock.save
            break
          end
        end
      end
    end

    @no_sku_stocks = current_user.stocks.where(sku: nil)
    @no_sku_stocks.each do |no_sku_stock|

      @check_stockaccepts = current_user.stockaccepts.where(asin: no_sku_stock.asin)
      if @check_stockaccepts.present? && @check_stockaccepts.count == 1
        no_sku_stock.sku = @check_stockaccepts.first.sku
        no_sku_stock.save
      elsif @check_stockaccepts.present? && @check_stockaccepts.count > 1
        check_sku = []
        @check_stockaccepts.each do |check_accept|
          if check_sku[0] != check_accept.sku
            check_sku << check_accept.sku
          end
        end
        if check_sku.count == 1
          no_sku_stock.sku = @check_stockaccepts.first.sku
          no_sku_stock.save
        end
      end
    end
  end
end
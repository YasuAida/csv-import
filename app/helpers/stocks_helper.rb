module StocksHelper
  def file_open(file_name)
      File.open('./tmp/stock/'+ file_name.original_filename, 'wb') do |file|
        file.write(file_name.read)
      end
  end
  
  def file_import_stock(file_name)
      # 先にDBのカラム名を用意
      @column = [:purchase_date, :asin, :goods_name, :number, :unit_price, :money_paid, :purchase_from, :currency, :sku, :rate, :goods_amount]
      
      CSV.foreach('./tmp/stock/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:purchase_date] = Date.parse(row_hash[:purchase_date]).to_date
        row_hash[:number] = row_hash[:number].to_i
        row_hash[:unit_price] = row_hash[:unit_price].gsub(/,/, "").to_f
        row_hash[:money_paid] = Date.parse(row_hash[:money_paid]).to_date
        
        Stock.create(row_hash)

      end
  end

  def file_close(file_name)
      File.delete('./tmp/stock/' + file_name.original_filename)
  end
  
  def rate_import_to_stock(stocks)
    stocks.each do |stock|
      ex_currency = Currency.find_by(name: stock.currency)
      if stock.currency == "円" then
        stock.rate = 1
        
      elsif ex_currency.method == "外貨÷100×為替レート"
        check_exchange = Exchange.find_by(date: stock.purchase_date, country: stock.currency)
        #存在しなければcheck_exchangeにはnilが入るので
          unless check_exchange.nil?
            stock.rate = BigDecimal(check_exchange.rate.to_s).round(2) /100
          else
            target_date = (stock.purchase_date) -1            
            while check_exchange.nil? do
              check_exchange = Exchange.find_by(date: target_date, country: stock.currency)  
              target_date = (target_date) -1
            end
            stock.rate = BigDecimal(check_exchange.rate.to_s).round(2) /100            
          end
          
      elsif ex_currency.method == "外貨×100÷為替レート"
        check_exchange = Exchange.find_by(date: stock.purchase_date, country: stock.currency)
        #存在しなければcheck_exchangeにはnilが入るので
          unless check_exchange.nil?
            check_rate = 1 / (check_exchange.rate) * 100
            stock.rate = BigDecimal(check_rate.to_s).round(4)
          else
            target_date = (stock.purchase_date) -1            
            while check_exchange.nil? do
              check_exchange = Exchange.find_by(date: target_date, country: stock.currency)  
              target_date = (target_date) -1
            end
            check_rate = 1 / (check_exchange.rate) * 100
            stock.rate = BigDecimal(check_rate.to_s).round(4)       
          end            
      else
        check_exchange = Exchange.find_by(date: stock.purchase_date, country: stock.currency)
        #存在しなければcheck_exchangeにはnilが入るので
          unless check_exchange.nil?
            stock.rate = BigDecimal(check_exchange.rate.to_s).round(2)
          else
            target_date = (stock.purchase_date) -1            
            while check_exchange.nil? do
              check_exchange = Exchange.find_by(date: target_date, country: stock.currency)  
              target_date = (target_date) -1
            end
            stock.rate = BigDecimal(check_exchange.rate.to_s).round(2)   
          end
      end
      
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
    
  def sku_import_to_stock
    #購入からFBA納品まで45日を見込む 
    base_difference = 45

    @stocks = Stock.where(sku: nil)
    @stocks.each do |stock|

      @check_stockaccepts = Stockaccept.where(asin: stock.asin)
      if @check_stockaccepts.any?
        @check_stockaccepts.each do |check_stockaccept| 
          if stock.number == check_stockaccept.quantity && base_difference > check_stockaccept.date - stock.purchase_date 
            stock.sku = check_stockaccept.sku
            stock.save
            break
          end
        end
      end
    end

    @no_sku_stocks = Stock.where(sku: nil)
    @no_sku_stocks.each do |no_sku_stock|

      @check_stockaccepts = Stockaccept.where(asin: no_sku_stock.asin)
      if @check_stockaccepts.count == 1
        no_sku_stock.sku = @check_stockaccepts.first.sku
        no_sku_stock.save
      else
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
  
  def rate_import_to_new_stock(stock)
    ex_currency = Currency.find_by(name: stock.currency)
      if stock.currency == "円" then
        stock.rate = 1
        
      elsif ex_currency.method == "外貨÷100×為替レート"
        check_exchange = Exchange.find_by(date: stock.purchase_date, country: stock.currency)
        #存在しなければcheck_exchangeにはnilが入るので
          unless check_exchange.nil?
            stock.rate = BigDecimal(check_exchange.rate.to_s).round(2) /100
          else
            target_date = (stock.purchase_date) -1            
            while check_exchange.nil? do
              check_exchange = Exchange.find_by(date: target_date, country: stock.currency)  
              target_date = (target_date) -1
            end
            stock.rate = BigDecimal(check_exchange.rate.to_s).round(2) /100            
          end
          
      elsif ex_currency.method == "外貨×100÷為替レート"
        check_exchange = Exchange.find_by(date: stock.purchase_date, country: stock.currency)
        #存在しなければcheck_exchangeにはnilが入るので
          unless check_exchange.nil?
            check_rate = 1 / (check_exchange.rate) * 100
            stock.rate = BigDecimal(check_rate.to_s).round(4)
          else
            target_date = (stock.purchase_date) -1            
            while check_exchange.nil? do
              check_exchange = Exchange.find_by(date: target_date, country: stock.currency)  
              target_date = (target_date) -1
            end
            check_rate = 1 / (check_exchange.rate) * 100
            stock.rate = BigDecimal(check_rate.to_s).round(4)       
          end            
      else
        check_exchange = Exchange.find_by(date: stock.purchase_date, country: stock.currency)
        #存在しなければcheck_exchangeにはnilが入るので
          unless check_exchange.nil?
            stock.rate = BigDecimal(check_exchange.rate.to_s).round(2)
          else
            target_date = (stock.purchase_date) -1            
            while check_exchange.nil? do
              check_exchange = Exchange.find_by(date: target_date, country: stock.currency)  
              target_date = (target_date) -1
            end
            stock.rate = BigDecimal(check_exchange.rate.to_s).round(2)   
          end
      end
      
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
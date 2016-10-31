module StocksHelper
  def file_open(file_name)
      File.open('./tmp/stock/'+ file_name.original_filename, 'wb') do |file|
        file.write(file_name.read)
      end
  end
  
  def file_import_stock(file_name)
      # 先にDBのカラム名を用意
      @column = [:date, :asin, :goods_name, :number, :unit_price, :money_paid, :purchase_from, :currency, :sku, :rate]
      
      CSV.foreach('./tmp/stock/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
        # rowの値のみを配列化
        row_value = row.to_h.values
        # Zipで合体後にハッシュ化
        row_hash = @column.zip(row_value).to_h
        # データー型の変換
        row_hash[:date] = Date.parse(row_hash[:date]).to_date
        row_hash[:number] = row_hash[:number].to_i
        row_hash[:unit_price] = row_hash[:unit_price].gsub(/,/, "").to_f
        row_hash[:money_paid] = Date.parse(row_hash[:money_paid]).to_date
     
        Stock.create(row_hash)

      end
  end

  def file_close(file_name)
      File.delete('./tmp/stock/' + file_name.original_filename)
  end
  
  def rate_import_to_stock
    @stocks = Stock.all
    @stocks.each do |stock|
      check_exchange = Exchange.find_by(date: stock.date, country: stock.currency)
      #存在しなければbはnilが入るので
      unless check_exchange.nil?
        stock.rate = check_exchange.rate
      end
      stock.save
    end
  end
    
  def sku_import_to_stock
    @stocks = Stock.all
    #購入からFBA納品まで20日を見込む 
    base_difference = 20
    
    @stocks.each do |stock|
binding.pry
      check_asin = Stockaccept.find_by(asin: stock.asin, quantity: stock.number)
      #存在しなければbはnilが入るので      
      if check_asin.present? && base_difference < check_asin.date - stock.date 
        stock.sku = check_asin.sku
      end
      stock.save
    end
  end
end
module ApplicationHelper
  def rate_import(objects)
    objects.each do |object|
      ex_currency = current_user.currencies.find_by(name: object.currency)
      if object.currency == "円" then
        object.rate = 1
        
      elsif ex_currency.method == "外貨÷100×為替レート"
        check_exchange = current_user.exchanges.find_by(date: object.date, country: object.currency)
        #存在しなければcheck_exchangeにはnilが入るので
          unless check_exchange.nil?
            object.rate = BigDecimal(check_exchange.rate.to_s).round(2) /100
          else
            target_date = (object.date) -1            
            while check_exchange.nil? do
              check_exchange = current_user.exchanges.find_by(date: target_date, country: object.currency)  
              target_date = (target_date) -1
            end
            object.rate = BigDecimal(check_exchange.rate.to_s).round(2) /100            
          end
          
      elsif ex_currency.method == "外貨÷為替レート×100"
        check_exchange = current_user.exchanges.find_by(date: object.date, country: object.currency)
        #存在しなければcheck_exchangeにはnilが入るので
          unless check_exchange.nil?
            check_rate = 1 / (check_exchange.rate) * 100
            object.rate = BigDecimal(check_rate.to_s).round(4)
          else
            target_date = (object.date) -1            
            while check_exchange.nil? do
              check_exchange = current_user.exchanges.find_by(date: target_date, country: object.currency)  
              target_date = (target_date) -1
            end
            check_rate = 1 / (check_exchange.rate) * 100
            object.rate = BigDecimal(check_rate.to_s).round(4)       
          end            
      else
        check_exchange = current_user.exchanges.find_by(date: object.date, country: object.currency)
        #存在しなければcheck_exchangeにはnilが入るので
        unless check_exchange.nil?
          object.rate = BigDecimal(check_exchange.rate.to_s).round(2)
        else
          target_date = (object.date) -1            
          while check_exchange.nil? do
            check_exchange = current_user.exchanges.find_by(date: target_date, country: object.currency)  
            target_date = (target_date) -1
          end
          object.rate = BigDecimal(check_exchange.rate.to_s).round(2)   
        end
      end
      object.save
    end
  end
  
  def rate_import_new_object(object)
    ex_currency = current_user.currencies.find_by(name: object.currency)
    if object.currency == "円" then
      object.rate = 1
      
    elsif ex_currency.method == "外貨÷100×為替レート"
      check_exchange = current_user.exchanges.find_by(date: object.date, country: object.currency)
      #存在しなければcheck_exchangeにはnilが入るので
        unless check_exchange.nil?
          object.rate = BigDecimal(check_exchange.rate.to_s).round(2) /100
        else
          target_date = (object.date) -1            
          while check_exchange.nil? do
            check_exchange = current_user.exchanges.find_by(date: target_date, country: object.currency)  
            target_date = (target_date) -1
          end
          object.rate = BigDecimal(check_exchange.rate.to_s).round(2) /100            
        end
        
    elsif ex_currency.method == "外貨÷為替レート×100"
      check_exchange = current_user.exchanges.find_by(date: object.date, country: object.currency)
      #存在しなければcheck_exchangeにはnilが入るので
        unless check_exchange.nil?
          check_rate = 1 / (check_exchange.rate) * 100
          object.rate = BigDecimal(check_rate.to_s).round(4)
        else
          target_date = (object.date) -1            
          while check_exchange.nil? do
            check_exchange = current_user.exchanges.find_by(date: target_date, country: object.currency)  
            target_date = (target_date) -1
          end
          check_rate = 1 / (check_exchange.rate) * 100
          object.rate = BigDecimal(check_rate.to_s).round(4)       
        end            
    else
      check_exchange = current_user.exchanges.find_by(date: object.date, country: object.currency)
      #存在しなければcheck_exchangeにはnilが入るので
      unless check_exchange.nil?
        object.rate = BigDecimal(check_exchange.rate.to_s).round(2)
      else
        target_date = (object.date) -1            
        while check_exchange.nil? do
          check_exchange = current_user.exchanges.find_by(date: target_date, country: object.currency)  
          target_date = (target_date) -1
        end
        object.rate = BigDecimal(check_exchange.rate.to_s).round(2)   
      end
    end
    object.save  
  end
end

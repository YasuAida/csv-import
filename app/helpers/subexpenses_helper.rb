module SubexpensesHelper
  def rate_import_to_subexpense
    @subexpenses = Subexpense.all
    @subexpenses.each do |subexpense|
      ex_currency = Currency.find_by(name: subexpense.currency)
      if subexpense.currency == "円" then
        subexpense.rate = 1
        
      elsif ex_currency.method == "外貨÷100×為替レート"
        check_exchange = Exchange.find_by(date: subexpense.date, country: subexpense.currency)
        #存在しなければcheck_exchangeにはnilが入るので
          unless check_exchange.nil?
            subexpense.rate = BigDecimal(check_exchange.rate.to_s).round(2) /100
          else
            target_date = (subexpense.date) -1            
            while check_exchange.nil? do
              check_exchange = Exchange.find_by(date: target_date, country: subexpense.currency)  
              target_date = (target_date) -1
            end
            subexpense.rate = BigDecimal(check_exchange.rate.to_s).round(2) /100            
          end
          
      elsif ex_currency.method == "外貨×100÷為替レート"
        check_exchange = Exchange.find_by(date: subexpense.date, country: subexpense.currency)
        #存在しなければcheck_exchangeにはnilが入るので
          unless check_exchange.nil?
            check_rate = 1 / (check_exchange.rate) * 100
            subexpense.rate = BigDecimal(check_rate.to_s).round(4)
          else
            target_date = (subexpense.date) -1            
            while check_exchange.nil? do
              check_exchange = Exchange.find_by(date: target_date, country: subexpense.currency)  
              target_date = (target_date) -1
            end
            check_rate = 1 / (check_exchange.rate) * 100
            subexpense.rate = BigDecimal(check_rate.to_s).round(4)       
          end            
      else
        check_exchange = Exchange.find_by(date: subexpense.date, country: subexpense.currency)
        #存在しなければcheck_exchangeにはnilが入るので
          unless check_exchange.nil?
            subexpense.rate = BigDecimal(check_exchange.rate.to_s).round(2)
          else
            target_date = (subexpense.date) -1            
            while check_exchange.nil? do
              check_exchange = Exchange.find_by(date: target_date, country: subexpense.currency)  
              target_date = (target_date) -1
            end
            subexpense.rate = BigDecimal(check_exchange.rate.to_s).round(2)   
          end
      end  
      subexpense.save
    end
  end
end

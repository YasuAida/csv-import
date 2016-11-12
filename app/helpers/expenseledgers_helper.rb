module ExpenseledgersHelper
  def rate_import_to_expense(expenseledger)
    ex_currency = Currency.find_by(name: expenseledger.currency)
    if expenseledger.currency == "円" then
      expenseledger.rate = 1
        
    elsif ex_currency.method == "外貨÷100×為替レート"
      check_exchange = Exchange.find_by(date: expenseledger.purchase_date, country: expenseledger.currency)
      #存在しなければcheck_exchangeにはnilが入るので
      unless check_exchange.nil?
        expenseledger.rate = BigDecimal(check_exchange.rate.to_s).round(2) /100
      else
        target_date = (expenseledger.purchase_date) -1            
        while check_exchange.nil? do
          check_exchange = Exchange.find_by(date: target_date, country: expenseledger.currency)  
          target_date = (target_date) -1
        end
        expenseledger.rate = BigDecimal(check_exchange.rate.to_s).round(2) /100            
      end
      
    elsif ex_currency.method == "外貨×100÷為替レート"
      check_exchange = Exchange.find_by(date: expenseledger.purchase_date, country: expenseledger.currency)
      #存在しなければcheck_exchangeにはnilが入るので
      unless check_exchange.nil?
        check_rate = 1 / (check_exchange.rate) * 100
        expenseledger.rate = BigDecimal(check_rate.to_s).round(4)
      else
        target_date = (expenseledger.purchase_date) -1            
        while check_exchange.nil? do
          check_exchange = Exchange.find_by(date: target_date, country: expenseledger.currency)  
          target_date = (target_date) -1
        end
        check_rate = 1 / (check_exchange.rate) * 100
        expenseledger.rate = BigDecimal(check_rate.to_s).round(4)       
      end            
    else
      check_exchange = Exchange.find_by(date: expenseledger.purchase_date, country: expenseledger.currency)
      #存在しなければcheck_exchangeにはnilが入るので
      unless check_exchange.nil?
        expenseledger.rate = BigDecimal(check_exchange.rate.to_s).round(2)
      else
        target_date = (expenseledger.purchase_date) -1            
        while check_exchange.nil? do
          check_exchange = Exchange.find_by(date: target_date, country: expenseledger.currency)  
          target_date = (target_date) -1
        end
        expenseledger.rate = BigDecimal(check_exchange.rate.to_s).round(2)   
      end
    end
    expenseledger.save
  end
end

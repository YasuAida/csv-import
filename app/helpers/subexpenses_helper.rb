module SubexpensesHelper
  def rate_import_to_subexpense
    @subexpenses = Subexpense.all
    @subexpenses.each do |subexpense|
      check_exchange = Exchange.find_by(date: subexpense.date, country: subexpense.currency)
      #存在しなければbはnilが入るので
      unless check_exchange.nil?
        subexpense.rate = check_exchange.rate
      end  
      subexpense.save
    end
  end
end

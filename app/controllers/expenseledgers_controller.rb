class ExpenseledgersController < ApplicationController
  include ExpenseledgersHelper

  def index
    Sale.all.each do |sale|
      if sale.handling == "経費"
        expenseledger = Expenseledger.new(date: sale.date, content: sale.detail_of_payment, amount: (sale.amount * -1), money_paid: sale.money_receive, purchase_from: "Amazon", currency: "円")
        expenseledger.save
        
        #為替レートの付与
        rate_import_to_expense(expenseledger)
        
        ex_grandtotal = expenseledger.amount * expenseledger.rate 
        expenseledger.grandtotal = BigDecimal(ex_grandtotal.to_s).round(2) 
      end
    end
    @expenseledgers = Expenseledger.all
  end
end

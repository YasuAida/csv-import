class FinancialStatementsController < ApplicationController
  def index
    @periods = Period.all
    @pl_accounts = Account.where(bs_pl: "ＰＬ")
    @bs_accounts = Account.where(bs_pl: "ＢＳ")    
    
    @periods.each do |period|
      @pl_accounts.each do |account|    
        @pl_debit_ledgers = Generalledger.where(debit_account: account.account)
        debit_total_amount = @pl_debit_ledgers.where(date: period.period_start..period.period_end).sum(:amount)
        @pl_credit_ledgers = Generalledger.where(credit_account: account.account)
        credit_total_amount = @pl_credit_ledgers.where(date: period.period_start..period.period_end).sum(:amount)
        total_amount = debit_total_amount - credit_total_amount
        
        if account.debit_credit == "借方"
          balance = total_amount
        else
          balance = total_amount * -1
        end
        
        financial_statement = FinancialStatement.new(period_start: period.period_start)
        financial_statement.monthly_yearly = period.monthly_yearly
        financial_statement.account = account.account
        financial_statement.amount = balance
        financial_statement.save
      end
    end

    @periods.each do |period|
      @bs_accounts.each do |account|    
        @bs_debit_ledgers = Generalledger.where(debit_account: account.account)
        debit_total_amount = @bs_debit_ledgers.where(date: Period.first.period_start..period.period_end).sum(:amount)
        @bs_credit_ledgers = Generalledger.where(credit_account: account.account)
        credit_total_amount = @bs_credit_ledgers.where(date: Period.first.period_start..period.period_end).sum(:amount)
        total_amount = debit_total_amount - credit_total_amount
        
        if account.debit_credit == "借方"
          balance = total_amount
        else
          balance = total_amount * -1
        end
        
        financial_statement = FinancialStatement.new(period_start: period.period_start)
        financial_statement.monthly_yearly = period.monthly_yearly
        financial_statement.account = account.account
        financial_statement.amount = balance
        financial_statement.save
      end
    end
    
    render 'pl'
  end
  
  def bs
    @show_period = Period.new
    
    if params[:period].present? && params[:period][:monthly_yearly].present?
      @show_periods = Period.where(monthly_yearly: params[:period][:monthly_yearly]).page(params[:page])
    else
      @show_periods = Period.where(monthly_yearly: "月次").page(params[:page])      
    end
    
    @bs_accounts = Account.where(bs_pl: "ＢＳ")

  end
  
  def pl
    @show_period = Period.new
    
    if params[:period].present? && params[:period][:monthly_yearly].present?
      @show_periods = Period.where(monthly_yearly: params[:period][:monthly_yearly]).page(params[:page])
    else
      @show_periods = Period.where(monthly_yearly: "月次").page(params[:page])     
    end
    
    @pl_accounts = Account.where(bs_pl: "ＰＬ")
    
  end
end
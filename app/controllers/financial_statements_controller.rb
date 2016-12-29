class FinancialStatementsController < ApplicationController
  def index
    @periods = Period.all
    @pl_accounts = Account.where(bs_pl: "ＰＬ")
    @sale_accounts = Account.where(bs_pl: "ＰＬ", display_position: "売上高" )
    @cgs_accounts = Account.where(bs_pl: "ＰＬ", display_position: "売上原価" )
    @sga_accounts = Account.where(bs_pl: "ＰＬ", display_position: "販売管理費" )
    @other_accounts = Account.where(bs_pl: "ＰＬ", display_position: "営業外損益" ) 
    @bs_accounts = Account.where(bs_pl: "ＢＳ")
    @asset_accounts = Account.where(bs_pl: "ＢＳ", display_position: "資産")
    @liability_accounts = Account.where(bs_pl: "ＢＳ", display_position: "負債")
    @capital_accounts = Account.where(bs_pl: "ＢＳ", display_position: "純資産")
    
    @periods.each do |period|
    #ＰＬ科目ごとの集計  
      @pl_accounts.each do |pl_account|    
        @pl_debit_ledgers = Generalledger.where(debit_account: pl_account.account, date: period.period_start..period.period_end)
        debit_total_amount = @pl_debit_ledgers.sum(:amount)
        @pl_credit_ledgers = Generalledger.where(credit_account: pl_account.account, date: period.period_start..period.period_end)
        credit_total_amount = @pl_credit_ledgers.sum(:amount)
        total_amount = debit_total_amount - credit_total_amount
        
        if pl_account.debit_credit == "借方"
          balance = total_amount
        else
          balance = total_amount * -1
        end
        
        financial_statement = FinancialStatement.new(period_start: period.period_start)
        financial_statement.monthly_yearly = period.monthly_yearly
        financial_statement.account = pl_account.account
        financial_statement.amount = balance
        
        if financial_statement.save        
        else 
          old_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: pl_account.account)
          old_data.update(amount: financial_statement.amount) if old_data  
        end
      end
    #売上高の集計      
      balance = 0
      @pl_accounts.where(display_position: "売上高" ).each do |sale_account|    
        @sale_debit_ledgers = Generalledger.where(debit_account: sale_account.account, date: period.period_start..period.period_end)
        debit_total_amount = @sale_debit_ledgers.sum(:amount)
        @sale_credit_ledgers = Generalledger.where(credit_account: sale_account.account, date: period.period_start..period.period_end)
        credit_total_amount = @sale_credit_ledgers.sum(:amount)
        balance += debit_total_amount - credit_total_amount
      end        
      financial_statement = FinancialStatement.new(period_start: period.period_start)
      financial_statement.monthly_yearly = period.monthly_yearly
      financial_statement.account = "売上高合計"
      financial_statement.amount = balance * -1
     
      if financial_statement.save        
      else 
        old_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "売上高合計")
        old_data.update(amount: financial_statement.amount) if old_data  
      end
    #売上原価の集計         
      balance = 0
      @pl_accounts.where(display_position: "売上原価" ).each do |cgs_account|    
        @cgs_debit_ledgers = Generalledger.where(debit_account: cgs_account.account, date: period.period_start..period.period_end)
        debit_total_amount = @cgs_debit_ledgers.sum(:amount)
        @cgs_credit_ledgers = Generalledger.where(credit_account: cgs_account.account, date: period.period_start..period.period_end)
        credit_total_amount = @cgs_credit_ledgers.sum(:amount)
        balance += debit_total_amount - credit_total_amount
      end        
      financial_statement = FinancialStatement.new(period_start: period.period_start)
      financial_statement.monthly_yearly = period.monthly_yearly
      financial_statement.account = "売上原価合計"
      financial_statement.amount = balance
           
      if financial_statement.save        
      else 
        old_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "売上原価合計")
        old_data.update(amount: financial_statement.amount) if old_data  
      end
    #売上総利益の計算
      financial_statement = FinancialStatement.new(period_start: period.period_start)
      financial_statement.monthly_yearly = period.monthly_yearly
      financial_statement.account = "売上総利益"
      sales_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "売上高合計")
      cgs_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "売上原価合計")
      financial_statement.amount = sales_data.amount - cgs_data.amount
      
      if financial_statement.save        
      else 
        old_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "売上総利益")
        old_data.update(amount: financial_statement.amount) if old_data  
      end     
    #販売管理費の集計
      balance = 0
      @pl_accounts.where(display_position: "販売管理費" ).each do |sga_account|    
        @sga_debit_ledgers = Generalledger.where(debit_account: sga_account.account, date: period.period_start..period.period_end)
        debit_total_amount = @sga_debit_ledgers.sum(:amount)
        @sga_credit_ledgers = Generalledger.where(credit_account: sga_account.account, date: period.period_start..period.period_end)
        credit_total_amount = @sga_credit_ledgers.sum(:amount)
        balance += debit_total_amount - credit_total_amount
      end        
      financial_statement = FinancialStatement.new(period_start: period.period_start)
      financial_statement.monthly_yearly = period.monthly_yearly
      financial_statement.account = "販売管理費合計"
      financial_statement.amount = balance
     
      if financial_statement.save        
      else 
        old_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "販売管理費合計")
        old_data.update(amount: financial_statement.amount) if old_data  
      end
    #営業利益の計算
      financial_statement = FinancialStatement.new(period_start: period.period_start)
      financial_statement.monthly_yearly = period.monthly_yearly
      financial_statement.account = "営業利益"
      gross_profit_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "売上総利益")
      sga_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "販売管理費合計")
      financial_statement.amount = gross_profit_data.amount - sga_data.amount
      
      if financial_statement.save        
      else 
        old_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "営業利益")
        old_data.update(amount: financial_statement.amount) if old_data  
      end
    #営業外損益の集計
      balance = 0
      @pl_accounts.where(display_position: "営業外損益" ).each do |other_account|    
        @other_debit_ledgers = Generalledger.where(debit_account: other_account.account, date: period.period_start..period.period_end)
        debit_total_amount = @other_debit_ledgers.sum(:amount)
        @other_credit_ledgers = Generalledger.where(credit_account: other_account.account, date: period.period_start..period.period_end)
        credit_total_amount = @other_credit_ledgers.sum(:amount)
        balance += debit_total_amount - credit_total_amount
      end        
      financial_statement = FinancialStatement.new(period_start: period.period_start)
      financial_statement.monthly_yearly = period.monthly_yearly
      financial_statement.account = "営業外損益合計"
      financial_statement.amount = balance
     
      if financial_statement.save        
      else 
        old_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "営業外損益合計")
        old_data.update(amount: financial_statement.amount) if old_data  
      end        
    #税前利益の計算
      financial_statement = FinancialStatement.new(period_start: period.period_start)
      financial_statement.monthly_yearly = period.monthly_yearly
      financial_statement.account = "税前利益"
      operating_profit_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "営業利益")
      other_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "営業外損益合計")
      financial_statement.amount = operating_profit_data.amount - other_data.amount
      
      if financial_statement.save        
      else 
        old_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "税前利益")
        old_data.update(amount: financial_statement.amount) if old_data  
      end
    end
    
    @periods.each do |period|
    #ＢＳ科目ごとの集計
      @bs_accounts.each do |bs_account|    
        @bs_debit_ledgers = Generalledger.where(debit_account: bs_account.account, date: Period.first.period_start..period.period_end)
        debit_total_amount = @bs_debit_ledgers.sum(:amount)
        @bs_credit_ledgers = Generalledger.where(credit_account: bs_account.account, date: Period.first.period_start..period.period_end)
        credit_total_amount = @bs_credit_ledgers.sum(:amount)
        total_amount = debit_total_amount - credit_total_amount
        
        if bs_account.debit_credit == "借方"
          balance = total_amount
        else
          balance = total_amount * -1
        end
        
        financial_statement = FinancialStatement.new(period_start: period.period_start)
        financial_statement.monthly_yearly = period.monthly_yearly
        financial_statement.account = bs_account.account
        financial_statement.amount = balance
        
        if financial_statement.save
        else 
          old_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: bs_account.account)
          old_data.update(amount: financial_statement.amount) if old_data  
        end
      end
    #資産の集計      
      balance = 0
      @bs_accounts.where(display_position: "資産" ).each do |asset_account|  
        @asset_debit_ledgers = Generalledger.where(debit_account: asset_account.account, date: Period.first.period_start..period.period_end)
        debit_total_amount = @asset_debit_ledgers.sum(:amount)
        @asset_credit_ledgers = Generalledger.where(credit_account: asset_account.account, date: Period.first.period_start..period.period_end)
        credit_total_amount = @asset_credit_ledgers.sum(:amount)
        balance += debit_total_amount - credit_total_amount
      end        
      financial_statement = FinancialStatement.new(period_start: period.period_start)
      financial_statement.monthly_yearly = period.monthly_yearly
      financial_statement.account = "資産合計"
      financial_statement.amount = balance
     
      if financial_statement.save        
      else 
        old_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "資産合計")
        old_data.update(amount: financial_statement.amount) if old_data  
      end      
    #負債の集計      
      balance = 0
      @bs_accounts.where(display_position: "負債" ).each do |liability_account|    
        @liability_debit_ledgers = Generalledger.where(debit_account: liability_account.account, date: Period.first.period_start..period.period_end)
        debit_total_amount = @liability_debit_ledgers.sum(:amount)
        @liability_credit_ledgers = Generalledger.where(credit_account: liability_account.account, date: Period.first.period_start..period.period_end)
        credit_total_amount = @liability_credit_ledgers.sum(:amount)
        balance += debit_total_amount - credit_total_amount
      end        
      financial_statement = FinancialStatement.new(period_start: period.period_start)
      financial_statement.monthly_yearly = period.monthly_yearly
      financial_statement.account = "負債合計"
      financial_statement.amount = balance * -1
     
      if financial_statement.save        
      else 
        old_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "負債合計")
        old_data.update(amount: financial_statement.amount) if old_data  
      end
    
    #剰余金の集計
      balance = 0
      financial_statement = FinancialStatement.new(period_start: period.period_start)
      financial_statement.monthly_yearly = period.monthly_yearly
      financial_statement.account = "剰余金"
      @profit_before_taxes = FinancialStatement.where(period_start: Period.first.period_start..period.period_start, monthly_yearly: period.monthly_yearly, account: "税前利益") 
      @profit_before_taxes.each do |profit|
        balance += profit.amount
      end
      financial_statement.amount = balance
     
      if financial_statement.save        
      else 
        old_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "剰余金")
        old_data.update(amount: financial_statement.amount) if old_data  
      end      

    #純資産の集計      
      balance = 0
      @bs_accounts.where(display_position: "純資産" ).each do |capital_account|    
        @capital_debit_ledgers = Generalledger.where(debit_account: capital_account.account, date: Period.first.period_start..period.period_end)
        debit_total_amount = @capital_debit_ledgers.sum(:amount)
        @capital_credit_ledgers = Generalledger.where(credit_account: capital_account.account, date: Period.first.period_start..period.period_end)
        credit_total_amount = @capital_credit_ledgers.sum(:amount)
        @capital_debit_FS =FinancialStatement.where(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "剰余金")
        capital_surplus_amount = @capital_debit_FS.sum(:amount)
        balance += debit_total_amount - credit_total_amount - capital_surplus_amount
      end        
      financial_statement = FinancialStatement.new(period_start: period.period_start)
      financial_statement.monthly_yearly = period.monthly_yearly
      financial_statement.account = "純資産合計"
      financial_statement.amount = balance * -1
     
      if financial_statement.save        
      else 
        old_data = FinancialStatement.find_by(period_start: period.period_start, monthly_yearly: period.monthly_yearly, account: "純資産合計")
        old_data.update(amount: financial_statement.amount) if old_data  
      end
    end
    
    @show_period = Period.new
    @show_periods = Period.where(monthly_yearly: "月次")
    render 'pl'
  end
  
  def bs
    @show_period = Period.new
    
    if params[:period].present? && params[:period][:monthly_yearly].present?
      @show_periods = Period.where(monthly_yearly: params[:period][:monthly_yearly])
    else
      @show_periods = Period.where(monthly_yearly: "月次")      
    end
    
    @bs_accounts = Account.where(bs_pl: "ＢＳ")
    @asset_accounts = Account.where(bs_pl: "ＢＳ", display_position: "資産")
    @liability_accounts = Account.where(bs_pl: "ＢＳ", display_position: "負債")
    @capital_accounts = Account.where(bs_pl: "ＢＳ", display_position: "純資産")
  end
  
  def pl
    @show_period = Period.new
    
    if params[:period].present? && params[:period][:monthly_yearly].present?
      @show_periods = Period.where(monthly_yearly: params[:period][:monthly_yearly])
    else
      @show_periods = Period.where(monthly_yearly: "月次")     
    end
    
    @pl_accounts = Account.where(bs_pl: "ＰＬ")
    @sale_accounts = Account.where(bs_pl: "ＰＬ", display_position: "売上高" )
    @cgs_accounts = Account.where(bs_pl: "ＰＬ", display_position: "売上原価" )
    @sga_accounts = Account.where(bs_pl: "ＰＬ", display_position: "販売管理費" )
    @other_pl_accounts = Account.where(bs_pl: "ＰＬ", display_position: "営業外損益" )   
  end
end
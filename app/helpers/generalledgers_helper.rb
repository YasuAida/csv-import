module GeneralledgersHelper
    
  def import_from_pladmins(journalpatterns)
    @pladmins = Pladmin.all

    #「損益管理シート」売上計上  
    @pladmins.each do |pladmin|
      g_ledger = Generalledger.new(date: pladmin.date)
      find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "売上")
      g_ledger.debit_account = find_pattern.debit_account
      g_ledger.debit_subaccount = pladmin.money_receive.to_s
      g_ledger.debit_taxcode = find_pattern.debit_taxcode
      g_ledger.credit_account = find_pattern.credit_account
      g_ledger.credit_subaccount = pladmin.sku
      g_ledger.credit_taxcode = find_pattern.credit_taxcode
      g_ledger.content = pladmin.goods_name
      g_ledger.trade_company = pladmin.sale_place
      g_ledger.amount = pladmin.sale_amount
    end
    
    #「損益管理シート」原価（手数料）計上  
    @pladmins.each do |pladmin|
      g_ledger = Generalledger.new(date: pladmin.date)
      find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "原価（手数料）")
      g_ledger.debit_account = find_pattern.debit_account
      g_ledger.debit_subaccount = pladmin.sku
      g_ledger.debit_taxcode = find_pattern.debit_taxcode
      g_ledger.credit_account = find_pattern.credit_account
      g_ledger.credit_subaccount = pladmin.money_receive.to_s
      g_ledger.credit_taxcode = find_pattern.credit_taxcode
      g_ledger.content = pladmin.goods_name
      g_ledger.trade_company = pladmin.sale_place
      g_ledger.amount = pladmin.commission
    end
    
    #「損益管理シート」入金計上  
    @pladmins.each do |pladmin|
      g_ledger = Generalledger.new(date: pladmin.money_receive)
      find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "入金")
      g_ledger.debit_account = find_pattern.debit_account
      g_ledger.debit_subaccount = ""
      g_ledger.debit_taxcode = find_pattern.debit_taxcode
      g_ledger.credit_account = find_pattern.credit_account
      g_ledger.credit_subaccount = pladmin.money_receive.to_s
      g_ledger.credit_taxcode = find_pattern.credit_taxcode
      g_ledger.content = pladmin.goods_name
      g_ledger.trade_company = pladmin.sale_place
      g_ledger.amount = pladmin.sale_amount - pladmin.commission
    end
  end
  
  def import_from_stocks(journalpatterns)
    #「仕入台帳」仕入計上  
    @stocks.each do |stock|
      if stock.sold_date.nil?
        g_ledger = Generalledger.new(date: stock.purchase_date)
        #仕訳パターンを選ぶ
        if stock.purchase_date == stock.money_paid && stock.currency == "円"
          find_pattern = journalpatterns.find_by(ledger: "仕入台帳",pattern: "現金仕入（国内）")
        elsif stock.purchase_date == stock.money_paid && stock.currency != "円"
          find_pattern = journalpatterns.find_by(ledger: "仕入台帳",pattern: "現金仕入（海外）")
        elsif stock.purchase_date != stock.money_paid && stock.currency == "円" 
          find_pattern = journalpatterns.find_by(ledger: "仕入台帳",pattern: "掛仕入（国内）") 
        else
          find_pattern = journalpatterns.find_by(ledger: "仕入台帳",pattern: "掛仕入（海外）") 
        end
        
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = stock.sku
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        if find_pattern.credit_account == "買掛金"
          g_ledger.credit_subaccount = stock.money_paid
        else
          g_ledger.credit_subaccount = ""
        end
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = stock.goods_name
        g_ledger.trade_company = stock.purchase_from
        g_ledger.amount = stock.goods_amount
      end
    end
    
    #「仕入台帳」支払計上     
    @stocks.each do |stock|
      if stock.sold_date.nil?
        g_ledger = Generalledger.new(date: stock.money_paid)
        find_pattern = journalpatterns.find_by(ledger: "仕入台帳",pattern: "支払")
        
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = stock.money_paid
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = ""
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = stock.goods_name
        g_ledger.trade_company = stock.purchase_from
        g_ledger.amount = stock.goods_amount
      end
    end
  end
  
  def import_from_stockledgers(journalpatterns)
    #「商品有高帳」販売による売上原価計上     
    @stocks.each do |stock|
      if stock.sold_date.present?
        g_ledger = Generalledger.new(date: stock.sold_date)
        find_pattern = journalpatterns.find_by(ledger: "商品有高帳",pattern: "販売")
        
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = stock.sku
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = stock.sku
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = stock.goods_name
        g_ledger.trade_company = stock.purchase_from
        g_ledger.amount = stock.goods_amount
      end
    end      
  end
  
  def import_from_subexpenses(journalpatterns)
    #「付随費用」発生による計上
    
  end
end

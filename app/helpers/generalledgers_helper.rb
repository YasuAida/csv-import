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
      g_ledger.save

    #「損益管理シート」原価計上  
      g_ledger = Generalledger.new(date: pladmin.date)
      find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "原価")
      g_ledger.debit_account = find_pattern.debit_account
      g_ledger.debit_subaccount = pladmin.sku
      g_ledger.debit_taxcode = find_pattern.debit_taxcode
      g_ledger.credit_account = find_pattern.credit_account
      g_ledger.credit_subaccount = pladmin.sku
      g_ledger.credit_taxcode = find_pattern.credit_taxcode
      g_ledger.content = pladmin.goods_name
      g_ledger.trade_company = pladmin.sale_place
      g_ledger.amount = pladmin.cgs_amount
      g_ledger.save

    #「損益管理シート」原価（手数料）計上  
      order_num_sale = Sale.where(order_num: pladmin.order_num)
      if order_num_sale.present?  
        g_ledger = Generalledger.new(date: pladmin.date)
        find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "原価（Amazon手数料）")
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = pladmin.sku
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = pladmin.money_receive.to_s
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = pladmin.goods_name
        g_ledger.trade_company = pladmin.sale_place
        g_ledger.amount = pladmin.commission
        g_ledger.save
      else
        g_ledger = Generalledger.new(date: pladmin.date)
        find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "原価（掛払い手数料）")
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = pladmin.sku
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = pladmin.commission_pay_date.to_s
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = pladmin.goods_name
        g_ledger.trade_company = pladmin.sale_place
        g_ledger.amount = pladmin.commission
        g_ledger.save
      end
      
     #「損益管理シート」入金計上  
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
        g_ledger.save
    end
 
    #「損益管理シート」原価（送料）計上
    @shipping_cost_pladmins = Pladmin.where.not(shipping_cost: [nil,0])
    @shipping_cost_pladmins.each do |pladmin|
      g_ledger = Generalledger.new(date: pladmin.date)
      order_num_sale = Sale.where(order_num: pladmin.order_num)
      if order_num_sale.present? && order_num_sale.first.handling == "原価（送料）"
        find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "原価（Amazon送料）")
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = pladmin.sku
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = pladmin.money_receive.to_s
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = pladmin.goods_name
        g_ledger.trade_company = pladmin.sale_place
        g_ledger.amount = pladmin.shipping_cost
        g_ledger.save
      elsif pladmin.shipping_pay_date - pladmin.date > 15
        find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "原価（掛払い送料）")
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = pladmin.sku
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = pladmin.shipping_pay_date.to_s
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = pladmin.goods_name
        g_ledger.trade_company = pladmin.sale_place
        g_ledger.amount = pladmin.shipping_cost
        g_ledger.save
      else
        find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "原価（現金払い送料）")
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = pladmin.sku
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = ""
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = pladmin.goods_name
        g_ledger.trade_company = pladmin.sale_place
        g_ledger.amount = pladmin.shipping_cost
        g_ledger.save        
      end
    end

    #「損益管理シート」掛払い支払計上
    @commission_pay_pladmins = Pladmin.where.not(commission_pay_date: [0,nil])     
    @commission_pay_pladmins.each do |pladmin|
      g_ledger = Generalledger.new(date: pladmin.commission_pay_date)
      find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "掛払い支払")
      g_ledger.debit_account = find_pattern.debit_account
      g_ledger.debit_subaccount = pladmin.commission_pay_date
      g_ledger.debit_taxcode = find_pattern.debit_taxcode
      g_ledger.credit_account = find_pattern.credit_account
      g_ledger.credit_subaccount = ""
      g_ledger.credit_taxcode = find_pattern.credit_taxcode
      g_ledger.content = pladmin.goods_name
      g_ledger.trade_company = pladmin.sale_place
      g_ledger.amount = pladmin.commission
      g_ledger.save
    end
    @shipping_pay_pladmins = Pladmin.where(shipping_pay_date: [0,nil])    
    @shipping_pay_pladmins.each do |pladmin|
      if pladmin.shipping_pay_date - pladmin.date > 15
        g_ledger = Generalledger.new(date: pladmin.shipping_pay_date)
        find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "掛払い支払")
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = pladmin.shipping_pay_date
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = ""
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = pladmin.goods_name
        g_ledger.trade_company = pladmin.sale_place
        g_ledger.amount = pladmin.shipping_pay_date
        g_ledger.save
      end
    end    
  end
  
  def import_from_stocks(journalpatterns)
    #「仕入台帳」仕入計上
    @stocks = Stock.all
    @stocks.each do |stock|
      g_ledger = Generalledger.new(date: stock.date)
      #仕訳パターンを選ぶ
      if stock.date == stock.money_paid && stock.currency == "円"
        find_pattern = journalpatterns.find_by(ledger: "仕入台帳", pattern: "現金仕入（国内）")
      elsif stock.date == stock.money_paid && stock.currency != "円"
        find_pattern = journalpatterns.find_by(ledger: "仕入台帳", pattern: "現金仕入（海外）")
      elsif stock.date != stock.money_paid && stock.currency == "円" 
        find_pattern = journalpatterns.find_by(ledger: "仕入台帳", pattern: "掛仕入（国内）") 
      else
        find_pattern = journalpatterns.find_by(ledger: "仕入台帳", pattern: "掛仕入（海外）") 
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
      g_ledger.save
    end
    
    #「仕入台帳」掛払い支払計上     
    @stocks.each do |stock|
      if stock.date != stock.money_paid
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
        g_ledger.save
      end
    end
  end
  
  def import_from_stockledgers(journalpatterns)
    #「商品有高帳」FBAから商品を戻した場合
    @return_goods = ReturnGood.all  
    @return_goods.each do |return_good|
      if Stockledger.find_by(sku: return_good.old_sku, classification: "返還").present?
        @old_return_stockledger = Stockledger.find_by(sku: return_good.old_sku, classification: "返還") 
        g_ledger = Generalledger.new(date: @old_return_stockledger.transaction_date)
        find_pattern = journalpatterns.find_by(ledger: "商品有高帳",pattern: "FBAから商品を戻した場合")
        
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = return_good.new_sku
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = return_good.old_sku
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = @old_return_stockledger.goods_name
        stock_trade_company = Stock.find_by(sku: return_good.old_sku)
        g_ledger.trade_company = stock_trade_company.purchase_from
        g_ledger.amount = @old_return_stockledger.grandtotal * -1
        g_ledger.save
      end
    end
    
    #「商品有高帳」商品を廃棄した場合    
    @disposal_goods = ReturnGood.where(disposal: true)
    @disposal_goods.each do |disposal_good|
      if Stockledger.find_by(sku: disposal_good.new_sku, classification: "SKU付替").present?
        @disposal_stockledger = Stockledger.find_by(sku: disposal_good.new_sku, classification: "SKU付替")
        g_ledger = Generalledger.new(date: @disposal_stockledger.transaction_date)
        find_pattern = journalpatterns.find_by(ledger: "商品有高帳",pattern: "廃棄")
        
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = disposal_good.new_sku
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = disposal_good.new_sku
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = @disposal_stockledger.goods_name
        stock_trade_company = Stock.find_by(sku: disposal_good.old_sku)
        g_ledger.trade_company = stock_trade_company.purchase_from
        g_ledger.amount = @disposal_stockledger.grandtotal
        g_ledger.save
      end
    end    
  end
  
  def import_from_subexpenses(journalpatterns)
    @subexpenses = Subexpense.all     
    
    #「付随費用」発生による計上
    @subexpenses.each do |subexpense|
      g_ledger = Generalledger.new(date: subexpense.date)
      #仕訳パターンを選ぶ
      if subexpense.date == subexpense.money_paid && subexpense.currency == "円" && subexpense.item != "関税"
        find_pattern = journalpatterns.find_by(ledger: "付随費用", pattern: "現金払い（国内）")
      elsif subexpense.date == subexpense.money_paid && subexpense.currency != "円" && subexpense.item != "関税"
        find_pattern = journalpatterns.find_by(ledger: "付随費用", pattern: "現金払い（海外）")
      elsif subexpense.date != subexpense.money_paid && subexpense.currency == "円" && subexpense.item != "関税"
        find_pattern = journalpatterns.find_by(ledger: "付随費用", pattern: "掛払い（国内）") 
      elsif subexpense.date != subexpense.money_paid && subexpense.currency != "円" && subexpense.item != "関税"
        find_pattern = journalpatterns.find_by(ledger: "付随費用", pattern: "掛払い（海外）")
      elsif subexpense.date == subexpense.money_paid && subexpense.currency == "円" && subexpense.item == "関税"
        find_pattern = journalpatterns.find_by(ledger: "付随費用", pattern: "現金払い（関税）") 
      else
        find_pattern = journalpatterns.find_by(ledger: "付随費用", pattern: "掛払い（関税）") 
      end
      g_ledger.debit_account = find_pattern.debit_account
      g_ledger.debit_subaccount = subexpense.item
      g_ledger.debit_taxcode = find_pattern.debit_taxcode
      g_ledger.credit_account = find_pattern.credit_account
      if find_pattern.credit_account == "買掛金"
        g_ledger.credit_subaccount = subexpense.money_paid
      else
        g_ledger.credit_subaccount = ""
      end
      g_ledger.credit_taxcode = find_pattern.credit_taxcode
      targetgoods = subexpense.targetgood.gsub(/\"/, "").gsub(" ", "").gsub("[", "").gsub("]", "").split(",")
      targetstock = Stock.find(targetgoods[0].to_i)
      g_ledger.content = subexpense.date.strftime("%Y年 %m月 %d日") + subexpense.item + targetstock.goods_name
      g_ledger.trade_company = subexpense.purchase_from
      paid_amount = subexpense.amount * subexpense.rate 
      g_ledger.amount = BigDecimal(paid_amount.to_s).round(0)
      g_ledger.save
    end
    
    #「付随費用」配賦計上
    @subexpenses.each do |subexpense|
      g_ledger = Generalledger.new(date: subexpense.date)
      find_pattern = journalpatterns.find_by(ledger: "付随費用", pattern: "配賦")
      
      @target_stocks = subexpense.expense_relation_stocks.all
      @target_stocks.each do |target_stock|
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = target_stock.sku
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = subexpense.item
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = target_stock.sku + target_stock.goods_name
        g_ledger.trade_company = subexpense.purchase_from
        target_allocation = Allocationcost.find_by(stock_id: target_stock.id, title: subexpense.item )
        g_ledger.amount = target_allocation.allocation_amount
        g_ledger.save
      end
    end
    
    #「付随費用」掛払い支払計上
    @subexpenses.each do |subexpense|
      if subexpense.date != subexpense.money_paid
        g_ledger = Generalledger.new(date: subexpense.money_paid)
        find_pattern = journalpatterns.find_by(ledger: "付随費用", pattern: "支払")
        
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = subexpense.money_paid
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = ""
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = subexpense.goods_name
        g_ledger.trade_company = subexpense.purchase_from
        g_ledger.amount = subexpense.goods_amount
        g_ledger.save
      end
    end
  end  
  
  def import_from_expenseledgers(journalpatterns)
    #「経費帳」経費発生による計上
    @expenseledgers = Expenseledger.all
    @expenseledgers.each do |expenseledger|
      g_ledger = Generalledger.new(date: expenseledger.date)
      #仕訳パターンを選ぶ
      if expenseledger.date == expenseledger.money_paid && expenseledger.currency == "円" && expenseledger.purchase_from != "Amazon"
        find_pattern = journalpatterns.find_by(ledger: "経費帳", pattern: "現金払い（国内）")
      elsif expenseledger.date == expenseledger.money_paid && expenseledger.currency != "円"
        find_pattern = journalpatterns.find_by(ledger: "経費帳", pattern: "現金払い（海外）")
      elsif expenseledger.date != expenseledger.money_paid && expenseledger.currency == "円" || expenseledger.date == expenseledger.money_paid && expenseledger.currency == "円" &&  expenseledger.purchase_from == "Amazon"
        find_pattern = journalpatterns.find_by(ledger: "経費帳", pattern: "掛払い（国内）") 
      else
        find_pattern = journalpatterns.find_by(ledger: "経費帳", pattern: "掛払い（海外）") 
      end
      
      g_ledger.debit_account = expenseledger.account_name
      g_ledger.debit_subaccount = expenseledger.purchase_from
      g_ledger.debit_taxcode = find_pattern.debit_taxcode
      g_ledger.credit_account = find_pattern.credit_account
      if find_pattern.credit_account == "未払金"
        g_ledger.credit_subaccount = expenseledger.money_paid
      else
        g_ledger.credit_subaccount = ""
      end
      g_ledger.credit_taxcode = find_pattern.credit_taxcode
      g_ledger.content = expenseledger.content
      g_ledger.trade_company = expenseledger.purchase_from
      g_ledger.amount = expenseledger.grandtotal
      g_ledger.save
    end
    
    #「経費帳」掛払い支払計上
    @expenseledgers = Expenseledger.all
    @expenseledgers.each do |expenseledger|
      if expenseledger.date != expenseledger.money_paid
        g_ledger = Generalledger.new(date: expenseledger.money_paid)
        find_pattern = journalpatterns.find_by(ledger: "経費帳",pattern: "支払")
        
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = expenseledger.money_paid
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = ""
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = expenseledger.content
        g_ledger.trade_company = expenseledger.purchase_from
        g_ledger.amount = expenseledger.grandtotal
        g_ledger.save
      end
    end
  end

  #「振替台帳」から仕訳生成
  def import_from_vouchers
    @vouchers = Voucher.all
    @vouchers.each do |voucher|
      g_ledger = Generalledger.new(date: voucher.date)      
      g_ledger.debit_account = voucher.debit_account
      g_ledger.debit_subaccount = voucher.debit_subaccount
      g_ledger.debit_taxcode = voucher.debit_taxcode
      g_ledger.credit_account = voucher.credit_account
      g_ledger.credit_subaccount = voucher.credit_subaccount
      g_ledger.credit_taxcode = voucher.credit_taxcode
      g_ledger.amount = voucher.amount 
      g_ledger.content = voucher.content
      g_ledger.trade_company = voucher.trade_company
      g_ledger.save
    end    
  end
end

module GeneralledgersHelper
    
  def import_from_pladmins(journalpatterns)
    @pladmins = Pladmin.all
    
    #「損益管理シート」売上計上  
    @pladmins.each do |pladmin|
      find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "売上")
      g_ledger = Generalledger.new(date: pladmin.date)
      g_ledger.pladmin_id = pladmin.id
      g_ledger.debit_account = find_pattern.debit_account
      g_ledger.debit_subaccount = pladmin.money_receive.to_s
      g_ledger.debit_taxcode = find_pattern.debit_taxcode
      g_ledger.credit_account = find_pattern.credit_account
      g_ledger.credit_subaccount = pladmin.sku
      g_ledger.credit_taxcode = find_pattern.credit_taxcode
      g_ledger.content = pladmin.goods_name
      g_ledger.trade_company = pladmin.sale_place
      g_ledger.amount = pladmin.sale_amount
        
      if g_ledger.save
      else
        old_data = Generalledger.find_by(pladmin_id: pladmin.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
        old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
      end
      
    #「損益管理シート」原価計上
      
      find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "原価")
      g_ledger = Generalledger.new(date: pladmin.date)
      g_ledger.pladmin_id = pladmin.id
      g_ledger.debit_account = find_pattern.debit_account
      g_ledger.debit_subaccount = pladmin.sku
      g_ledger.debit_taxcode = find_pattern.debit_taxcode
      g_ledger.credit_account = find_pattern.credit_account
      g_ledger.credit_subaccount = pladmin.sku
      g_ledger.credit_taxcode = find_pattern.credit_taxcode
      g_ledger.content = pladmin.goods_name
      g_ledger.trade_company = pladmin.sale_place
      g_ledger.amount = pladmin.cgs_amount
      if g_ledger.save
      else
        old_data = Generalledger.find_by(pladmin_id: pladmin.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
        old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
      end

    #「損益管理シート」原価（手数料）計上  
      if pladmin.sale_place == "Amazon"
        find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "原価（Amazon手数料）")
        g_ledger = Generalledger.new(date: pladmin.date)
        g_ledger.pladmin_id = pladmin.id 
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = pladmin.sku
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = pladmin.money_receive.to_s
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = pladmin.goods_name
        g_ledger.trade_company = pladmin.sale_place
        g_ledger.amount = pladmin.commission
        if g_ledger.save
        else
          old_data = Generalledger.find_by(pladmin_id: pladmin.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
          old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
        end
      else
        find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "原価（掛払い手数料）")
        g_ledger = Generalledger.new(date: pladmin.date)
        g_ledger.pladmin_id = pladmin.id
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = pladmin.sku
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = pladmin.commission_pay_date.to_s
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = pladmin.goods_name
        g_ledger.trade_company = pladmin.sale_place
        g_ledger.amount = pladmin.commission
        if g_ledger.save
        else
          old_data = Generalledger.find_by(pladmin_id: pladmin.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
          old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
        end
      end
      
     #「損益管理シート」入金計上
      find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "入金")
      g_ledger = Generalledger.new(date: pladmin.money_receive)
      g_ledger.pladmin_id = pladmin.id
      g_ledger.debit_account = find_pattern.debit_account
      g_ledger.debit_subaccount = ""
      g_ledger.debit_taxcode = find_pattern.debit_taxcode
      g_ledger.credit_account = find_pattern.credit_account
      g_ledger.credit_subaccount = pladmin.money_receive.to_s
      g_ledger.credit_taxcode = find_pattern.credit_taxcode
      g_ledger.content = pladmin.goods_name
      g_ledger.trade_company = pladmin.sale_place
      
      if pladmin.sale_place == "Amazon" && pladmin.commission.present?
        g_ledger.amount = pladmin.sale_amount - pladmin.commission
      elsif pladmin.sale_place == "Amazon" && pladmin.commission.blank?
        g_ledger.amount = pladmin.sale_amount
      else
        g_ledger.amount = pladmin.sale_amount     
      end
      
      if g_ledger.save
      else
        old_data = Generalledger.find_by(pladmin_id: pladmin.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
        old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
      end
 
    #「損益管理シート」原価（送料）計上
      if pladmin.shipping_cost != nil && pladmin.shipping_cost != 0
        if pladmin.goods_name.present? && pladmin.goods_name.include?("マルチ発送分")
          find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "原価（Amazon送料）")
          g_ledger = Generalledger.new(date: pladmin.date)
          g_ledger.pladmin_id = pladmin.id
          g_ledger.debit_account = find_pattern.debit_account
          g_ledger.debit_subaccount = pladmin.sku
          g_ledger.debit_taxcode = find_pattern.debit_taxcode
          g_ledger.credit_account = find_pattern.credit_account
          g_ledger.credit_subaccount = pladmin.money_receive.to_s
          g_ledger.credit_taxcode = find_pattern.credit_taxcode
          g_ledger.content = pladmin.goods_name
          g_ledger.trade_company = "Amazon"
          g_ledger.amount = pladmin.shipping_cost
          if g_ledger.save
          else
            old_data = Generalledger.find_by(pladmin_id: pladmin.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
            old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
          end
        elsif pladmin.shipping_pay_date - pladmin.date > 15
          find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "原価（掛払い送料）")
          g_ledger = Generalledger.new(date: pladmin.date)
          g_ledger.pladmin_id = pladmin.id
          g_ledger.debit_account = find_pattern.debit_account
          g_ledger.debit_subaccount = pladmin.sku
          g_ledger.debit_taxcode = find_pattern.debit_taxcode
          g_ledger.credit_account = find_pattern.credit_account
          g_ledger.credit_subaccount = pladmin.shipping_pay_date.to_s
          g_ledger.credit_taxcode = find_pattern.credit_taxcode
          g_ledger.content = pladmin.goods_name
          g_ledger.trade_company = pladmin.sale_place
          g_ledger.amount = pladmin.shipping_cost
          if g_ledger.save
          else
            old_data = Generalledger.find_by(pladmin_id: pladmin.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
            old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
          end
        else
          find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "原価（現金払い送料）")
          g_ledger = Generalledger.new(date: pladmin.date)
          g_ledger.pladmin_id = pladmin.id
          g_ledger.debit_account = find_pattern.debit_account
          g_ledger.debit_subaccount = pladmin.sku
          g_ledger.debit_taxcode = find_pattern.debit_taxcode
          g_ledger.credit_account = find_pattern.credit_account
          g_ledger.credit_subaccount = ""
          g_ledger.credit_taxcode = find_pattern.credit_taxcode
          g_ledger.content = pladmin.goods_name
          g_ledger.trade_company = pladmin.sale_place
          g_ledger.amount = pladmin.shipping_cost
          if g_ledger.save
          else
            old_data = Generalledger.find_by(pladmin_id: pladmin.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
            old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
          end      
        end
      end
    
    #「損益管理シート」手数料支払計上 
      if pladmin.commission_pay_date != nil && pladmin.commission_pay_date != 0
        find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "掛払い支払")
        g_ledger = Generalledger.new(date: pladmin.commission_pay_date)
        g_ledger.pladmin_id = pladmin.id
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = pladmin.commission_pay_date
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = ""
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = pladmin.goods_name
        g_ledger.trade_company = pladmin.sale_place
        g_ledger.amount = pladmin.commission
        if g_ledger.save
        else
          old_data = Generalledger.find_by(pladmin_id: pladmin.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
          old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
        end
      end
    
    #「損益管理シート」マルチチャンネル発送分売掛金相殺および送料支払計上    
      if pladmin.shipping_pay_date != nil && pladmin.shipping_pay_date != 0
        if pladmin.goods_name.include?("マルチ発送分")    
          find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "Amazon送料相殺")
          g_ledger = Generalledger.new(date: pladmin.shipping_pay_date)
          g_ledger.pladmin_id = pladmin.id
          g_ledger.debit_account = find_pattern.debit_account
          g_ledger.debit_subaccount = pladmin.shipping_pay_date
          g_ledger.debit_taxcode = find_pattern.debit_taxcode
          g_ledger.credit_account = find_pattern.credit_account
          g_ledger.credit_subaccount = ""
          g_ledger.credit_taxcode = find_pattern.credit_taxcode
          g_ledger.content = pladmin.goods_name
          g_ledger.trade_company = "Amazon"
          g_ledger.amount = pladmin.shipping_cost
          if g_ledger.save
          else
            old_data = Generalledger.find_by(pladmin_id: pladmin.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
            old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
          end 
        elsif !pladmin.goods_name.include?("マルチ発送分") && pladmin.shipping_pay_date - pladmin.date > 15
          find_pattern = journalpatterns.find_by(ledger: "損益管理表",pattern: "掛払い支払")
          g_ledger = Generalledger.new(date: pladmin.shipping_pay_date)
          g_ledger.pladmin_id = pladmin.id
          g_ledger.debit_account = find_pattern.debit_account
          g_ledger.debit_subaccount = pladmin.shipping_pay_date
          g_ledger.debit_taxcode = find_pattern.debit_taxcode
          g_ledger.credit_account = find_pattern.credit_account
          g_ledger.credit_subaccount = ""
          g_ledger.credit_taxcode = find_pattern.credit_taxcode
          g_ledger.content = pladmin.goods_name
          g_ledger.trade_company = pladmin.sale_place
          g_ledger.amount = pladmin.shipping_cost
          if g_ledger.save
          else
            old_data = Generalledger.find_by(pladmin_id: pladmin.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
            old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
          end
        end
      end
    end
  end
  
  def import_from_stocks(journalpatterns)
    #「仕入台帳」仕入計上
    @stocks = Stock.all
    @stocks.each do |stock|
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
      g_ledger = Generalledger.new(date: stock.date)
      g_ledger.stock_id = stock.id      
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
      if g_ledger.save
      else
        old_data = Generalledger.find_by(stock_id: stock.id, date: g_ledger.date, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
        old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
      end
    
    #「仕入台帳」掛払い支払計上     
      if stock.date != stock.money_paid
        find_pattern = journalpatterns.find_by(ledger: "仕入台帳",pattern: "支払")
        g_ledger = Generalledger.new(date: stock.money_paid)
        g_ledger.stock_id = stock.id
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = stock.money_paid
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = ""
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = stock.goods_name
        g_ledger.trade_company = stock.purchase_from
        g_ledger.amount = stock.goods_amount
        if g_ledger.save
        else
          old_data = Generalledger.find_by(stock_id: stock.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
          old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
        end
      end
    end
  end
 
  def import_from_stockreturns(journalpatterns)
    #「仕入返品台帳」返品計上
    @stockreturns = Stockreturn.all
    @stockreturns.each do |stockreturn|
      #仕訳パターンを選ぶ
      if stockreturn.date == stockreturn.money_paid && stockreturn.currency == "円"
        find_pattern = journalpatterns.find_by(ledger: "仕入返品台帳", pattern: "現金仕入（国内）")
      elsif stockreturn.date == stockreturn.money_paid && stockreturn.currency != "円"
        find_pattern = journalpatterns.find_by(ledger: "仕入返品台帳", pattern: "現金仕入（海外）")
      elsif stockreturn.date != stockreturn.money_paid && stockreturn.currency == "円" 
        find_pattern = journalpatterns.find_by(ledger: "仕入返品台帳", pattern: "掛仕入（国内）") 
      else
        find_pattern = journalpatterns.find_by(ledger: "仕入返品台帳", pattern: "掛仕入（海外）") 
      end
      g_ledger = Generalledger.new(date: stockreturn.date)
      g_ledger.stockreturn_id = stockreturn.id
      g_ledger.debit_account = find_pattern.debit_account
      if find_pattern.debit_account == "買掛金"
        g_ledger.debit_subaccount = stockreturn.money_paid
      else
        g_ledger.debit_subaccount = ""
      end
      g_ledger.debit_taxcode = find_pattern.debit_taxcode
      g_ledger.credit_account = find_pattern.credit_account
      g_ledger.credit_subaccount = stockreturn.sku
      g_ledger.credit_taxcode = find_pattern.credit_taxcode
      g_ledger.content = stockreturn.goods_name
      g_ledger.trade_company = stockreturn.purchase_from
      g_ledger.amount = stockreturn.goods_amount
      if g_ledger.save
      else
        old_data = Generalledger.find_by(stockreturn_id: stockreturn.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
        old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
      end
    
    #「仕入返品台帳」払い戻し受領計上     
      if stockreturn.date != stockreturn.money_paid
        find_pattern = journalpatterns.find_by(ledger: "仕入返品台帳",pattern: "返金受領")
        g_ledger = Generalledger.new(date: stockreturn.money_paid)
        g_ledger.stockreturn_id = stockreturn.id        
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = ""
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = stockreturn.money_paid
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = stockreturn.goods_name
        g_ledger.trade_company = stockreturn.purchase_from
        g_ledger.amount = stockreturn.goods_amount
        if g_ledger.save
        else
          old_data = Generalledger.find_by(stockreturn_id: stockreturn.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
          old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
        end
      end
    end
  end
 
  def import_from_stockledgers(journalpatterns)
    #「商品有高帳」FBAから商品を戻した場合
    @return_goods = ReturnGood.all 
    @return_goods.each do |return_good|
      find_pattern = journalpatterns.find_by(ledger: "商品有高帳",pattern: "FBAから商品を戻した場合")
      g_ledger = Generalledger.new(date: return_good.date)
      g_ledger.return_good_id = return_good.id
      g_ledger.debit_account = find_pattern.debit_account
      g_ledger.debit_subaccount = return_good.new_sku
      g_ledger.debit_taxcode = find_pattern.debit_taxcode
      g_ledger.credit_account = find_pattern.credit_account
      g_ledger.credit_subaccount = return_good.old_sku
      g_ledger.credit_taxcode = find_pattern.credit_taxcode
      return_stock = Stock.find(return_good.stock_id)
      g_ledger.content = return_stock.goods_name
      g_ledger.trade_company = return_stock.purchase_from
      return_stockledger = Stockledger.find_by(stock_id: return_good.stock_id, classification: "返還")
      g_ledger.amount = return_stockledger.grandtotal * -1
      if g_ledger.save
      else
        old_data = Generalledger.find_by(return_good_id: return_good.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
        old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
      end
    end
    
    #「商品有高帳」商品を廃棄した場合    
    @disposal_goods = Disposal.all
    @disposal_goods.each do |disposal_good|
      if Stockledger.find_by(sku: disposal_good.sku, classification: "廃棄").present?
        find_pattern = journalpatterns.find_by(ledger: "商品有高帳",pattern: "廃棄")
        @disposal_stockledger = Stockledger.find_by(sku: disposal_good.sku, classification: "廃棄")
        g_ledger = Generalledger.new(date: @disposal_stockledger.transaction_date)
        g_ledger.disposal_id = disposal_good.id
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = disposal_good.sku
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = disposal_good.sku
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = @disposal_stockledger.goods_name
        if Stock.find_by(sku: disposal_good.sku).present?
          stock_trade_company = Stock.find_by(sku: disposal_good.sku)
        elsif ReturnGood.find_by(new_sku: disposal_good.sku).present?
          return_good = ReturnGood.find_by(new_sku: disposal_good.sku)
          stock_trade_company = Stock.find_by(sku: return_good.old_sku)
        end
        g_ledger.trade_company = stock_trade_company.purchase_from if stock_trade_company.purchase_from.present?
        g_ledger.amount = @disposal_stockledger.grandtotal * -1
        if g_ledger.save
        else
          old_data = Generalledger.find_by(disposal_id: disposal_good.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
          old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
        end
      end
    end    
  end
  
  def import_from_subexpenses(journalpatterns)
    @subexpenses = Subexpense.all    
    #「付随費用」発生による計上
    @subexpenses.each do |subexpense|
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
      g_ledger = Generalledger.new(date: subexpense.date)
      g_ledger.subexpense_id = subexpense.id
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
      if targetgoods.count == 1      
        g_ledger.content = subexpense.item + " ,仕入ID: " + targetstock.id.to_s + targetstock.goods_name
      else
        g_ledger.content = subexpense.item + " ,仕入ID: " + targetstock.id.to_s + targetstock.goods_name + "等"
      end
      g_ledger.trade_company = subexpense.purchase_from
      
      paid_amount = subexpense.amount * subexpense.rate
      g_ledger.amount = BigDecimal(paid_amount.to_s).round(0)    
      if g_ledger.save
      else
        old_data = Generalledger.find_by(subexpense_id: subexpense.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
        old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
      end

    #「付随費用」掛払い支払計上
      if subexpense.date != subexpense.money_paid
        find_pattern = journalpatterns.find_by(ledger: "付随費用", pattern: "支払")
        g_ledger = Generalledger.new(date: subexpense.money_paid)
        g_ledger.subexpense_id = subexpense.id          
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = subexpense.money_paid
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = ""
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = subexpense.item + " : "+ subexpense.expense_relation_stocks.first.goods_name
        g_ledger.trade_company = subexpense.purchase_from
        
        paid_amount = subexpense.amount * subexpense.rate 
        g_ledger.amount = BigDecimal(paid_amount.to_s).round(0)  
        if g_ledger.save
        else
          old_data = Generalledger.find_by(subexpense_id: subexpense.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
          old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
        end
      end   
    end
 
    #「付随費用」配賦計上
    @expense_relations = ExpenseRelation.all
    @expense_relations.each do |expense_relation|
      @target_subexpense = Subexpense.find(expense_relation.subexpense_id)
      @target_stock = Stock.find(expense_relation.stock_id)      
      @target_allocation = @target_stock.allocationcosts.find_by(title: @target_subexpense.item)
      find_pattern = journalpatterns.find_by(ledger: "付随費用", pattern: "配賦")      
      g_ledger = Generalledger.new(date: @target_subexpense.date)
      g_ledger.expense_relation_id = expense_relation.id
      g_ledger.debit_account = find_pattern.debit_account
      g_ledger.debit_subaccount = @target_stock.sku
      g_ledger.debit_taxcode = find_pattern.debit_taxcode
      g_ledger.credit_account = find_pattern.credit_account
      g_ledger.credit_subaccount = @target_allocation.title
      g_ledger.credit_taxcode = find_pattern.credit_taxcode
      g_ledger.content = "仕入ID: " + @target_stock.id.to_s + @target_stock.goods_name
      g_ledger.trade_company = @target_subexpense.purchase_from
      g_ledger.amount = @target_allocation.allocation_amount  
      if g_ledger.save
      else
        old_data = Generalledger.find_by(expense_relation_id: expense_relation.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
        old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
      end
    end
  end        
 
  
  def import_from_expenseledgers(journalpatterns)
    #「経費帳」経費発生による計上
    @expenseledgers = Expenseledger.all
    @expenseledgers.each do |expenseledger|
      if Account.where(account: expenseledger.account_name).blank?
         Account.create(account: expenseledger.account_name)
      end      
      
      if expenseledger.purchase_from == "Amazon"
        find_pattern = journalpatterns.find_by(ledger: "経費帳", pattern: "Amazon経費")   
        g_ledger = Generalledger.new(date: expenseledger.date)
        g_ledger.expenseledger_id = expenseledger.id  
        g_ledger.debit_account = expenseledger.account_name
        g_ledger.debit_subaccount = "Amazon"
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = expenseledger.money_paid
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = expenseledger.content
        g_ledger.trade_company = expenseledger.purchase_from
        g_ledger.amount = expenseledger.grandtotal
        if g_ledger.save
        else
          old_data = Generalledger.find_by(expenseledger_id: expenseledger.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
          old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
        end        
      else
        #仕訳パターンを選ぶ
        if expenseledger.date == expenseledger.money_paid && expenseledger.currency == "円" 
          find_pattern = journalpatterns.find_by(ledger: "経費帳", pattern: "現金払い（国内）")
        elsif expenseledger.date == expenseledger.money_paid && expenseledger.currency != "円"
          find_pattern = journalpatterns.find_by(ledger: "経費帳", pattern: "現金払い（海外）")
        elsif expenseledger.date != expenseledger.money_paid && expenseledger.currency == "円" 
          find_pattern = journalpatterns.find_by(ledger: "経費帳", pattern: "掛払い（国内）") 
        else
          find_pattern = journalpatterns.find_by(ledger: "経費帳", pattern: "掛払い（海外）") 
        end
        g_ledger = Generalledger.new(date: expenseledger.date) 
        g_ledger.expenseledger_id = expenseledger.id
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
        if g_ledger.save
        else
          old_data = Generalledger.find_by(expenseledger_id: expenseledger.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
          old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
        end
      end
    
    #「経費帳」Amazon経費売掛金相殺および掛払い支払計上
      if expenseledger.purchase_from == "Amazon"
        find_pattern = journalpatterns.find_by(ledger: "経費帳",pattern: "Amazon経費相殺")        
        g_ledger = Generalledger.new(date: expenseledger.money_paid) 
        g_ledger.expenseledger_id = expenseledger.id
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = expenseledger.money_paid
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = ""
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = expenseledger.content
        g_ledger.trade_company = expenseledger.purchase_from
        g_ledger.amount = expenseledger.grandtotal
        if g_ledger.save
        else
          old_data = Generalledger.find_by(expenseledger_id: expenseledger.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
          old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
        end        
      elsif expenseledger.date != expenseledger.money_paid
        find_pattern = journalpatterns.find_by(ledger: "経費帳",pattern: "支払")
        g_ledger = Generalledger.new(date: expenseledger.money_paid) 
        g_ledger.expenseledger_id = expenseledger.id
        g_ledger.debit_account = find_pattern.debit_account
        g_ledger.debit_subaccount = expenseledger.money_paid
        g_ledger.debit_taxcode = find_pattern.debit_taxcode
        g_ledger.credit_account = find_pattern.credit_account
        g_ledger.credit_subaccount = ""
        g_ledger.credit_taxcode = find_pattern.credit_taxcode
        g_ledger.content = expenseledger.content
        g_ledger.trade_company = expenseledger.purchase_from
        g_ledger.amount = expenseledger.grandtotal
        if g_ledger.save
        else
          old_data = Generalledger.find_by(expenseledger_id: expenseledger.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
          old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
        end
      end
    end
  end

  #「振替台帳」から仕訳生成
  def import_from_vouchers
    @vouchers = Voucher.all
    @vouchers.each do |voucher|
      g_ledger = Generalledger.new(date: voucher.date)
      g_ledger.voucher_id = voucher.id
      g_ledger.debit_account = voucher.debit_account
      g_ledger.debit_subaccount = voucher.debit_subaccount
      g_ledger.debit_taxcode = voucher.debit_taxcode
      g_ledger.credit_account = voucher.credit_account
      g_ledger.credit_subaccount = voucher.credit_subaccount
      g_ledger.credit_taxcode = voucher.credit_taxcode
      g_ledger.amount = voucher.amount 
      g_ledger.content = voucher.content
      g_ledger.trade_company = voucher.trade_company
      if g_ledger.save
      else
        old_data = Generalledger.find_by(voucher_id: voucher.id, debit_account: g_ledger.debit_account, debit_subaccount: g_ledger.debit_subaccount, debit_taxcode: g_ledger.debit_taxcode, credit_account: g_ledger.credit_account, credit_subaccount: g_ledger.credit_subaccount, credit_taxcode: g_ledger.credit_taxcode )
        old_data.update(date: g_ledger.date, amount: g_ledger.amount, content: g_ledger.content, trade_company: g_ledger.trade_company) if old_data
      end     
    end    
  end
end
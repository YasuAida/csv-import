module AllocationcostsHelper
    
  #端数処理
  def rounding_allocation_fraction(subexpense,total_allocation_amount)
    #配賦された付随費用を集計する
    target_stocks = subexpense.expense_relation_stocks
    allocated_subexpense = 0
    target_stocks.each do |stock|
       allocated_subexpense += stock.allocationcosts.where(title: subexpense.item).sum(:allocation_amount)
    end
   
    allocation_fraction = BigDecimal(allocated_subexpense.to_s).round(0) - total_allocation_amount
    if allocation_fraction != 0
      target_stock = target_stocks.last
      target_allocation = target_stock.allocationcosts.find_by(title: subexpense.item)
      new_allocation_amount = target_allocation.allocation_amount - allocation_fraction
      target_allocation.allocation_amount = new_allocation_amount
      target_allocation.save
    end
  end

  #付随費用を集計してstocksテーブルのレコードに付与
  def gathering_allocation_cost
    current_user.stocks.all.each do |stock|
      allocation_amount_sum = current_user.allocationcosts.where(stock_id: stock.id).sum(:allocation_amount)
      stock.grandtotal = stock.goods_amount + allocation_amount_sum
      stock.save
    end
  end
  
  #stockledgersの購入データの作成
  def import_to_stockledger
    current_user.stocks.all.each do |stock|
      target_stockledger = current_user.stockledgers.find_by(stock_id: stock.id, classification: "購入")
      if target_stockledger.present?
        target_stockledger.update(transaction_date: stock.date, sku: stock.sku, asin: stock.asin, goods_name: stock.goods_name, number: stock.number, unit_price: (stock.grandtotal)/(stock.number), grandtotal: stock.grandtotal)
      else
        current_user.stockledgers.create(stock_id: stock.id, transaction_date: stock.date, sku: stock.sku, asin: stock.asin, goods_name: stock.goods_name, classification: "購入", number: stock.number, unit_price: (stock.grandtotal)/(stock.number), grandtotal: stock.grandtotal)
      end
    end
  end
end

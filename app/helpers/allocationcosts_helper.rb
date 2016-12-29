module AllocationcostsHelper
    
  #端数処理
  def rounding_allocation_fraction
    @expense_relations = ExpenseRelation.all
    @expense_relations.group(:subexpense_id).each do |expense_relation|
         
    #配賦対象額を計算する
      @subexpense_relation = Subexpense.find(expense_relation.subexpense_id)

      ex_total_allocation_amount = BigDecimal(@subexpense_relation.amount.to_s).round(2) * @subexpense_relation.rate
      total_allocation_amount = BigDecimal(ex_total_allocation_amount.to_s).round(0)    
    
    #配賦された付随費用を集計する
      @stock_relations = @subexpense_relation.expense_relation_stocks
      allocated_subexpense = 0
      @stock_relations.each do |stock|
         allocated_subexpense += stock.allocationcosts.where(title: @subexpense_relation.item).sum(:allocation_amount)
      end
     
      allocation_fraction = BigDecimal(allocated_subexpense.to_s).round(0) - total_allocation_amount
      if allocation_fraction != 0
        target_stock = @stock_relations.last
        target_allocation = target_stock.allocationcosts.find_by(title: @subexpense_relation.item)
        new_allocation_amount = target_allocation.allocation_amount - allocation_fraction
        target_allocation.allocation_amount = new_allocation_amount
        target_allocation.save
      end
    end
  end

  #付随費用を集計してstocksテーブルのレコードに付与    
  def gathering_allocation_cost
    Stock.all.each do |stock|
      allocation_amount_sum = Allocationcost.where(stock_id: stock.id).sum(:allocation_amount)
      stock.grandtotal = stock.goods_amount + allocation_amount_sum
      stock.save
    end
  end
end

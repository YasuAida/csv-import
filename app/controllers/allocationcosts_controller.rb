class AllocationcostsController < ApplicationController

  def index
    @expense_relations = ExpenseRelation.all
    @expense_relations.each do |expense_relation|
      
    #expense_relationsテーブルのsubexpense_idに等しいidを持つレコードをSubexpenseモデルの中から探し、それを@subexpenseに入れる
      @subexpense = Subexpense.find(expense_relation.subexpense_id)

    #@subexpenseの外貨金額×為替レート=円金額を計算し、それを端数を丸めたあと「total_allocation_amount」に入れる
      ex_total_allocation_amount = BigDecimal(@subexpense.amount.to_s).round(2) * BigDecimal(@subexpense.rate.to_s).round(2)
      total_allocation_amount = BigDecimal(ex_total_allocation_amount).round(0)
return

    #expense_relationsテーブルのsubexpense_idに対応するidを持つレコードをStockモデルの中から探し、それを@stockに入れる
      @stocks = @subexpense.expense_relation_stocks.includes(:allocationcosts)

    #@subexpense.methodを配列に直し、subexpense_methodに入れて、caseで処理を分ける。
      subexpense_method = @subexpense.method.gsub(/\"/, "").gsub(" ", "").gsub("[", "").gsub("]", "").split(",")

      case subexpense_method
      
      when ["商品個数"] then
      #個数の総数を計算し「total_number」に入れる
        total_number = 0
        @stocks.each do |stock|
          total_number = total_number + stock.number
        end

      #@allocationcostに付随費用項目名と配分額を入れて保存する
        @stocks.each do |stock|
        if stock.grandtotal.present? then
          break
        end
          @allocationcost = Allocationcost.new
          @allocationcost.stock_id = stock.id
          @allocationcost.title = @subexpense.item
          alloc_amount = total_allocation_amount * stock.number / total_number
          @allocationcost.allocation_amount = BigDecimal(alloc_amount.to_s).round(0)
          @allocationcost.save
        end

      when ["商品金額"] then
      #商品金額の総額を計算し「total_amount」に入れる        
        total_amount = 0
        @stocks.each do |stock|
          goods_amount = stock.number * BigDecimal(stock.unit_price.to_s).round(2) * BigDecimal(stock.rate.to_s).round(2)
          total_amount = total_amount + BigDecimal(goods_amount.to_s).round(0)
        end

      #@allocationcostsに付随費用項目名と配分額を入れて保存する        
        @stocks.each do |stock|
        if stock.grandtotal.present? then
          break
        end
          @allocationcost = Allocationcost.new
          @allocationcost.stock_id = stock.id
          @allocationcost.title = @subexpense.item
          goods_amount = stock.number * BigDecimal(stock.unit_price.to_s).round(2) * BigDecimal(stock.rate.to_s).round(2)
          alloc_amount = total_allocation_amount * goods_amount / total_amount
          @allocationcost.allocation_amount = BigDecimal(alloc_amount.to_s).round(0)
          @allocationcost.save
        end
        
      else
      #商品金額の総額を計算し「total_amount」に入れる        
        total_amount = 0
        @stocks.each do |stock|
          goods_amount = stock.number * BigDecimal(stock.unit_price.to_s).round(2) * BigDecimal(stock.rate.to_s).round(2)
          total_amount = total_amount + BigDecimal(goods_amount.to_s).round(0)
        end

      #subexpense_methodから"商品金額"を除き、その後それぞれの配列から"金額"という文字を削除した後「other_method」に入れる
        copy_method = subexpense_method.dup
        copy_method.shift
        other_method = copy_method.map{|o|o.gsub(/金額/, "")}
        
      #各付随費用を合算し「total_subexpense」に入れる  
        total_subexpense = 0
        @stocks.each do |stock|
          other_method.each do |method|
            @ex_allocationcost = stock.allocationcosts.find_by(title: method)
            total_subexpense += @ex_allocationcost.allocation_amount if @ex_allocationcost.present?
          end
        end

      #@allocationcostsに付随費用項目名と配分額を入れて保存する        
        @stocks.each do |stock|
        if stock.grandtotal.present? then
          break
        end
          goods_amount = stock.number * BigDecimal(stock.unit_price.to_s).round(2) * BigDecimal(stock.rate.to_s).round(2)
         
          other_subexpense = 0
          other_method.each do |method|
            @ex_allocationcost = stock.allocationcosts.find_by(title: method)
            other_subexpense += @ex_allocationcost.allocation_amount if @ex_allocationcost.present?
          end

          @allocationcost = Allocationcost.new
          @allocationcost.stock_id = stock.id
          @allocationcost.title = @subexpense.item 
          alloc_amount = total_allocation_amount * (BigDecimal(goods_amount.to_s).round(0) + BigDecimal(other_subexpense.to_s).round(0))/ (total_amount + total_subexpense)
          @allocationcost.allocation_amount = BigDecimal(alloc_amount.to_s).round(0)
          @allocationcost.save
        end      
      end
    end
    @stocks = Stock.all
    @stocks.each do |stock|
    if stock.grandtotal.present? then
      break
    end
      goods_amount = stock.number * BigDecimal(stock.unit_price.to_s).round(2) * BigDecimal(stock.rate.to_s).round(2)
      allocation_amount_sum = Allocationcost.where(stock_id: stock.id).sum(:allocation_amount)
      stock.grandtotal = BigDecimal(goods_amount.to_s).round(0) + allocation_amount_sum
      stock.save
    end
  end
end

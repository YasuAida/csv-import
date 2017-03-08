class AllocationcostsController < ApplicationController
  include AllocationcostsHelper
  before_action :logged_in_user  

  def index
    start_time = Time.now

    @number_expense_titles = current_user.expense_titles.where(method: "[\"商品個数\"]")
    @amount_expense_titles = current_user.expense_titles.where(method: "[\"商品金額\"]")
    other_expense_titles = current_user.expense_titles.where.not(method: "[\"商品個数\"]")
    @other_expense_titles = other_expense_titles.where.not(method: "[\"商品金額\"]")

    current_user.allocationcosts.destroy_all
    
    # ["商品個数"] を按分基準に持つSubexpenseを探し、それを@number_subexpensesに入れる
    @number_expense_titles.each do |number_expense_title|
      @number_subexpenses = current_user.subexpenses.where(item: number_expense_title.item)
      @number_subexpenses.each do |subexpense|
      
        #外貨金額×為替レート=円金額を計算し、それを端数を丸めたあと「total_allocation_amount」に入れる
        ex_total_allocation_amount = BigDecimal(subexpense.amount.to_s).round(2) * subexpense.rate
        total_allocation_amount = BigDecimal(ex_total_allocation_amount).round(0)
  
        #expense_relationsテーブルのsubexpense_idに対応するidを持つレコードをStockモデルの中から探し、それを@stockに入れる
        @stocks = subexpense.expense_relation_stocks
  
        #個数の総数を計算し「total_number」に入れる
        total_number = 0
        @stocks.each do |stock|
          total_number += stock.number
        end
  
        #@allocationcostに付随費用項目名と配分額を入れて保存する
        @stocks.each do |stock|
          @allocationcost = current_user.allocationcosts.find_or_create_by(stock_id: stock.id, title: subexpense.item) 
          alloc_amount = total_allocation_amount * stock.number / total_number
          @allocationcost.allocation_amount = BigDecimal(alloc_amount.to_s).round(0)
          @allocationcost.save
        end
          
        #端数処理
        rounding_allocation_fraction(subexpense,total_allocation_amount)
      end
    end
    
    # ["商品金額"] を按分基準に持つSubexpenseを探し、それを@amount_subexpensesに入れる
    @amount_expense_titles.each do |amount_expense_title|
      @amount_subexpenses = current_user.subexpenses.where(item: amount_expense_title.item)
      @amount_subexpenses.each do |subexpense|
      
        #外貨金額×為替レート=円金額を計算し、それを端数を丸めたあと「total_allocation_amount」に入れる
        ex_total_allocation_amount = BigDecimal(subexpense.amount.to_s).round(2) * subexpense.rate
        total_allocation_amount = BigDecimal(ex_total_allocation_amount).round(0)
    
        #expense_relationsテーブルのsubexpense_idに対応するidを持つレコードをStockモデルの中から探し、それを@stockに入れる
        @stocks = subexpense.expense_relation_stocks
        
        #商品金額の総額を計算し「total_amount」に入れる        
        total_amount = 0
        @stocks.each do |stock|
          total_amount += stock.goods_amount
        end
  
        #@allocationcostsに付随費用項目名と配分額を入れて保存する        
        @stocks.each do |stock|
          @allocationcost = current_user.allocationcosts.find_or_create_by(stock_id: stock.id, title: subexpense.item) 
          alloc_amount = total_allocation_amount * stock.goods_amount / total_amount
          @allocationcost.allocation_amount = BigDecimal(alloc_amount.to_s).round(0)
          @allocationcost.save
        end
          
        #端数処理
        rounding_allocation_fraction(subexpense,total_allocation_amount)
      end
    end
    
    # その他の按分基準を持つSubexpenseを探し、それを@other_subexpensesに入れる
    @other_expense_titles.each do |other_expense_title|
      @other_subexpenses = current_user.subexpenses.where(item: other_expense_title.item)
      @other_subexpenses.each do |subexpense|
      
        #外貨金額×為替レート=円金額を計算し、それを端数を丸めたあと「total_allocation_amount」に入れる
        ex_total_allocation_amount = BigDecimal(subexpense.amount.to_s).round(2) * subexpense.rate
        total_allocation_amount = BigDecimal(ex_total_allocation_amount).round(0)
    
        #expense_relationsテーブルのsubexpense_idに対応するidを持つレコードをStockモデルの中から探し、それを@stockに入れる
        @stocks = subexpense.expense_relation_stocks
          
        #商品金額の総額を計算し「total_amount」に入れる        
        total_amount = 0
        @stocks.each do |stock|
          total_amount += stock.goods_amount
        end
  
        #subexpense_methodから"商品金額"を除き、その後それぞれの配列から"金額"という文字を削除した後「other_method」に入れる
        subexpense_method = other_expense_title.method.gsub(/\"/, "").gsub(" ", "").gsub("[", "").gsub("]", "").split(",")
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
          other_subexpense = 0
          other_method.each do |method|
            @ex_allocationcost = stock.allocationcosts.find_by(title: method)
            other_subexpense += @ex_allocationcost.allocation_amount if @ex_allocationcost.present?
          end
  
          @allocationcost = current_user.allocationcosts.find_or_create_by(stock_id: stock.id, title: subexpense.item)  
          alloc_amount = total_allocation_amount * (stock.goods_amount + BigDecimal(other_subexpense.to_s).round(0))/ (total_amount + total_subexpense)
          @allocationcost.allocation_amount = BigDecimal(alloc_amount.to_s).round(0)
          @allocationcost.save
        end
                  
        #端数処理
        rounding_allocation_fraction(subexpense,total_allocation_amount)
      end
    end
    
    #付随費用を集計してstocksテーブルのレコードに付与
    gathering_allocation_cost
    
    #stockledgersの購入データの作成
    import_to_stockledger  
    
    @q = current_user.stocks.search(params[:q])
    @stocks = @q.result(distinct: true).order(:date).page(params[:page]).per(300)
    
    render 'show'
    p "処理概要 #{Time.now - start_time}s"
  end
  
  def show
    @q = current_user.stocks.search(params[:q])
    @stocks = @q.result(distinct: true).order(:date).page(params[:page]).per(300)
  end

end

class AllocationcostsController < ApplicationController
  include AllocationcostsHelper
  before_action :logged_in_user  

  def index
    start_time = Time.now

    current_user.allocationcosts.destroy_all

    @expense_relations = current_user.expense_relations.all
    @expense_relations.group(:subexpense_id).each do |expense_relation|
    
    #expense_relationsテーブルのsubexpense_idに等しいidを持つレコードをSubexpenseモデルの中から探し、それを@subexpenseに入れる
      @subexpense = current_user.subexpenses.find(expense_relation.subexpense_id)
    
    #@subexpenseの外貨金額×為替レート=円金額を計算し、それを端数を丸めたあと「total_allocation_amount」に入れる
      ex_total_allocation_amount = BigDecimal(@subexpense.amount.to_s).round(2) * @subexpense.rate
      total_allocation_amount = BigDecimal(ex_total_allocation_amount).round(0)

    #expense_relationsテーブルのsubexpense_idに対応するidを持つレコードをStockモデルの中から探し、それを@stockに入れる
      @stocks = @subexpense.expense_relation_stocks

    #@subexpense.methodを配列に直し、subexpense_methodに入れて、caseで処理を分ける。
      expense_title = current_user.expense_titles.find_by(item: @subexpense.item)
      subexpense_method = expense_title.method.gsub(/\"/, "").gsub(" ", "").gsub("[", "").gsub("]", "").split(",")
    
      case subexpense_method
      
      when ["商品個数"] then
      #個数の総数を計算し「total_number」に入れる
        total_number = 0
        @stocks.each do |stock|
          total_number += stock.number
        end

      #@allocationcostに付随費用項目名と配分額を入れて保存する
        @stocks.each do |stock|
          @allocationcost = current_user.allocationcosts.build
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
          total_amount += stock.goods_amount
        end

      #@allocationcostsに付随費用項目名と配分額を入れて保存する        
        @stocks.each do |stock|
          @allocationcost = current_user.allocationcosts.build
          @allocationcost.stock_id = stock.id
          @allocationcost.title = @subexpense.item
          alloc_amount = total_allocation_amount * stock.goods_amount / total_amount
          @allocationcost.allocation_amount = BigDecimal(alloc_amount.to_s).round(0)
          @allocationcost.save
        end
        
      else
      #商品金額の総額を計算し「total_amount」に入れる        
        total_amount = 0
        @stocks.each do |stock|
          total_amount += stock.goods_amount
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

          other_subexpense = 0
          other_method.each do |method|
            @ex_allocationcost = stock.allocationcosts.find_by(title: method)
            other_subexpense += @ex_allocationcost.allocation_amount if @ex_allocationcost.present?
          end

          @allocationcost = current_user.allocationcosts.build
          @allocationcost.stock_id = stock.id
          @allocationcost.title = @subexpense.item 
          alloc_amount = total_allocation_amount * (stock.goods_amount + BigDecimal(other_subexpense.to_s).round(0))/ (total_amount + total_subexpense)
          @allocationcost.allocation_amount = BigDecimal(alloc_amount.to_s).round(0)
          @allocationcost.save
        end      
      end
    end
    
  #端数処理
    rounding_allocation_fraction
    
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
    
    @all_allocationcosts = current_user.allocationcosts.all
    respond_to do |format|
      format.html
      format.csv { send_data @all_allocationcosts.to_download, type: 'text/csv; charset=shift_jis', filename: "allocationcosts.csv" } 
    end 
  end

end

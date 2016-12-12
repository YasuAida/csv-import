module StockledgersHelper
  def sale_goods_import_to_stockledger 
    @pladmins = Pladmin.all.order(:date)
    @pladmins.each do |pladmin|

      @sku_stocks = Stock.where(sku: pladmin.sku).order(:date)
      if @sku_stocks.blank?
        pladmin.cgs_amount = 0
        pladmin.save
      else
        if @sku_stocks.count == 1
          if @sku_stocks.first.sold_unit.blank?
            owned_number = @sku_stocks.first.number
            @sku_stocks.first.sold_unit = 0
          else
            owned_number = @sku_stocks.first.number - @sku_stocks.first.sold_unit
          end
          
          ex_price_unit = @sku_stocks.first.grandtotal / @sku_stocks.first.number
          price_unit = BigDecimal(ex_price_unit.to_s).round(0)
          if pladmin.sale_amount.present? && pladmin.sale_amount > 0 && owned_number > 0
            @stockledger = Stockledger.new(stock_id: @sku_stocks.first.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: @sku_stocks.first.asin, goods_name: pladmin.goods_name, classification: "販売", number: pladmin.quantity * -1, unit_price: price_unit, grandtotal: price_unit * pladmin.quantity * -1)
            pladmin.cgs_amount = price_unit * pladmin.quantity
            @sku_stocks.first.sold_unit += pladmin.quantity
          elsif pladmin.sale_amount.present? && pladmin.sale_amount < 0 
            @stockledger = Stockledger.new(stock_id: @sku_stocks.first.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: @sku_stocks.first.asin, goods_name: pladmin.goods_name, classification: "キャンセル", number: pladmin.quantity, unit_price: price_unit, grandtotal: price_unit * pladmin.quantity)
            pladmin.cgs_amount = price_unit * pladmin.quantity * -1 
            @sku_stocks.first.sold_unit -= pladmin.quantity            
          end
          @stockledger.save
          @sku_stocks.first.save
          pladmin.save
        
        else
          @sale_ledgers = Stockledger.where(sku: @sku_stocks.first.sku, classification: "販売")
          @return_ledgers = Stockledger.where(sku: @sku_stocks.first.sku, classification: "キャンセル")
          sale_ary = []
          return_ary = []
          sku_ledger_number = 0

          if @sale_ledgers.present? && @return_ledgers.blank?
            @sale_ledgers.each do |sale_ledger|
              0.upto((sale_ledger.number * -1)-1) do |i|
                sale_ary << sale_ledger.id
                i = i + 1
              end
            end
            sku_ledger_number = sale_ary.count
          elsif @sale_ledgers.present? && @return_ledgers.present?
            @sale_ledgers.each do |sale_ledger|
              0.upto((sale_ledger.number * -1)-1) do |i|
                sale_ary << sale_ledger.id
                i = i + 1
              end
            end
            @return_ledgers.each do |return_ledger| 
              0.upto(return_ledger.number-1) do |i|              
                return_ary << return_ledger.id
                i = i + 1
              end
            end
            sku_ledger_number = sale_ary.count - return_ary.count
          else
            sku_ledger_number = 0
          end
            
          @sku_stocks.each do |sku_stock|
            if sku_stock.sold_unit.blank?
              owned_number = sku_stock.number
              sku_stock.sold_unit = 0
            else
              owned_number = sku_stock.number - sku_stock.sold_unit
            end
           
            if pladmin.sale_amount.present? && pladmin.sale_amount > 0 && owned_number > 0
              if sku_stock.number > sku_ledger_number
                ex_price_unit = sku_stock.grandtotal / sku_stock.number
                price_unit = BigDecimal(ex_price_unit.to_s).round(0)
                @stockledger = Stockledger.new(stock_id: sku_stock.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: sku_stock.asin, goods_name: pladmin.goods_name, classification: "販売", number: pladmin.quantity * -1, unit_price: price_unit, grandtotal: price_unit * -1)
                @stockledger.save
                pladmin.cgs_amount = price_unit * pladmin.quantity
                pladmin.save
                sku_stock.sold_unit += pladmin.quantity
                sku_stock.save
                break
              else
                sku_ledger_number =  sku_ledger_number - sku_stock.number
              end
            else
              sku_ledger_number =  sku_ledger_number - sku_stock.number
            end
              
            if pladmin.sale_amount.present? && pladmin.sale_amount < 0
              if sku_stock.number > (-1 + sku_ledger_number)
                ex_price_unit = sku_stock.grandtotal / sku_stock.number
                price_unit = BigDecimal(ex_price_unit.to_s).round(0)
                @stockledger = Stockledger.new(stock_id: sku_stock.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: sku_stock.asin, goods_name: pladmin.goods_name, classification: "キャンセル", number: pladmin.quantity, unit_price: price_unit, grandtotal: price_unit)
                @stockledger.save
                pladmin.cgs_amount = price_unit * pladmin.quantity * -1
                pladmin.save
                sku_stock.sold_unit -= pladmin.quantity
                sku_stock.save
                break
              else
                sku_ledger_number =  sku_ledger_number - sku_stock.number
              end          
            end
          end
        end
      end
    end
  end

  def return_goods_import_to_stockledger 
    ReturnGood.all.each do |return_good|
    #返還商品の返還前SKUを持つ在庫をstocksテーブルの中から抽出する
      @sku_stocks = Stock.where(sku: return_good.old_sku).order(:date)
    #返還前SKUを持つ在庫がなければ何もしない
      if @sku_stocks.blank?
      else
    #返還前SKUを持つ在庫が一つならば、その在庫のデータを使ってstockledgersテーブルにレコードを作成する         
        if @sku_stocks.count == 1 
          ex_price_unit = @sku_stocks.first.grandtotal / @sku_stocks.first.number
          price_unit = BigDecimal(ex_price_unit.to_s).round(0)
          @old_stockledger = Stockledger.new(stock_id: @sku_stocks.first.id, transaction_date: return_good.date,sku: return_good.old_sku, asin: @sku_stocks.first.asin, goods_name: @sku_stocks.first.goods_name, classification: "返還", number: return_good.number * -1, unit_price: price_unit, grandtotal: price_unit * return_good.number * -1)
          @old_stockledger.save
          @new_stockledger = Stockledger.new(stock_id: @sku_stocks.first.id, transaction_date: return_good.date,sku: return_good.new_sku, asin: @sku_stocks.first.asin, goods_name: @sku_stocks.first.goods_name, classification: "SKU付替", number: return_good.number, unit_price: price_unit, grandtotal: price_unit * return_good.number)
          @new_stockledger.save
          
        #pladminsテーブルの新SKUを持つデータを探し、あれば原価データを付与する
          @return_pladmins = Pladmin.where(sku: return_good.new_sku)
          @return_pladmins.each do |return_pladmin|
            if @sku_stocks.first.sold_unit.blank?
              owned_number = @sku_stocks.first.number
              @sku_stocks.first.sold_unit = 0              
            else
              owned_number = @sku_stocks.first.number - @sku_stocks.first.sold_unit
            end
            
            if return_pladmin.sale_amount.present? && return_pladmin.sale_amount > 0 && owned_number > 0
              return_pladmin.cgs_amount = price_unit * return_pladmin.quantity
              @sku_stocks.first.sold_unit += return_pladmin.quantity
              @return_stockledger = Stockledger.new(stock_id: @sku_stocks.first.id, transaction_date: return_pladmin.date,sku: return_good.new_sku, asin: @sku_stocks.first.asin, goods_name: @sku_stocks.first.goods_name, classification: "販売", number: return_pladmin.quantity * -1, unit_price: price_unit, grandtotal: price_unit * return_pladmin.quantity * -1)
            elsif return_pladmin.sale_amount.present? && return_pladmin.sale_amount < 0
              return_pladmin.cgs_amount = price_unit * return_pladmin.quantity * -1
              @sku_stocks.first.sold_unit -= return_pladmin.quantity
              @return_stockledger = Stockledger.new(stock_id: @sku_stocks.first.id, transaction_date: return_pladmin.date,sku: return_good.new_sku, asin: @sku_stocks.first.asin, goods_name: @sku_stocks.first.goods_name, classification: "キャンセル", number: return_pladmin.quantity, unit_price: price_unit, grandtotal: price_unit * return_pladmin.quantity)
            end
              return_pladmin.save
              @sku_stocks.first.save
              @return_stockledger.save
          end
  
      #返還前SKUを持つ在庫が複数の場合は、まず売れた個数と返還した個数の合計を調べてsku_ledger_numberに入れる。
        else
          @sale_stockledgers = Stockledger.where(sku: @sku_stocks.first.sku, classification: "販売")
          @return_stockledgers = Stockledger.where(sku: @sku_stocks.first.sku, classification: "返還") 
          sku_ary = []
          return_sku_ary = []
          sku_ledger_number = 0
          
            if @sale_stockledgers.present? && @return_stockledgers.blank?
              if @sale_stockledgers.count == 1
                0.upto((@sale_stockledgers.first.number * -1) -1) do |i|                  
                  sku_ary << @sale_stockledgers.ids
                  i = i + 1
                end
              else
                @sale_stockledgers.each do |sale_stockledger|
                  0.upto((sale_stockledger.number*-1)-1) do |i|                     
                    sku_ary << sale_stockledger.id
                    i = i + 1
                  end
                end
              end
              sku_ledger_number = sku_ary.count
              
            elsif @sale_stockledgers.blank? && @return_stockledgers.present?
              if @return_stockledgers.count == 1
                0.upto((@return_stockledgers.first.number * -1) -1) do |i|
                  sku_ary << @return_stockledgers.ids
                  i = i + 1
                end
              else
                @return_stockledgers.each do |return_stockledger| 
                  0.upto((return_stockledgers.number * -1) -1) do |i|  
                    sku_ary << return_stockledger.id
                    i = i + 1
                  end
                end
              end
              sku_ledger_number = sku_ary.count
              
            elsif @sale_stockledgers.present? && @return_stockledgers.present?
              if @sale_stockledgers.count == 1
                0.upto((@sale_stockledgers.first.number * -1)-1) do |i|
                  sku_ary << @sale_stockledgers.id
                  i = i + 1
                end
              else                
                @sale_stockledgers.each do |sale_stockledger|
                  0.upto((sale_stockledger.number * -1)-1) do |i|                      
                    sku_ary << sale_stockledger.id
                    i = i + 1
                  end
                end
              end
              
              if @return_stockledgers.count == 1
                0.upto((@return_stockledgers.first.number * -1) -1) do |i|
                  sku_ary << @return_stockledgers.id
                  i = i + 1
                end
              else
                @return_stockledgers.each do |return_stockledger| 
                  0.upto((return_stockledgers.number * -1) -1) do |i|  
                    sku_ary << return_stockledger.id
                    i = i + 1
                  end
                end
              end
              sku_ledger_number = sku_ary.count - return_sku_ary.count 
            else
              sku_ledger_number = 0
            end
            
        #個数を数えた後、日付の古いものから順番に売れたものを引いていって、現在どのSKUが残っているか調べた後、その在庫のデータを使ってstockledgersテーブルにレコードを作成する。
          @sku_stocks.each do |sku_stock|
            if sku_stock.number > sku_ledger_number
              ex_price_unit = sku_stock.grandtotal / sku_stock.number
              price_unit = BigDecimal(ex_price_unit.to_s).round(0)
              @old_stockledger = Stockledger.new(stock_id: sku_stock.id, transaction_date: return_good.date,sku: return_good.old_sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "返還", number: return_good.number * -1, unit_price: price_unit, grandtotal: price_unit * return_good.number * -1)
              @old_stockledger.save
              @new_stockledger = Stockledger.new(stock_id: sku_stock.id, transaction_date: return_good.date,sku: return_good.new_sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "SKU付替", number: return_good.number, unit_price: price_unit, grandtotal: price_unit * return_good.number)
              @new_stockledger.save
              
            #pladminsテーブルの新SKUを持つデータを探し、あれば原価データを付与する
              @return_pladmins = Pladmin.where(sku: return_good.new_sku)
              @return_pladmins.each do |return_pladmin|
                if sku_stock.sold_unit.blank?
                  owned_number = sku_stock.number
                  sku_stock.sold_unit = 0                  
                else
                  owned_number = sku_stock.number - sku_stock.sold_unit
                end
                
                if return_pladmin.sale_amount.present? && return_pladmin.sale_amount > 0 && owned_number > 0
                  return_pladmin.cgs_amount = price_unit * return_pladmin.quantity
                  sku_stock.sold_unit += return_pladmin.quantity
                  @return_stockledger = Stockledger.new(stock_id: sku_stock.id, transaction_date: return_pladmin.date,sku: return_good.new_sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "販売", number: return_pladmin.quantity * -1, unit_price: price_unit, grandtotal: price_unit * return_good.number * -1)                  
                elsif return_pladmin.sale_amount.present? && return_pladmin.sale_amount < 0
                  return_pladmin.cgs_amount = price_unit * return_pladmin.quantity * -1
                  sku_stock.sold_unit -= return_pladmin.quantity
                  @return_stockledger = Stockledger.new(stock_id: sku_stock.id, transaction_date: return_pladmin.date,sku: return_good.new_sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "キャンセル", number: return_pladmin.quantity, unit_price: price_unit, grandtotal: price_unit * return_pladmin.quantity)
                end
                  return_pladmin.save
                  sku_stock.save 
                  @return_stockledger.save                
              end
              break
            else
              sku_ledger_number =  sku_ledger_number - sku_stock.number
            end
          end
        end
      end
    end
  end
 
  def disposals_import_to_stockledger 
    Disposal.all.each do |disposal|
    #廃棄商品のSKUを持つ在庫をstocksテーブルの中から抽出する
    #無ければReturnGoodを通してold_skuを把握し、old_skuを持つ在庫をstocksテーブルの中から抽出する
      if Stock.find_by(sku: disposal.sku).present?    
        @sku_stocks = Stock.where(sku: disposal.sku).order(:date)
      else
        return_good = ReturnGood.find_by(new_sku: disposal.sku)
        @sku_stocks = Stock.where(sku: return_good.new_sku).order(:date)
      end
    #該当SKUを持つ在庫がなければ何もしない
      unless @sku_stocks.any?
      else
      #該当SKUを持つ在庫が一つならば、その在庫のデータを使ってstockledgersテーブルにレコードを作成する         
        if @sku_stocks.count == 1 
          if @sku_stocks.first.sold_unit.blank?
            @sku_stocks.first.sold_unit = 0              
          end
            
          ex_price_unit = @sku_stocks.first.grandtotal / @sku_stocks.first.number
          price_unit = BigDecimal(ex_price_unit.to_s).round(0)
          @sku_stocks.first.sold_unit -= disposal.number
          @sku_stocks.first.save
          @disposal_stockledger = Stockledger.new(stock_id: @sku_stocks.first.id, transaction_date: disposal.date, sku: @sku_stocks.first.sku, asin: @sku_stocks.first.asin, goods_name: @sku_stocks.first.goods_name, classification: "廃棄", number: disposal.number * -1, unit_price: price_unit, grandtotal: price_unit * disposal.number * -1)
          @disposal_stockledger.save
            
      #該当SKUを持つ在庫が複数の場合は、まず売れた個数と返還した個数の合計を調べてsku_ledger_numberに入れる。
        else
          @sale_ledgers = Stockledger.where(sku: @sku_stocks.first.sku, classification: "販売")
          @return_ledgers = Stockledger.where(sku: @sku_stocks.first.sku, classification: "キャンセル")
          sale_ary = []
          return_ary = []
          sku_ledger_number = 0
  
          if @sale_ledgers.present? && @return_ledgers.blank?
            @sale_ledgers.each do |sale_ledger|
              0.upto((sale_ledger.number * -1)-1) do |i|
                sale_ary << sale_ledger.id
                i = i + 1
              end
            end
            sku_ledger_number = sale_ary.count
          elsif @sale_ledgers.present? && @return_ledgers.present?
            @sale_ledgers.each do |sale_ledger|
              0.upto((sale_ledger.number * -1)-1) do |i|
                sale_ary << sale_ledger.id
                i = i + 1
              end
            end
            @return_ledgers.each do |return_ledger| 
              0.upto(return_ledger.number-1) do |i|              
                return_ary << return_ledger.id
                i = i + 1
              end
            end
            sku_ledger_number = sale_ary.count - return_ary.count
          else
            sku_ledger_number = 0
          end
  
          @sku_stocks.each do |sku_stock|
            if sku_stock.sold_unit.blank?
              sku_stock.sold_unit = 0              
            end
            
            if sku_stock.number > sku_ledger_number
              ex_price_unit = sku_stock.grandtotal / sku_stock.number
              price_unit = BigDecimal(ex_price_unit.to_s).round(0)
              sku_stock.sold_unit -= disposal.number
              sku_stock.save
              @stockledger = Stockledger.new(stock_id: sku_stock.id, transaction_date: disposal.date, sku: sku_stock.sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "廃棄", number: disposal.number * -1, unit_price: price_unit, grandtotal: price_unit * disposal.number * -1)
              @stockledger.save
              break
            else
              sku_ledger_number =  sku_ledger_number - sku_stock.number
            end
          end
        end
      end
    end
  end

  #端数処理
  def rounding_fraction
    @stocks = Stock.all
    @stocks.each do |stock|
      if stock.stockledgers.sum(:number) == 0 && stock.stockledgers.sum(:grandtotal) != 0
        fraction = stock.stockledgers.sum(:grandtotal)
        new_grandtotal = stock.stockledgers.where.not(classification: "購入").last.grandtotal - fraction
        target_stockledger = stock.stockledgers.where.not(classification: "購入").last
        target_pladmin=Pladmin.where(sku: target_stockledger.sku).last
        target_stockledger.grandtotal = new_grandtotal
        target_pladmin.cgs_amount = new_grandtotal * -1 if target_pladmin.present?
        target_stockledger.save
        target_pladmin.save if target_pladmin.present?
      end
    end
  end
end
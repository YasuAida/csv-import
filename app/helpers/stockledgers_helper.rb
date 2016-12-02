module StockledgersHelper
  def sale_goods_import_to_stockledger 
    @pladmins = Pladmin.all.order(:date)
    @pladmins.each do |pladmin|

      @sku_stocks = Stock.where(sku: pladmin.sku).order(:date)
      unless @sku_stocks.any?
        pladmin.cgs_amount = 0
        pladmin.save        
      else
        if @sku_stocks.count == 1 
          ex_price_unit = @sku_stocks.first.grandtotal / @sku_stocks.first.number
          price_unit = BigDecimal(ex_price_unit.to_s).round(0)
          if pladmin.sale_amount.present? && pladmin.sale_amount >= 0 
            @stockledger = Stockledger.new(stock_id: @sku_stocks.first.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: @sku_stocks.first.asin, goods_name: pladmin.goods_name, classification: "販売", number: -1, unit_price: price_unit, grandtotal: price_unit * -1)
            pladmin.cgs_amount = price_unit
          elsif pladmin.sale_amount.present? && pladmin.sale_amount < 0 
            @stockledger = Stockledger.new(stock_id: @sku_stocks.first.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: @sku_stocks.first.asin, goods_name: pladmin.goods_name, classification: "キャンセル", number: 1, unit_price: price_unit, grandtotal: price_unit)
            pladmin.cgs_amount = price_unit * -1         
          end
          @stockledger.save
          pladmin.save
        
        else
          @sku_ledger = Stockledger.where(sku: @sku_stocks.first.sku)
            if @sku_ledger.present?
              sku_ary = []
              sku_ledger_number = 0
              @sku_ledger.each do |sku_ledger|  
                sku_ary << sku_ledger.id
              end
              sku_ledger_number = sku_ary.count
            else
              sku_ledger_number = 0
            end

          @sku_stocks.each do |sku_stock|
            if sku_stock.number > sku_ledger_number
              ex_price_unit = sku_stock.grandtotal / sku_stock.number
              price_unit = BigDecimal(ex_price_unit.to_s).round(0)
              if pladmin.sale_amount.present? && pladmin.sale_amount >= 0            
                @stockledger = Stockledger.new(stock_id: sku_stock.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: sku_stock.asin, goods_name: pladmin.goods_name, classification: "販売", number: -1, unit_price: price_unit, grandtotal: price_unit * -1)
                pladmin.cgs_amount = price_unit
              else
                @stockledger = Stockledger.new(stock_id: sku_stock.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: sku_stock.asin, goods_name: pladmin.goods_name, classification: "キャンセル", number: 1, unit_price: price_unit, grandtotal: price_unit)
                pladmin.cgs_amount = price_unit * -1         
              end
              @stockledger.save
              pladmin.save
              break
            else
              sku_ledger_number =  sku_ledger_number - sku_stock.number
            end
          end
        end
      end
    end
  end

  def multi_channels_import_to_stockledger
    #損益管理シートへSKUと商品名を入力
    MultiChannel.all.each do |multi|
      pladmin = Pladmin.find_by(order_num: multi.order_num)
      pladmin.sku = multi.sku
      @sku_stockledgers = Stockledger.where(sku: multi.sku)
      pladmin.goods_name = @sku_stockledgers.first.goods_name if @sku_stockledgers.present?
      pladmin.save
    end
  end

  def return_goods_import_to_stockledger 
    ReturnGood.all.each do |return_good|
      #返還商品の返還前SKUを持つ在庫をstocksテーブルの中から抽出する
        @sku_stocks = Stock.where(sku: return_good.old_sku).order(:date)
      #返還日時を把握するため、salesテーブルの中から返還商品の注文番号に一致するレコードを見つける
        @date_sale = Sale.find_by(order_num: return_good.order_num)
      #返還前SKUを持つ在庫がなければ何もしない
        unless @sku_stocks.any?
        else
      #返還前SKUを持つ在庫が一つならば、その在庫のデータを使ってstockledgersテーブルにレコードを作成する         
          if @sku_stocks.count == 1 
            ex_price_unit = @sku_stocks.first.grandtotal / @sku_stocks.first.number
            price_unit = BigDecimal(ex_price_unit.to_s).round(0)
            @old_stockledger = Stockledger.new(stock_id: @sku_stocks.first.id, transaction_date: @date_sale.date,sku: return_good.old_sku, asin: @sku_stocks.first.asin, goods_name: @sku_stocks.first.goods_name, classification: "返還", number: return_good.number * -1, unit_price: price_unit, grandtotal: price_unit * return_good.number * -1)
            @old_stockledger.save
            @new_stockledger = Stockledger.new(stock_id: @sku_stocks.first.id, transaction_date: @date_sale.date,sku: return_good.new_sku, asin: @sku_stocks.first.asin, goods_name: @sku_stocks.first.goods_name, classification: "SKU付替", number: return_good.number, unit_price: price_unit, grandtotal: price_unit * return_good.number)
            @new_stockledger.save
            
          #pladminsテーブルの新SKUを持つデータを探し、あれば原価データを付与する
            @return_pladmins = Pladmin.where(sku: return_good.new_sku)
            @return_pladmins.each do |return_pladmin|
              return_pladmin.cgs_amount = price_unit
              return_pladmin.save
            end
    
      #返還前SKUを持つ在庫が複数の場合は、まず売れた個数と返還した個数の合計を調べてsku_ledger_numberに入れる。
          else
            @sale_stock = Stockledger.find_by(sku: @sku_stocks.first.sku, classification: "販売")
            @return_stock = Stockledger.find_by(sku: @sku_stocks.first.sku, classification: "返還")            
              if @sale_stock.present? && @return_stock.nil?
                sku_ary = []
                sku_ary << @sale_stock
                sku_ledger_number = sku_ary.count
              elsif @sale_stock.nil? && @return_stock.present?
                sku_ary = []
                sku_ary << @return_stock
                sku_ledger_number = sku_ary.count                
              elsif @sale_stock.present? && @return_stock.present?
                sku_ary = []
                return_ske_ary = []
                sku_ary << @sale_stock
                return_ske_ary << @return_stock
                sku_ledger_number = sku_ary.count - return_ske_ary.count 
              else
                sku_ledger_number = 0
              end
      #個数を数えた後、日付の古いものから順番に売れたものを引いていって、現在どのSKUが残っているか調べた後、その在庫のデータを使ってstockledgersテーブルにレコードを作成する。
            @sku_stocks.each do |sku_stock|
              if sku_stock.number > sku_ledger_number
                ex_price_unit = sku_stock.grandtotal / sku_stock.number
                price_unit = BigDecimal(ex_price_unit.to_s).round(0)
                @old_stockledger = Stockledger.new(stock_id: sku_stock.id, transaction_date: @date_sale.date,sku: return_good.old_sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "返還", number: return_good.number * -1, unit_price: price_unit, grandtotal: price_unit * return_good.number * -1)
                @old_stockledger.save
                @new_stockledger = Stockledger.new(stock_id: sku_stock.id, transaction_date: @date_sale.date,sku: return_good.new_sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "SKU付替", number: return_good.number, unit_price: price_unit, grandtotal: price_unit * return_good.number)
                @new_stockledger.save
                
              #pladminsテーブルの新SKUを持つデータを探し、あれば原価データを付与する
                @return_pladmins = Pladmin.where(sku: return_good.new_sku)
                @return_pladmins.each do |return_pladmin|
                  return_pladmin.cgs_amount = price_unit
                  return_pladmin.save
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
  
  #端数処理
  def rounding_fraction
    @stocks = Stock.all
    @stocks.each do |stock|
      if stock.stockledgers.sum(:number) == 0 && stock.stockledgers.sum(:grandtotal) != 0
        fraction = stock.stockledgers.sum(:grandtotal)
        new_grandtotal = stock.stockledgers.where.not(classification: "購入").last.grandtotal - fraction
        target_stockledger = stock.stockledgers.where.not(classification: "購入").last
        target_stockledger.grandtotal = new_grandtotal
        target_stockledger.save
      end
    end
  end
end
module StockledgersHelper
  def sale_goods_import_to_stockledger 
    @pladmins = Pladmin.all.order(:date)
    @pladmins.each do |pladmin|

      @sku_stocks = nil
      @check_stocks = Stock.where(sku: pladmin.sku)
      @check_returns = ReturnGood.where(new_sku: pladmin.sku)
      if @check_stocks.present? && @check_returns.blank?
        @sku_stocks = @check_stocks.order(:date)
      elsif @check_stocks.blank? && @check_returns.present? 
        if @check_returns.count == 1
          @sku_stocks = Stock.where(sku: @check_returns.first.old_sku).order(:date)
        elsif @check_returns.count > 1
          @check_returns.each do |check_return|
            @check_return_stocks = Stock.where(sku: check_return.old_sku).order(:date)
            if pladmin.sale_amount.present? && pladmin.sale_amount > 0
              if @check_return_stocks.present? && @check_return_stocks.count == 1 && !@check_return_stocks.first.soldout_check
                @sku_stocks = @check_return_stocks
                break
              elsif @check_return_stocks.present? && @check_return_stocks.count > 1 
                @check_return_stocks.each do |check_return_stock|
                  if !check_return_stock.soldout_check
                    only_stock = check_return_stock
                    break
                  end
                end
              end
            elsif pladmin.sale_amount.present? && pladmin.sale_amount < 0
              if @check_return_stocks.present? && @check_return_stocks.count == 1 
                @sku_stocks = @check_return_stocks
                break
              elsif @check_return_stocks.present? && @check_return_stocks.count > 1 
                @check_return_stocks.each do |check_return_stock|
                target_stocks = @check_return_stocks.where(soldout_check: true).order(:date)
                  if !check_return_stock.soldout_check || target_stocks.present? && check_return_stock == target_stocks.last
                    only_stock = check_return_stock
                    break
                  end
                end
              end
            end
          end
        end  
      elsif @check_stocks.present? && @check_returns.present?
        if pladmin.sale_amount.present? && pladmin.sale_amount > 0
          if @check_stocks.where(soldout_check: false).present?
            @sku_stocks = @check_stocks
          else
            @check_returns.each do |check_return|
              @check_return_stocks = Stock.where(sku: check_return.old_sku).order(:date)
              if @check_return_stocks.present? && @check_return_stocks.count == 1 && !@check_return_stocks.first.soldout_check
                @sku_stocks = @check_return_stocks
                break
              elsif @check_return_stocks.present? && @check_return_stocks.count > 1 
                @check_return_stocks.each do |check_return_stock|
                  if !check_return_stock.soldout_check
                    only_stock = check_return_stock
                    break
                  end
                end
              end
            end        
          end
        elsif  pladmin.sale_amount.present? && pladmin.sale_amount < 0
          if @check_stocks.where("sold_unit >= ?", 1).present?           
            only_stock = @check_stocks.last
          elsif @check_returns.count == 1
            @sku_stocks = Stock.where(sku: @check_returns.first.old_sku).order(:date)
          elsif @check_returns.count > 0
            @check_returns.each do |check_return|
              @check_return_stocks = Stock.where(sku: check_return.old_sku).order(:date)
              if @check_return_stocks.present? && @check_return_stocks.count == 1
                @sku_stocks = @check_return_stocks
                break
              elsif @check_return_stocks.present? && @check_return_stocks.count > 1 
                @check_return_stocks.each do |check_return_stock|
                target_stocks = @check_return_stocks.where("sold_unit >= ?", 1).order(:date)
                  if target_stocks.present? && check_return_stock == target_stocks.last
                    only_stock = check_return_stock
                    break
                  end
                end
              end
            end        
          end          
        end
      end
      
      if @sku_stocks.blank? && only_stock.blank? 
        pladmin.cgs_amount = 0
        pladmin.save

      elsif only_stock.present?
        single_sku_stock(only_stock, pladmin)      

      elsif @sku_stocks.count == 1     
        single_sku_stock(@sku_stocks.first, pladmin)
        
      else          
        @sku_stocks.each do |sku_stock|

          owned_number = sku_stock.number - sku_stock.sold_unit
          if owned_number == 0
            sku_stock.soldout_check = true
          else
            sku_stock.soldout_check = false
          end            
        
          ex_price_unit = sku_stock.grandtotal / sku_stock.number
          price_unit = BigDecimal(ex_price_unit.to_s).round(0)
          
        #@sku_stocksが複数で、pladmin.sale_amountがプラス 
          if pladmin.sale_amount.present? && pladmin.sale_amount > 0 && owned_number > 0
            if pladmin.quantity > (sku_stock.number - sku_stock.sold_unit)
              @stockledger = Stockledger.create(stock_id: sku_stock.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: sku_stock.asin, goods_name: pladmin.goods_name, classification: "販売", number: owned_number * -1, unit_price: price_unit, grandtotal: price_unit * owned_number * -1)
              first_cgs = price_unit * owned_number
              sku_stock.sold_unit += owned_number
              sku_stock.soldout_check = true
              sku_stock.save
              
              @next_stocks = @sku_stocks.where(soldout_check: false)
              next_stock = @next_stocks.first
              ex_price_unit = next_stock.grandtotal / next_stock.number
              price_unit = BigDecimal(ex_price_unit.to_s).round(0)                
              @stockledger = Stockledger.create(stock_id: next_stock.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: next_stock.asin, goods_name: pladmin.goods_name, classification: "販売", number: (pladmin.quantity - owned_number) * -1, unit_price: price_unit, grandtotal: price_unit * (pladmin.quantity - owned_number) * -1)
              pladmin.cgs_amount = first_cgs + price_unit * (pladmin.quantity - owned_number)
              pladmin.save
              next_stock.sold_unit += (pladmin.quantity - owned_number)
              
              if (next_stock.number - next_stock.sold_unit) == 0
                next_stock.soldout_check = true
              else
                next_stock.soldout_check = false
              end
              next_stock.save
              break
            else
              @stockledger = Stockledger.create(stock_id: sku_stock.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: sku_stock.asin, goods_name: pladmin.goods_name, classification: "販売", number: pladmin.quantity * -1, unit_price: price_unit, grandtotal: price_unit * pladmin.quantity * -1)
              pladmin.cgs_amount = price_unit * pladmin.quantity
              pladmin.save
              sku_stock.sold_unit += pladmin.quantity
              
              owned_number = sku_stock.number - sku_stock.sold_unit
              if owned_number == 0
                sku_stock.soldout_check = true
              else
                sku_stock.soldout_check = false
              end
              sku_stock.save            
              break
            end
        #@sku_stocksが複数で、pladmin.sale_amountがマイナス              
          elsif pladmin.sale_amount.present? && pladmin.sale_amount < 0
            target_stocks = @sku_stocks.where("sold_unit >= ?", 1)
            if target_stocks.present? && sku_stock == target_stocks.last           
              @stockledger = Stockledger.create(stock_id: sku_stock.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: sku_stock.asin, goods_name: pladmin.goods_name, classification: "キャンセル", number: pladmin.quantity, unit_price: price_unit, grandtotal: price_unit * pladmin.quantity)
              pladmin.cgs_amount = price_unit * pladmin.quantity * -1
              pladmin.save
              sku_stock.sold_unit -= pladmin.quantity
            end

            owned_number = sku_stock.number - sku_stock.sold_unit
            if owned_number == 0
              sku_stock.soldout_check = true
            else
              sku_stock.soldout_check = false
            end
            sku_stock.save
              
        #@sku_stocksが複数で、pladmin.sale_amountがマイナスで、sku_stockのSKUと一致するdisposalsがある
            disposals = Disposal.where(sku: pladmin.sku)
            if disposals.present? && disposals.count == 1 && !sku_stock.soldout_check
              @disposal_stockledger = Stockledger.create(stock_id: sku_stock.id, transaction_date: disposals.first.date, sku: disposals.first.sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "廃棄", number: disposals.first.number * -1, unit_price: price_unit, grandtotal: price_unit * disposals.first.number * -1)
              sku_stock.sold_unit += disposals.first.number
              sku_stock.save
              disposals.first.stock_id = sku_stock.id
              disposals.first.save
            else disposals.present? && disposals.count > 1
              disposals.each do |disposal|
                if !sku_stock.soldout_check
                  @disposal_stockledger = Stockledger.create(stock_id: sku_stock.id, transaction_date: disposal.date, sku: disposal.sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "廃棄", number: disposal.number * -1, unit_price: price_unit, grandtotal: price_unit * disposal.number * -1)
                  sku_stock.sold_unit += disposal.number
                  sku_stock.save
                  disposal.stock_id = sku_stock.id
                  disposal.save
                  break
                end
              end                 
            end
            
        #@sku_stocksが複数で、pladmin.sale_amountがマイナスで、return_goodsが一つある  
            return_goods = ReturnGood.where(old_sku: pladmin.sku)
            if return_goods.present? && return_goods.count == 1
              @old_stockledger = Stockledger.create(stock_id: sku_stock.id, transaction_date: return_goods.first.date,sku: return_goods.first.old_sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "返還", number: return_goods.first.number * -1, unit_price: price_unit, grandtotal: price_unit * return_goods.first.number * -1)
              @new_stockledger = Stockledger.create(stock_id: sku_stock.id, transaction_date: return_goods.first.date,sku: return_goods.first.new_sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "SKU付替", number: return_goods.first.number, unit_price: price_unit, grandtotal: price_unit * return_goods.first.number)
              return_goods.first.stock_id = sku_stock.id
              return_goods.first.save          
              
        #@sku_stocksが複数で、pladmin.sale_amountがマイナスで、return_goodsが一つあり、return_goodsの新SKUと一致するdisposalsがある
              return_disposals = Disposal.where(sku: return_goods.first.new_sku)
              if return_disposals.present? && return_disposals.count == 1 && !sku_stock.soldout_check
                @return_disposal_stockledger = Stockledger.create(stock_id: sku_stock.id, transaction_date: return_disposals.first.date, sku: return_disposals.first.sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "廃棄", number: return_disposals.first.number * -1, unit_price: price_unit, grandtotal: price_unit * return_disposals.first.number * -1)
                sku_stock.sold_unit += return_disposals.first.number
                sku_stock.save
                return_disposals.first.stock_id = sku_stock.id
                return_disposals.first.save
              else return_disposals.present? && return_disposals.count > 1
                return_disposals.each do |return_disposal|
                  if !sku_stock.soldout_check
                    @return_disposal_stockledger = Stockledger.create(stock_id: sku_stock.id, transaction_date: return_disposal.date, sku: return_disposal.sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "廃棄", number: return_disposal.number * -1, unit_price: price_unit, grandtotal: price_unit * return_disposal.number * -1)
                    sku_stock.sold_unit += return_disposal.number
                    sku_stock.save
                    return_disposal.stock_id = sku_stock.id
                    return_disposal.save
                    break
                  end
                end
                break
              end
              
        #@sku_stocksが複数で、pladmin.sale_amountがマイナスで、return_goodsが複数ある 
            else return_goods.present? && return_goods.count > 1 
              return_goods.each do |return_good|
                @old_stockledger = Stockledger.create(stock_id: sku_stock.id, transaction_date: return_good.date,sku: return_good.old_sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "返還", number: return_good.number * -1, unit_price: price_unit, grandtotal: price_unit * return_good.number * -1)
                @new_stockledger = Stockledger.create(stock_id: sku_stock.id, transaction_date: return_good.date,sku: return_good.new_sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "SKU付替", number: return_good.number, unit_price: price_unit, grandtotal: price_unit * return_good.number)
                return_good.stock_id = sku_stock.id
                return_good.save
              
        #@sku_stocksが複数で、pladmin.sale_amountがマイナスで、return_goodsが複数あり、return_goodsの新SKUと一致するdisposalsがある
                return_disposals = Disposal.where(sku: return_good.new_sku)
                if return_disposals.present? && return_disposals.count == 1 && !sku_stock.soldout_check
                  @return_disposal_stockledger = Stockledger.create(stock_id: sku_stock.id, transaction_date: return_disposals.date, sku: return_disposals.sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "廃棄", number: return_disposals.number * -1, unit_price: price_unit, grandtotal: price_unit * return_disposals.number * -1)
                  sku_stock.sold_unit += return_disposals.number
                  sku_stock.save
                  return_disposals.stock_id = sku_stock.id
                  return_disposals.save
                else return_disposals.present? && return_disposals.count > 1
                  return_disposals.each do |return_disposal|
                    if !sku_stock.soldout_check
                      @return_disposal_stockledger = Stockledger.create(stock_id: sku_stock.id, transaction_date: return_disposal.date, sku: return_disposal.sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "廃棄", number: return_disposal.number * -1, unit_price: price_unit, grandtotal: price_unit * return_disposal.number * -1)
                      sku_stock.sold_unit += return_disposal.number
                      sku_stock.save
                      return_disposal.stock_id = sku_stock.id
                      return_disposal.save
                      break
                    end
                  end
                end                          
              end #310行目 return_goods.each do |return_good|           
            end #255行目 if return_goods.present? && return_goods.count == 1, 309行目 else return_goods.present? && return_goods.count > 1 
            break 
          end #202行目 if pladmin.sale_amount.present? && pladmin.sale_amount > 0 && owned_number > 0, 212行目 if pladmin.sale_amount.present? && pladmin.sale_amount < 0,   
        end #189行目 @sku_stocks.each do |sku_stock|
      end
    end #@pladmins.each do |pladmin|
  end #def sale_goods_import_to_stockledger
  
  def single_sku_stock(stock, pladmin)
    owned_number = stock.number - stock.sold_unit        
    if owned_number == 0
      stock.soldout_check = true
    else
      stock.soldout_check = false
    end        
    ex_price_unit = stock.grandtotal / stock.number
    price_unit = BigDecimal(ex_price_unit.to_s).round(0)

  #@sku_stocksが一つで、pladmin.sale_amountがプラス    
    if pladmin.sale_amount.present? && pladmin.sale_amount > 0 && owned_number > 0
      @stockledger = Stockledger.create(stock_id: stock.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: stock.asin, goods_name: pladmin.goods_name, classification: "販売", number: pladmin.quantity * -1, unit_price: price_unit, grandtotal: price_unit * pladmin.quantity * -1)
      pladmin.cgs_amount = price_unit * pladmin.quantity
      stock.sold_unit += pladmin.quantity
      pladmin.save
      
      owned_number = stock.number - stock.sold_unit
      if owned_number == 0
        stock.soldout_check = true
      else
        stock.soldout_check = false
      end
      stock.save            
      
  #@sku_stocksが一つで、pladmin.sale_amountがマイナス
    elsif pladmin.sale_amount.present? && pladmin.sale_amount < 0 
      @stockledger = Stockledger.create(stock_id: stock.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: stock.asin, goods_name: pladmin.goods_name, classification: "キャンセル", number: pladmin.quantity, unit_price: price_unit, grandtotal: price_unit * pladmin.quantity)
      pladmin.cgs_amount = price_unit * pladmin.quantity * -1 
      pladmin.save
      stock.sold_unit -= pladmin.quantity
      
      owned_number = stock.number - stock.sold_unit
      if owned_number == 0
        stock.soldout_check = true
      else
        stock.soldout_check = false
      end
      stock.save

  #@sku_stocksが一つで、pladmin.sale_amountがマイナスで、@sku_stocksのSKUと一致するdisposalsがある
      disposals = Disposal.where(sku: pladmin.sku)
      if disposals.present? && disposals.count == 1  && !stock.soldout_check
        @disposal_stockledger = Stockledger.create(stock_id: stock.id, transaction_date: disposals.first.date, sku: disposals.first.sku, asin: stock.asin, goods_name: stock.goods_name, classification: "廃棄", number: disposals.first.number * -1, unit_price: price_unit, grandtotal: price_unit * disposals.first.number * -1)
        stock.sold_unit += disposals.first.number
        stock.save
        disposals.first.stock_id = stock.id
        disposals.first.save
      else disposals.present? && disposals.count > 1
        disposals.each do |disposal|
          if !stock.soldout_check
            @disposal_stockledger = Stockledger.create(stock_id: stock.id, transaction_date: disposal.date, sku: disposal.sku, asin: stock.asin, goods_name: stock.goods_name, classification: "廃棄", number: disposal.number * -1, unit_price: price_unit, grandtotal: price_unit * disposal.number * -1)
            stock.sold_unit += disposal.number
            stock.save
            disposal.stock_id = stock.id
            disposal.save
            break
          end
        end                
      end

  #@sku_stocksが一つで、pladmin.sale_amountがマイナスで、return_goodsが一つある            
      return_goods = ReturnGood.where(old_sku: pladmin.sku)
      if return_goods.present? && return_goods.count == 1
        @old_stockledger = Stockledger.create(stock_id: stock.id, transaction_date: return_goods.first.date,sku: return_goods.first.old_sku, asin: stock.asin, goods_name: stock.goods_name, classification: "返還", number: return_goods.first.number * -1, unit_price: price_unit, grandtotal: price_unit * return_goods.first.number * -1)
        @new_stockledger = Stockledger.create(stock_id: stock.id, transaction_date: return_goods.first.date,sku: return_goods.first.new_sku, asin: stock.asin, goods_name: stock.goods_name, classification: "SKU付替", number: return_goods.first.number, unit_price: price_unit, grandtotal: price_unit * return_goods.first.number)
        return_goods.first.stock_id = stock.id
        return_goods.first.save             
        
  #@sku_stocksが一つで、pladmin.sale_amountがマイナスで、return_goodsが一つあり、return_goodsの新SKUと一致するdisposalsがある
        return_disposals = Disposal.where(sku: return_goods.first.new_sku)
        if return_disposals.present? && return_disposals.count == 1 && !stock.soldout_check          
          @return_disposal_stockledger = Stockledger.create(stock_id: stock.id, transaction_date: return_disposals.first.date, sku: return_disposals.first.sku, asin: stock.asin, goods_name: stock.goods_name, classification: "廃棄", number: return_disposals.first.number * -1, unit_price: price_unit, grandtotal: price_unit * return_disposals.first.number * -1)
          stock.sold_unit += return_disposals.first.number
          stock.save
          return_disposals.first.stock_id = stock.id
          return_disposals.first.save
        else return_disposals.present? && return_disposals.count > 1
          return_disposals.each do |return_disposal|
            if !stock.soldout_check
              @return_disposal_stockledger = Stockledger.create(stock_id: stock.id, transaction_date: return_disposal.date, sku: return_disposal.sku, asin: stock.asin, goods_name: stock.goods_name, classification: "廃棄", number: return_disposal.number * -1, unit_price: price_unit, grandtotal: price_unit * return_disposal.number * -1)
              stock.sold_unit += return_disposal.number
              stock.save
              return_disposal.stock_id = stock.id
              return_disposal.save                    
              break
            end
          end
        end
          
  #@sku_stocksが一つで、pladmin.sale_amountがマイナスで、return_goodsが複数ある               
      else return_goods.present? && return_goods.count > 1 
        return_goods.each do |return_good|
          @old_stockledger = Stockledger.create(stock_id: stock.id, transaction_date: return_good.date,sku: return_good.old_sku, asin: stock.asin, goods_name: stock.goods_name, classification: "返還", number: return_good.number * -1, unit_price: price_unit, grandtotal: price_unit * return_good.number * -1)
          @new_stockledger = Stockledger.create(stock_id: stock.id, transaction_date: return_goods.date,sku: return_goods.new_sku, asin: stock.asin, goods_name: stock.goods_name, classification: "SKU付替", number: return_goods.number, unit_price: price_unit, grandtotal: price_unit * return_good.number)
          return_good.stock_id = stock.id
          return_good.save             
          
  #@sku_stocksが一つで、pladmin.sale_amountがマイナスで、return_goodsが複数あり、return_goodsの新SKUと一致するdisposalsがある 
          return_disposals = Disposal.where(sku: return_goods.new_sku)
          if return_disposals.present? && return_disposals.count == 1 && !stock.soldout_check        
            @return_disposal_stockledger = Stockledger.create(stock_id: stock.id, transaction_date: return_disposals.first.date, sku: return_disposals.first.sku, asin: stock.asin, goods_name: stock.goods_name, classification: "廃棄", number: return_disposals.first.number * -1, unit_price: price_unit, grandtotal: price_unit * return_disposals.first.number * -1)
            stock.sold_unit += return_disposals.first.number
            stock.save
            return_disposals.first.stock_id = stock.id
            return_disposals.first.save
          else return_disposals.present? && return_disposals.count > 1
            return_disposals.each do |return_disposal|
              if !stock.soldout_check
                @return_disposal_stockledger = Stockledger.create(stock_id: stock.id, transaction_date: return_disposal.date, sku: return_disposal.sku, asin: stock.asin, goods_name: stock.goods_name, classification: "廃棄", number: return_disposal.number * -1, unit_price: price_unit, grandtotal: price_unit * return_disposal.number * -1)
                stock.sold_unit += return_disposal.number
                stock.save
                return_disposal.stock_id = stock.id
                return_disposal.save
                break
              end
            end
          end
        end #128行目 return_goods.each do |return_good|                                          
      end #74行目 if return_goods.present? && return_goods.count == 1, 127行目 else return_goods.present? && return_goods.count > 1 
    end #32行目 if pladmin.sale_amount.present? && pladmin.sale_amount > 0 && owned_number > 0, 41行目 elsif pladmin.sale_amount.present? && pladmin.sale_amount < 0     
  end
  

  #端数処理
  def rounding_fraction
    @stocks = Stock.all
    @stocks.each do |stock|
      if stock.stockledgers.sum(:number) == 0 && stock.stockledgers.sum(:grandtotal) != 0
        fraction = stock.stockledgers.sum(:grandtotal)
        new_grandtotal = stock.stockledgers.where.not(classification: "購入").order(:date).last.grandtotal - fraction
        target_stockledger = stock.stockledgers.where.not(classification: "購入").order(:date).last
        target_pladmin=Pladmin.where(sku: target_stockledger.sku).order(:date).last
        target_stockledger.grandtotal = new_grandtotal
        target_pladmin.cgs_amount = new_grandtotal * -1 if target_pladmin.present?
        target_stockledger.save
        target_pladmin.save if target_pladmin.present?
      end
    end
  end  
end
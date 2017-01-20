module StockledgersHelper
  def sale_goods_import_to_stockledger 
    @pladmins = current_user.pladmins.all.order(:date)
    @pladmins.each do |pladmin|

      @sku_stocks = nil
      @only_stock = nil
      @check_stocks = current_user.stocks.where(sku: pladmin.sku)
      @check_returns = current_user.return_goods.where(new_sku: pladmin.sku)
      if @check_stocks.present? && @check_returns.blank?
        @sku_stocks = @check_stocks.order(:date)
      elsif @check_stocks.blank? && @check_returns.present? 
        if pladmin.sale_amount.present? && pladmin.sale_amount > 0        
          @check_returns.each do |check_return|
            check_return_stock = current_user.stocks.find(check_return.stock_id)
            if !check_return_stock.soldout_check
               @only_stock = check_return_stock
               break
            end
          end
        elsif pladmin.sale_amount.present? && pladmin.sale_amount < 0
          @check_returns.each do |check_return|
            @check_return_stocks = current_user.stocks.where(sku: check_return.old_sku).order(:date)
            target_stocks = @check_return_stocks.where("sold_unit >= ?", 1).order(:date)
            check_return_stock = current_user.stocks.find(check_return.stock_id)          
            if target_stocks.present? && check_return_stock == target_stocks.last
              @only_stock = check_return_stock
              break
            end 
          end          
        end 
      elsif @check_stocks.present? && @check_returns.present?
        if pladmin.sale_amount.present? && pladmin.sale_amount > 0        
          @check_returns.each do |check_return|
            check_return_stock = current_user.stocks.find(check_return.stock_id)
            if !check_return_stock.soldout_check
               @only_stock = check_return_stock
               break
            end
          end
          if @only_stock.blank?
            @sku_stocks = @check_stocks
          end
            
        elsif pladmin.sale_amount.present? && pladmin.sale_amount < 0
          @check_returns.each do |check_return|
            @check_return_stocks = current_user.stocks.where(sku: check_return.old_sku).order(:date)
            target_stocks = @check_return_stocks.where("sold_unit >= ?", 1).order(:date)
            check_return_stock = current_user.stocks.find(check_return.stock_id)          
            if target_stocks.present? && check_return_stock == target_stocks.last
              @only_stock = check_return_stock
              break
            end        
          end    
          if @only_stock.blank?
            @sku_stocks = @check_stocks
          end          
        end
      end
      
      if @sku_stocks.blank? && @only_stock.blank? 
        pladmin.cgs_amount = 0
        pladmin.save

      elsif @only_stock.present?
        single_sku_stock(@only_stock, pladmin)      

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
          
          target_stocks = @sku_stocks.where("sold_unit >= ?", 1)          
          
        #@sku_stocksが複数で、pladmin.sale_amountがプラス 
          if pladmin.sale_amount.present? && pladmin.sale_amount > 0 && owned_number > 0
            if pladmin.quantity > (sku_stock.number - sku_stock.sold_unit)
              @stockledger = current_user.stockledgers.create(stock_id: sku_stock.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: sku_stock.asin, goods_name: pladmin.goods_name, classification: "販売", number: owned_number * -1, unit_price: price_unit, grandtotal: price_unit * owned_number * -1)
              
              @first_pladmin = current_user.pladmins.create(stock_id: sku_stock.id, date: pladmin.date, order_num: pladmin.order_num, sku: pladmin.sku, goods_name: pladmin.goods_name, money_receive: pladmin.money_receive, sale_place: pladmin.sale_place)
              @first_pladmin.quantity = owned_number
              @first_pladmin.sale_amount = pladmin.sale_amount * owned_number / pladmin.quantity
              @first_pladmin.cgs_amount = price_unit * owned_number
              @first_pladmin.commission = pladmin.commission * owned_number / pladmin.quantity if pladmin.commission.present?
              @first_pladmin.shipping_cost = pladmin.shipping_cost * owned_number / pladmin.quantity if pladmin.shipping_cost.present?
              @first_pladmin.commission_pay_date = pladmin.commission_pay_date if pladmin.commission_pay_date.present?
              @first_pladmin.shipping_pay_date = pladmin.shipping_pay_date if pladmin.shipping_pay_date
              @first_pladmin.save
              
              sku_stock.sold_unit += owned_number
              sku_stock.soldout_check = true
              sku_stock.save
          
              @next_stocks = @sku_stocks.where(soldout_check: false)
              next_stock = @next_stocks.first
              ex_price_unit = next_stock.grandtotal / next_stock.number
              price_unit = BigDecimal(ex_price_unit.to_s).round(0)                
              @stockledger = current_user.stockledgers.create(stock_id: next_stock.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: next_stock.asin, goods_name: pladmin.goods_name, classification: "販売", number: (pladmin.quantity - owned_number) * -1, unit_price: price_unit, grandtotal: price_unit * (pladmin.quantity - owned_number) * -1)

              @later_pladmin = current_user.pladmins.create(stock_id: next_stock.id, date: pladmin.date, order_num: pladmin.order_num, sku: pladmin.sku, goods_name: pladmin.goods_name, money_receive: pladmin.money_receive, sale_place: pladmin.sale_place)              
              @later_pladmin.quantity = pladmin.quantity - owned_number            
              @later_pladmin.sale_amount = pladmin.sale_amount - @first_pladmin.sale_amount
              @later_pladmin.cgs_amount = price_unit * (pladmin.quantity - owned_number)
              @later_pladmin.commission = (pladmin.commission - @first_pladmin.commission) if @first_pladmin.commission.present?
              @later_pladmin.shipping_cost = (pladmin.shipping_cost - @first_pladmin.shipping_cost) if @first_pladmin.shipping_cost.present?
              @later_pladmin.commission_pay_date = pladmin.commission_pay_date if pladmin.commission_pay_date.present?
              @later_pladmin.shipping_pay_date = pladmin.shipping_pay_date if pladmin.shipping_pay_date
              @later_pladmin.save
              
              next_stock.sold_unit += (pladmin.quantity - owned_number)
              
              if (next_stock.number - next_stock.sold_unit) == 0
                next_stock.soldout_check = true
              else
                next_stock.soldout_check = false
              end
              next_stock.save
              pladmin.destroy
              break
            else
              @stockledger = current_user.stockledgers.create(stock_id: sku_stock.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: sku_stock.asin, goods_name: pladmin.goods_name, classification: "販売", number: pladmin.quantity * -1, unit_price: price_unit, grandtotal: price_unit * pladmin.quantity * -1)
              pladmin.stock_id = sku_stock.id
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
            
          elsif pladmin.sale_amount.present? && pladmin.sale_amount < 0        
        #@sku_stocksが複数で、pladmin.sale_amountがマイナス            
            if target_stocks.present? && sku_stock == target_stocks.last           
              @stockledger = current_user.stockledgers.create(stock_id: sku_stock.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: sku_stock.asin, goods_name: pladmin.goods_name, classification: "キャンセル", number: pladmin.quantity, unit_price: price_unit, grandtotal: price_unit * pladmin.quantity)
              pladmin.stock_id = sku_stock.id              
              pladmin.cgs_amount = price_unit * pladmin.quantity * -1
              pladmin.save
              sku_stock.sold_unit -= pladmin.quantity
              
              owned_number = sku_stock.number - sku_stock.sold_unit
              if owned_number == 0
                sku_stock.soldout_check = true
              else
                sku_stock.soldout_check = false
              end
              sku_stock.save
            end
            
        #@sku_stocksが複数で、pladmin.sale_amountがマイナスで、sku_stockのSKUと一致するdisposalsがある
            disposals = current_user.disposals.where(sku: pladmin.sku)
            if disposals.present?
              disposals.each do |disposal|
                if !sku_stock.soldout_check
                  @disposal_stockledger = current_user.stockledgers.create(stock_id: sku_stock.id, transaction_date: disposal.date, sku: disposal.sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "廃棄", number: disposal.number * -1, unit_price: price_unit, grandtotal: price_unit * disposal.number * -1)
                  sku_stock.sold_unit += disposal.number
                  sku_stock.save
                  disposal.stock_id = sku_stock.id
                  disposal.save
                  break
                end
              end                 
            end
            
        #@sku_stocksが複数で、pladmin.sale_amountがマイナスで、return_goodsがあり、return_goodsの新SKUと一致するdisposalsがある
            return_goods = current_user.return_goods.where(old_sku: pladmin.sku)
            if return_goods.present?
              return_goods.each do |return_good|
                @check_return_stocks = current_user.stocks.where(sku: return_good.old_sku).order(:date)
                target_stocks = @check_return_stocks.where("sold_unit >= ?", 1).order(:date)       
                if target_stocks.present? && sku_stock == target_stocks.last                  
                  return_disposals = current_user.disposals.where(sku: return_good.new_sku)
                  if return_disposals.present? 
                    return_disposals.each do |return_disposal|
                      if !sku_stock.soldout_check
                        current_user.stockledgers.create(stock_id: sku_stock.id, transaction_date: return_disposal.date, sku: return_disposal.sku, asin: sku_stock.asin, goods_name: sku_stock.goods_name, classification: "廃棄", number: return_disposal.number * -1, unit_price: price_unit, grandtotal: price_unit * return_disposal.number * -1)
                        sku_stock.sold_unit += return_disposal.number
                        sku_stock.save
                        return_disposal.stock_id = sku_stock.id
                        return_disposal.save
                        break
                      end
                    end
                  end
                end
                break
              end                        
            end
          end #87行目 if pladmin.sale_amount.present? && pladmin.sale_amount > 0 && owned_number > 0, 149行目 elsif pladmin.sale_amount.present? && pladmin.sale_amount < 0    
        end #72行目 @sku_stocks.each do |sku_stock|
      end #61行目 if @sku_stocks.blank? && @only_stock.blank? 
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
      @stockledger = current_user.stockledgers.create(stock_id: stock.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: stock.asin, goods_name: pladmin.goods_name, classification: "販売", number: pladmin.quantity * -1, unit_price: price_unit, grandtotal: price_unit * pladmin.quantity * -1)
      pladmin.stock_id = stock.id      
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
      @stockledger = current_user.stockledgers.create(stock_id: stock.id, transaction_date: pladmin.date,sku: pladmin.sku, asin: stock.asin, goods_name: pladmin.goods_name, classification: "キャンセル", number: pladmin.quantity, unit_price: price_unit, grandtotal: price_unit * pladmin.quantity)
      pladmin.stock_id = stock.id       
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
      disposals = current_user.disposals.where(sku: pladmin.sku)
      if disposals.present?
        disposals.each do |disposal|
          if !stock.soldout_check
            @disposal_stockledger = current_user.stockledgers.create(stock_id: stock.id, transaction_date: disposal.date, sku: disposal.sku, asin: stock.asin, goods_name: stock.goods_name, classification: "廃棄", number: disposal.number * -1, unit_price: price_unit, grandtotal: price_unit * disposal.number * -1)
            stock.sold_unit += disposal.number
            stock.save
            disposal.stock_id = stock.id
            disposal.save
            break
          end
        end                
      end

  #@sku_stocksが一つで、pladmin.sale_amountがマイナスで、return_goodsがあり、return_goodsの新SKUと一致するdisposalsがある           
      return_goods = current_user.return_goods.where(old_sku: pladmin.sku)
      if return_goods.present? 
        return_goods.each do |return_good|                     
          return_disposals = current_user.disposals.where(sku: return_good.new_sku)
          if return_disposals.present?
            return_disposals.each do |return_disposal|
              if !stock.soldout_check
                current_user.stockledgers.create(stock_id: stock.id, transaction_date: return_disposal.date, sku: return_disposal.sku, asin: stock.asin, goods_name: stock.goods_name, classification: "廃棄", number: return_disposal.number * -1, unit_price: price_unit, grandtotal: price_unit * return_disposal.number * -1)
                stock.sold_unit += return_disposal.number
                stock.save
                return_disposal.stock_id = stock.id
                return_disposal.save                    
                break 
              end
            end           
          end
          break
        end
      end
    end #223行目 if pladmin.sale_amount.present? && pladmin.sale_amount > 0 && owned_number > 0,239行目 elsif pladmin.sale_amount.present? && pladmin.sale_amount < 0 
  end #212行目 def single_sku_stock(stock, pladmin)
  

  #端数処理
  def rounding_fraction
    @stocks = current_user.stocks.all
    @stocks.each do |stock|
      if stock.stockledgers.sum(:number) == 0 && stock.stockledgers.sum(:grandtotal) != 0
        stock_fraction = stock.stockledgers.sum(:grandtotal)
        target_stockledgers = stock.stockledgers.where.not(classification: "購入")
        target_stockledgers = target_stockledgers.where.not(classification: "返還")
        target_stockledgers = target_stockledgers.where.not(classification: "SKU付替")
        target_stockledgers = target_stockledgers.where.not(classification: "廃棄")
        target_stockledgers = target_stockledgers.where.not(classification: "仕入返品")
        target_stockledger = target_stockledgers.order(:transaction_date).last
        new_grandtotal = target_stockledger.grandtotal - stock_fraction
        target_stockledger.grandtotal = new_grandtotal
        target_stockledger.save
        
        target_pladmin = current_user.pladmins.where(stock_id: stock.id).order(:date).last
        new_cgs_amount = target_pladmin.cgs_amount + stock_fraction
        target_pladmin.cgs_amount = new_cgs_amount
        target_pladmin.save
      end            
    end
  end  
end
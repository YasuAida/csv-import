module DummyStocksHelper
  def add_stockledgers(dummy_stock)
    @base_stock = Stock.find(dummy_stock.stock_id)
    ex_price_unit = @base_stock.grandtotal / @base_stock.number
    price_unit = BigDecimal(ex_price_unit.to_s).round(0)
    
    sale_pladmin=Pladmin.find_by(date: dummy_stock.sale_date, sku: @base_stock.sku)
    if sale_pladmin.present?
      @sale_stockledger = Stockledger.create(stock_id: dummy_stock.stock_id, transaction_date: sale_pladmin.date,sku: sale_pladmin.sku, asin: @base_stock.asin, goods_name: sale_pladmin.goods_name, classification: "販売", number: dummy_stock.number * -1, unit_price: price_unit, grandtotal: price_unit * dummy_stock.number * -1)
      sale_pladmin.cgs_amount = price_unit * dummy_stock.number
      sale_pladmin.save
    else
      redirect_to dummy_stocks_path , notice: '該当する仕入ID、または販売日の明細が確認できません'
    end
    
    cancel_pladmin=Pladmin.find_by(date: dummy_stock.cancel_date, sku: @base_stock.sku)
    if cancel_pladmin.present?
      @cancel_stockledger = Stockledger.find_by(transaction_date: dummy_stock.cancel_date, sku: @base_stock.sku)
      if @cancel_stockledger.present?
        @cancel_stockledger.update(stock_id: dummy_stock.stock_id, transaction_date: cancel_pladmin.date,sku: cancel_pladmin.sku, asin: @base_stock.asin, goods_name: cancel_pladmin.goods_name, classification: "キャンセル", number: dummy_stock.number, unit_price: price_unit, grandtotal: price_unit * dummy_stock.number)
      end
      cancel_pladmin.cgs_amount = price_unit * dummy_stock.number * -1
      cancel_pladmin.save
    else
      redirect_to dummy_stocks_path , notice: '該当する仕入ID、またはキャンセル日の明細が確認できません'      
    end
    
    stock_fraction = @base_stock.stockledgers.sum(:grandtotal)
    new_grandtotal = @base_stock.stockledgers.where.not(classification: "購入").order(:transaction_date).last.grandtotal - stock_fraction
    target_stockledger = @base_stock.stockledgers.where.not(classification: "購入").order(:transaction_date).last
    target_stockledger.grandtotal = new_grandtotal
    target_stockledger.save
    
    target_pladmin = Pladmin.where(stock_id: @base_stock.id).order(:date).last
    if target_pladmin.present?
      target_pladmin.cgs_amount = new_grandtotal * -1
      target_pladmin.save
    end    
  end
end

class StockledgersController < ApplicationController
  def index
    @pladmins = Pladmin.all
    @pladmins.each do |pladmin|

      @sku_stocks = Stock.where(sku: pladmin.sku).order(:purchase_date)
      unless @sku_stocks.any?
        pladmin.cgs_amount = 0
        pladmin.save        
      else
        if @sku_stocks.count == 1 
          ex_price_unit = @sku_stocks.first.grandtotal / @sku_stocks.first.number
          price_unit = BigDecimal(ex_price_unit.to_s).round(0)
          @stockledger = Stockledger.new(sold_date: pladmin.date,sku: pladmin.sku, asin: @sku_stocks.first.asin, goods_name: pladmin.goods_name, number: -1, grandtotal: price_unit * -1)
          pladmin.cgs_amount = price_unit
          @stockledger.save
          pladmin.save
        
        else
          @sku_ledger = Stockledger.find_by(sku: @sku_stocks.first.sku)
            if @sku_ledger.present?
              sku_ary = []
              sku_ary << @sku_ledger
              sku_ledger_number = sku_ary.count
            else
              sku_ledger_number = 0
            end

          @sku_stocks.each do |sku_stock|
            if sku_stock.number > sku_ledger_number
              ex_price_unit = sku_stock.grandtotal / sku_stock.number
              price_unit = BigDecimal(ex_price_unit.to_s).round(0)
              @stockledger = Stockledger.new(sold_date: pladmin.date,sku: pladmin.sku, asin: @sku_stocks.first.asin, goods_name: pladmin.goods_name, number: -1, grandtotal: price_unit * -1)
              pladmin.cgs_amount = price_unit
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
end


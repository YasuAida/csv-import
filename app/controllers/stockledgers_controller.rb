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
          @stockledger = Stockledger.new(transaction_date: pladmin.date,sku: pladmin.sku, asin: @sku_stocks.first.asin, goods_name: pladmin.goods_name, classification: "販売", number: -1, unit_price: price_unit, grandtotal: price_unit * -1)
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
              @stockledger = Stockledger.new(transaction_date: pladmin.date,sku: pladmin.sku, asin: @sku_stocks.first.asin, goods_name: pladmin.goods_name, classification: "販売", number: -1, unit_price: price_unit, grandtotal: price_unit * -1)
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
    
    Stock.all.each do |stock|
      @stockledger = Stockledger.new(transaction_date: stock.purchase_date, sku: stock.sku, asin: stock.asin, goods_name: stock.goods_name, classification: "購入", number: stock.number, unit_price: (stock.grandtotal)/(stock.number), grandtotal: stock.grandtotal)
      @stockledger.save
    end
    
    @q = Stockledger.search(params[:q])
    @stockledgers = @q.result(distinct: true).order(:transaction_date)
  end
  
  def stock_list
    @stock_lists = Stockledger.all.group(:sku).order(:transaction_date)
    
  end
end


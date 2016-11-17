class MultiChannelsController < ApplicationController
  def index
    @multi_channels = MultiChannel.all  
  end
  
  def update
    @multi_channel = MultiChannel.find_by(order_num: params[:multi_channel][:order_num])
    @multi_channel.sku = params[:multi_channel][:sku]
    @multi_channel.save
    
    redirect_to multi_channels_index_path , notice: '保存しました'
  end
  
  def import
    MultiChannel.all.each do |multi|
      #損益管理シートへSKUと商品名を入力
        pladmin = Pladmin.find_by(order_num: multi.order_num)
        pladmin.sku = multi.sku
        target_stock = Stock.where(sku: multi.sku).first
        pladmin.goods_name = target_stock.goods_name if target_stock.present?
        pladmin.save
      #商品有高帳へ記入
        @sku_stocks = Stock.where(sku: multi.sku).order(:purchase_date)
        pladmin = Pladmin.find_by(order_num: multi.order_num)
        unless @sku_stocks.any?
        else
          if @sku_stocks.count == 1 
            ex_price_unit = @sku_stocks.first.grandtotal / @sku_stocks.first.number
            price_unit = BigDecimal(ex_price_unit.to_s).round(0)
            @stockledger = Stockledger.new(transaction_date: pladmin.date,sku: multi.sku, asin: @sku_stocks.first.asin, goods_name: @sku_stocks.first.goods_name, classification: "販売", number: -1, unit_price: price_unit, grandtotal: price_unit * -1)
            @stockledger.save
  
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
                @stockledger = Stockledger.new(transaction_date: pladmin.date,sku: multi.sku, asin: @sku_stocks.first.asin, goods_name: @sku_stocks.first.goods_name, classification: "販売", number: -1, unit_price: price_unit, grandtotal: price_unit * -1)
                @stockledger.save
                break
              else
                sku_ledger_number =  sku_ledger_number - sku_stock.number
              end
            end
          end
        end
    end
    redirect_to multi_channels_index_path , notice: '保存しました'
  end
  
  private
  def multi_channel_params
    params.require(:multi_channel).permit(:order_num, :sku)
  end
  
end

class ReturnGoodsController < ApplicationController
  before_action :set_return_good, only: [ :update, :destroy] 
  
  def index
    @return_good = ReturnGood.new   
    @return_goods = ReturnGood.all 
  end
  
  def create
    @return_good = ReturnGood.new(return_good_params)
    @return_good.save
    redirect_to return_goods_path , notice: '保存しました'    
  end
  
  def update
    if @return_good.update(return_good_params)
      redirect_to return_goods_path , notice: '保存しました'
    end
  end
  
  #返還商品についてstockledgersテーブルにデータを入力する
  def import
    ReturnGood.all.each do |return_good|
      #返還商品の返還前SKUを持つ在庫をstocksテーブルの中から抽出する
        @sku_stocks = Stock.where(sku: return_good.old_sku).order(:purchase_date)
      #返還日時を把握するため、salesテーブルの中から返還商品の注文番号に一致するレコードを見つける
        @date_sale = Sale.find_by(order_num: return_good.order_num)
      #返還前SKUを持つ在庫がなければ何もしない
        unless @sku_stocks.any?
        else
      #返還前SKUを持つ在庫が一つならば、その在庫のデータを使ってstockledgersテーブルにレコードを作成する         
          if @sku_stocks.count == 1 
            ex_price_unit = @sku_stocks.first.grandtotal / @sku_stocks.first.number
            price_unit = BigDecimal(ex_price_unit.to_s).round(0)
            @stockledger = Stockledger.new(transaction_date: @date_sale.date,sku: return_good.old_sku, asin: @sku_stocks.first.asin, goods_name: @sku_stocks.first.goods_name, classification: "返還", number: return_good.number * -1, unit_price: price_unit, grandtotal: price_unit * -1)
            @stockledger.save

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
                sku_ary << @sale_stock
                sku_ary << @return_stock
                sku_ledger_number = sku_ary.count               
              else
                sku_ledger_number = 0
              end
      #個数を数えた後、日付の古いものから順番に売れたものを引いていって、現在どのSKUが残っているか調べた後、その在庫のデータを使ってstockledgersテーブルにレコードを作成する。
            @sku_stocks.each do |sku_stock|
              if sku_stock.number > sku_ledger_number
                ex_price_unit = sku_stock.grandtotal / sku_stock.number
                price_unit = BigDecimal(ex_price_unit.to_s).round(0)
                @stockledger = Stockledger.new(transaction_date: @date_sale.date,sku: return_good.old_sku, asin: @sku_stocks.first.asin, goods_name: @sku_stocks.first.goods_name, classification: "返還", number: return_good.number * -1, unit_price: price_unit, grandtotal: price_unit * -1)
                @stockledger.save
                break
              else
                sku_ledger_number =  sku_ledger_number - sku_stock.number
              end
            end
          end
        end
    end
    redirect_to return_goods_path , notice: '商品有高帳にデータを転記しました'
  end
  
  def destroy
    @return_good.destroy
    redirect_to return_goods_path, notice: 'データを削除しました'
  end
  
  private
  def return_good_params
    params.require(:return_good).permit(:order_num, :old_sku, :new_sku, :number, :disposal)
  end
  
  def set_return_good
    @return_good = ReturnGood.find(params[:id])
  end
  
end
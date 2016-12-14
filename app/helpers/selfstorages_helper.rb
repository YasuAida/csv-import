module SelfstoragesHelper
  def attachment_of_stock_id(selfstorage)
  #廃棄商品のSKUを持つ在庫をstocksテーブルの中から抽出する
  #無ければReturnGoodを通してold_skuを把握し、old_skuを持つ在庫をstocksテーブルの中から抽出する
    if Stock.find_by(sku: selfstorage.sku).present?    
      @sku_stocks = Stock.where(sku: selfstorage.sku).order(:date)
    else
      return_good = ReturnGood.find_by(new_sku: selfstorage.sku)
      @sku_stocks = Stock.where(sku: return_good.old_sku).order(:date) if return_good.present?
    end    
    
    if @sku_stocks.blank?
    else
      if @sku_stocks.count == 1
        selfstorage.stock_id = @sku_stocks.first.id
        selfstorage.save 
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
          if sku_stock.number > sku_ledger_number
            selfstorage.stock_id = sku_stock.id 
            break
          else
            sku_ledger_number =  sku_ledger_number - sku_stock.number
          end
        end
        selfstorage.save
      end
    end  
  end
end

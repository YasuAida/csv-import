module SelfstoragesHelper
  def attachment_of_stock_id(selfstorage)
  #廃棄商品のSKUを持つ在庫をstocksテーブルの中から抽出する
  #無ければReturnGoodを通してold_skuを把握し、old_skuを持つ在庫をstocksテーブルの中から抽出する
    if Stock.find_by(sku: selfstorage.sku).present?    
      finding_stock = Stock.find_by(sku: selfstorage.sku)
      selfstorage.stock_id = finding_stock.id if finding_stock.present?
      selfstorage.save
    else
      finding_return = ReturnGood.find_by(new_sku: selfstorage.sku)
      selfstorage.stock_id = finding_return.stock_id if finding_return.present?
      selfstorage.save      
    end       
  end
end

csv_data = CSV.generate do |csv|
  csv_column_names = ["注文番号","注文日","売上日","SKU","商品名","カード種別","PC/MOBILE","単価","個数","送料","消費税","代引手数料","ポイント付与額","決済方法"]
  csv << csv_column_names
end

csv_data.encode(Encoding::SJIS)
csv_data = CSV.generate do |csv|
  csv_column_names = ["日付","SKU","ASIN","商品名","単価","個数","支払日","送料支払日","購入先","通貨"]
  csv << csv_column_names
end

csv_data.encode(Encoding::SJIS)
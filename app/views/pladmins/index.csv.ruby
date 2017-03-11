csv_data = CSV.generate do |csv|
  csv_column_names = ["日付","注文番号","SKU","商品名","売上先","売上高","手数料","送料","入金日","手数料支払日","送料支払日"]
  csv << csv_column_names
end

csv_data.encode(Encoding::SJIS)
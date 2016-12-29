csv_data = CSV.generate do |csv|
  csv_column_names = ["日付","勘定科目","金額(外貨)","支払日","購入先","通貨","摘要"]
  csv << csv_column_names
end

csv_data.encode(Encoding::SJIS)
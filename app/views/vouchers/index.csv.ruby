csv_data = CSV.generate do |csv|
  csv_column_names = ["日付","借方勘定科目","借方補助科目","借方税コード","貸方勘定科目","貸方補助科目","貸方税コード","金額","摘要","取引先"]
  csv << csv_column_names
end

csv_data.encode(Encoding::SJIS)
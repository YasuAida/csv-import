csv_data = CSV.generate do |csv|
  csv_column_names = ["日付"]
  @currencies.each do |currency|
    csv_column_names << currency.name
  end
  csv << csv_column_names
end

csv_data.encode(Encoding::SJIS)
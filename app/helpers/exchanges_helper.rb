module ExchangesHelper
  def file_open(file_name)
    File.open('./tmp/exchange/'+ file_name.original_filename, 'wb') do |file|
      file.write(file_name.read)
    end
  end
  
  def file_import_exchange(file_name)
  # 先にDBのカラム名を用意
    @column = ["日付"]
    current_user.currencies.all.each do |currency|
      if currency.name != "円"
        @column.push(currency.name)
      end
    end

    CSV.foreach('./tmp/exchange/'+ file_name.original_filename, encoding: "Shift_JIS:UTF-8", headers: true) do |row|
    # rowの値のみを配列化
      row_value = row.to_h.values
    # Zipで合体後にハッシュ化
      row_hash = @column.zip(row_value).to_h
  
      @date = row_hash.shift[1]
      exchange_hash = row_hash
      exchange_hash.each do |exchange|
        data = current_user.exchanges.build
        data.date = Date.parse(@date).to_date
        data.country = exchange[0]
        data.rate = exchange[1]
        if data.save
        else
          old_data = current_user.exchanges.find_by(country: data.country, date: data.date)
          old_data.update(rate: data.rate) if old_data
        end
      end
    end
  end
  
  def file_close(file_name)
    File.delete('./tmp/exchange/' + file_name.original_filename)
  end
end

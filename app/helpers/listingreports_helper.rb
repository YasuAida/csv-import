module ListingreportsHelper

  def file_open(file_name)
    File.open('./tmp/listingreport/'+ file_name.original_filename, 'wb') do |file|
      file.write(file_name.read)
    end
  end

  def file_import_listingreport(file_name)
    File.open('./tmp/listingreport/'+ file_name.original_filename, 'r') do |file|
      file.each_line.with_index(1) do |line, index|
        if index == 1
          @col_line = [:sku, :asin, :price, :quantity]
        else
#begin
          decorate_line = @col_line.zip(line.gsub(/\r\n/, "").split(/\t/))
#rescue =>e
#          binding.pry
#          decorate_line = @col_line.zip(line.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z').gsub(/\r\n/, "").split(/\t/))
#end
          line_hash = Hash[*decorate_line.flatten]
          line_hash[:price] = line_hash[:price].to_i
          line_hash[:quantity] = line_hash[:quantity].to_i

          current_user.listingreports.create(line_hash)
        end
      end
    end
  end

  def file_close(file_name)
    File.delete('./tmp/listingreport/' + file_name.original_filename)
  end
end
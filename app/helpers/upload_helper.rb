module UploadHelper

  def file_open(file_name)
    File.open('./tmp/cache/'+ file_name.original_filename, 'wb') do |file|
      file.write(file_name.read)
    end
  end

  def file_import_transaction(file_name)
    File.open('./tmp/cache/'+ file_name.original_filename, 'r') do |file|
      file.each_line.with_index(1) do |line, index|
        if ( index == 1 || index == 2 || index == 3 )
        elsif index == 4
          @col_line = [:date, :order_num, :SKU, :kind_of_transaction, :kind_of_payment, :detail_of_payment, :amount, :quantity, :goods_name, :money_receive]
        else
          ex_line = line.gsub(/\t{3}/, "\t \t \t")
          decorate_line = @col_line.zip(ex_line.gsub(/\t{2}/, "\t \t").gsub(/\r\n/, "").gsub(/,/, "").split(/\t/))
          line_hash = Hash[*decorate_line.flatten]
          line_hash[:amount] = line_hash[:amount].gsub!(/¥|￥/, "").to_i
          line_hash[:quantity] = line_hash[:quantity].to_i

          money_receive_date = file_name.original_filename.gsub(/.txt/,"")
          line_hash[:money_receive] = Date.parse(money_receive_date).to_date
    
          Sale.create(line_hash)
        end
      end
    end
  end

  def file_close(file_name)
    File.delete('./tmp/cache/' + file_name.original_filename)
  end  
end

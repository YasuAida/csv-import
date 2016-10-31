module StockacceptsHelper
  def file_open(file_name)
    File.open('./tmp/stockaccept/'+ file_name.original_filename, 'wb') do |file|
      file.write(file_name.read)
    end
  end

  def file_import_stockaccept(file_name)
    require 'kconv'

    File.open('./tmp/stockaccept/'+ file_name.original_filename, 'r') do |file|
      file.each_line.with_index(1) do |line, index|
        line = line.toutf8
        if index == 1
          @col_line = [:date, :fnsku, :sku, :goods_name,:quantity,:fba_number,:fc, :asin]
        else
          decorate_line = @col_line.zip(line.gsub(/\r\n/, "").split(/\t/))
          line_hash = Hash[*decorate_line.flatten]
          line_hash[:date] = Date.parse(line_hash[:date]).to_date
          line_hash[:quantity] = line_hash[:quantity].to_i
          
          Stockaccept.create(line_hash)
        end
      end
    end
  end

  def file_close(file_name)
    File.delete('./tmp/stockaccept/' + file_name.original_filename)
  end
  
  def sku_addition_to_stockaccept
    @stockaccepts = Stockaccept.all
    @stockaccepts.each do |stockaccept|
      @listingreports = Listingreport.where(sku: stockaccept.sku)
      if @listingreports.present?
        stockaccept.asin = @listingreports.first.asin
      end
    end
  end
end
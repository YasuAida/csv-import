module RakutenCostsHelper
  def file_open(file_name)
    File.open('./tmp/rakuten/'+ file_name.original_filename, 'wb') do |file|
      file.write(file_name.read)
    end
  end
    
  def file_import_pc_list(file_name)
    require 'kconv'

    File.open('./tmp/rakuten_cost/'+ file_name.original_filename, 'r') do |file|
      file.each_line.with_index(1) do |line, index|
        line = line.toutf8
        if index == 1
          @col_line = [:order_num, :total_sales, :flag, :auction, :abroad, :vest_point, :vest_auction, :vest_mobile_auction ]
        else
          decorate_line = @col_line.zip(line.gsub(/\r\n/, "").split(","))
          line_hash = Hash[*decorate_line.flatten]
          line_hash[:total_sales] = line_hash[:total_sales].to_i if line_hash[:total_sales].present?          
          line_hash[:vest_point] = line_hash[:vest_point].to_i if line_hash[:vest_point].present?

          current_user.rakuten_temps.create(order_num: line_hash[:order_num], total_sales: line_hash[:total_sales])    
        end
      end
    end
  end
  
  def file_import_mobile_list(file_name)
    require 'kconv'

    File.open('./tmp/rakuten_cost/'+ file_name.original_filename, 'r') do |file|
      file.each_line.with_index(1) do |line, index|
        line = line.toutf8
        if index == 1
          @col_line = [:order_num, :total_sales, :flag, :vest_point]
        else
          decorate_line = @col_line.zip(line.gsub(/\r\n/, "").split(","))
          line_hash = Hash[*decorate_line.flatten]
          line_hash[:total_sales] = line_hash[:total_sales].to_i if line_hash[:total_sales].present?          
          line_hash[:vest_point] = line_hash[:vest_point].to_i if line_hash[:vest_point].present?

          current_user.rakuten_temps.create(order_num: line_hash[:order_num], total_sales: line_hash[:total_sales])           
        end
      end
    end
  end
  
  def file_close(file_name)
    File.delete('./tmp/rakuten/' + file_name.original_filename)
  end
end

class TopPagesController < ApplicationController
  include TopPagesHelper
  before_action :logged_in_user
  require 'zip'
  
  def index
    @period = current_user.periods.new  
  end
  
  def download
    zipfile_name = "#{Rails.root}/tmp/top_page/csv.zip"
  
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      zipfile.get_output_stream("accounts.csv") { |f| f.puts(current_user.accounts.to_download) }      
      zipfile.get_output_stream("allocationcosts.csv") { |f| f.puts(current_user.allocationcosts.to_download) }
      zipfile.get_output_stream("currencies.csv") { |f| f.puts(current_user.currencies.to_download) }
      zipfile.get_output_stream("disposals.csv") { |f| f.puts(current_user.disposals.to_download) }
      zipfile.get_output_stream("dummy_stocks.csv") { |f| f.puts(current_user.dummy_stocks.to_download) }      
      zipfile.get_output_stream("entrypatterns.csv") { |f| f.puts(current_user.entrypatterns.to_download) }
      zipfile.get_output_stream("exchanges.csv") { |f| f.puts(current_user.exchanges.to_download) }
      zipfile.get_output_stream("expense_methods.csv") { |f| f.puts(current_user.expense_methods.to_download) }
      zipfile.get_output_stream("expense_relations.csv") { |f| f.puts(current_user.expense_relations.to_download) }
      zipfile.get_output_stream("expense_titles.csv") { |f| f.puts(current_user.expense_titles.to_download) }
      zipfile.get_output_stream("expenseledgers.csv") { |f| f.puts(current_user.expenseledgers.to_download) }
      zipfile.get_output_stream("financial_statements.csv") { |f| f.puts(current_user.financial_statements.to_download) }      
      zipfile.get_output_stream("generalledgers.csv") { |f| f.puts(current_user.generalledgers.to_download) }
      zipfile.get_output_stream("journalpatterns.csv") { |f| f.puts(current_user.journalpatterns.to_download) }
      zipfile.get_output_stream("listingreports.csv") { |f| f.puts(current_user.listingreports.to_download) }
      zipfile.get_output_stream("multi_channels.csv") { |f| f.puts(current_user.multi_channels.to_download) }
      zipfile.get_output_stream("periods.csv") { |f| f.puts(current_user.periods.to_download) }
      zipfile.get_output_stream("pladmins.csv") { |f| f.puts(current_user.pladmins.to_download) }
      zipfile.get_output_stream("point_coupons.csv") { |f| f.puts(current_user.point_coupons.to_download) }      
      zipfile.get_output_stream("rakuten_costs.csv") { |f| f.puts(current_user.rakuten_costs.to_download) }   
      zipfile.get_output_stream("rakuten_settings.csv") { |f| f.puts(current_user.rakuten_settings.to_download) }      
      zipfile.get_output_stream("rakutens.csv") { |f| f.puts(current_user.rakutens.to_download) }
      zipfile.get_output_stream("return_goods.csv") { |f| f.puts(current_user.return_goods.to_download) }
      zipfile.get_output_stream("sales.csv") { |f| f.puts(current_user.sales.to_download) }
      zipfile.get_output_stream("selfstorages.csv") { |f| f.puts(current_user.selfstorages.to_download) }      
      zipfile.get_output_stream("stockaccepts.csv") { |f| f.puts(current_user.stockaccepts.to_download) }
      zipfile.get_output_stream("stockledgers.csv") { |f| f.puts(current_user.stockledgers.to_download) }
      zipfile.get_output_stream("stockreturns.csv") { |f| f.puts(current_user.stockreturns.to_download) }      
      zipfile.get_output_stream("stocks.csv") { |f| f.puts(current_user.stocks.to_download) }
      zipfile.get_output_stream("subexpenses.csv") { |f| f.puts(current_user.subexpenses.to_download) }
      zipfile.get_output_stream("users.csv") { |f| f.puts(User.to_download) }      
      zipfile.get_output_stream("vouchers.csv") { |f| f.puts(current_user.vouchers.to_download) }
      zipfile.get_output_stream("yafuokus.csv") { |f| f.puts(current_user.yafuokus.to_download) }      
      zipfile.get_output_stream("yahoo_shoppings.csv") { |f| f.puts(current_user.yahoo_shoppings.to_download) }      
    end
    
    send_file(zipfile_name, type: 'application/zip' , filename: "csv.zip")
  end
  
  def upload
    data = params[:upload]

    data[:datafile].each do |datafile|
      file_open(datafile)

    #ファイルのインポート    
      case datafile.original_filename
        when "accounts.csv" then
          accounts_import(datafile)
        when "allocationcosts.csv" then
          allocationcosts_import(datafile)
        when "currencies.csv" then
          currencies_import(datafile)
        when "disposals.csv" then
          disposals_import(datafile)
        when "dummy_stocks.csv" then
          dummy_stocks_import(datafile)          
        when "entrypatterns.csv" then
          entrypatterns_import(datafile) 
        when "exchanges.csv" then
          exchanges_import(datafile)
        when "expense_methods.csv" then
          expense_methods_import(datafile)
        when "expense_relations.csv" then
          expense_relations_import(datafile)
        when "expense_titles.csv" then
          expense_titles_import(datafile)
        when "expenseledgers.csv" then
          expenseledgers_import(datafile)
        when "financial_statements.csv" then
          financial_statements_import(datafile)
        when "generalledgers.csv" then
          generalledgers_import(datafile) 
        when "journalpatterns.csv" then
          journalpatterns_import(datafile) 
        when "listingreports.csv" then
          listingreports_import(datafile) 
        when "multi_channels.csv" then
          multi_channels_import(datafile)
        when "periods.csv" then
          periods_import(datafile)          
        when "pladmins.csv" then
          pladmins_import(datafile)
        when "point_coupons.csv" then
          point_coupons_import(datafile)
        when "rakuten_costs.csv" then
          rakuten_costs_import(datafile)
        when "rakuten_settings.csv" then
          rakuten_settings_import(datafile)
        when "rakutens.csv" then
          rakutens_import(datafile) 
        when "return_goods.csv" then
          return_goods_import(datafile)       
        when "sales.csv" then
          sales_import(datafile) 
        when "selfstorages.csv" then
          selfstorages_import(datafile)           
        when "stockaccepts.csv" then
          stockaccepts_import(datafile) 
        when "stockledgers.csv" then
          stockledgers_import(datafile)
         when "stockreturns.csv" then
          stockreturns_import(datafile)         
        when "stocks.csv" then
          stocks_import(datafile) 
        when "subexpenses.csv" then
          subexpenses_import(datafile)
        when "users.csv" then
          users_import(datafile) 
        when "vouchers.csv" then
          vouchers_import(datafile)
        when "yafuokus.csv" then
          yafuokus_import(datafile) 
        when "yahoo_shoppings.csv" then
          yahoo_shoppings_import(datafile) 
      end 
    #ファイルの削除
      file_close(datafile)
    end

    redirect_to top_pages_path
  end
  
end
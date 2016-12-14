class TopPagesController < ApplicationController
  include TopPagesHelper
  require 'zip'
  
  def index
    @period = Period.new  
  end
  
  def download
    zipfile_name = "#{Rails.root}/tmp/top_page/csv.zip"
  
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      zipfile.get_output_stream("accounts.csv") { |f| f.puts(Account.to_download) }      
      zipfile.get_output_stream("allocationcosts.csv") { |f| f.puts(Allocationcost.to_download) }
      zipfile.get_output_stream("currencies.csv") { |f| f.puts(Currency.to_download) }
      zipfile.get_output_stream("disposals.csv") { |f| f.puts(Disposal.to_download) }      
      zipfile.get_output_stream("entrypatterns.csv") { |f| f.puts(Entrypattern.to_download) }
      zipfile.get_output_stream("exchanges.csv") { |f| f.puts(Exchange.to_download) }
      zipfile.get_output_stream("expense_methods.csv") { |f| f.puts(ExpenseMethod.to_download) }
      zipfile.get_output_stream("expense_relations.csv") { |f| f.puts(ExpenseRelation.to_download) }
      zipfile.get_output_stream("expense_titles.csv") { |f| f.puts(ExpenseTitle.to_download) }
      zipfile.get_output_stream("expenseledgers.csv") { |f| f.puts(Expenseledger.to_download) }
      zipfile.get_output_stream("financial_statements.csv") { |f| f.puts(FinancialStatement.to_download) }      
      zipfile.get_output_stream("generalledgers.csv") { |f| f.puts(Generalledger.to_download) }
      zipfile.get_output_stream("journalpatterns.csv") { |f| f.puts(Journalpattern.to_download) }
      zipfile.get_output_stream("listingreports.csv") { |f| f.puts(Listingreport.to_download) }
      zipfile.get_output_stream("multi_channels.csv") { |f| f.puts(MultiChannel.to_download) }
      zipfile.get_output_stream("periods.csv") { |f| f.puts(Period.to_download) }
      zipfile.get_output_stream("pladmins.csv") { |f| f.puts(Pladmin.to_download) }
      zipfile.get_output_stream("return_goods.csv") { |f| f.puts(ReturnGood.to_download) }
      zipfile.get_output_stream("sales.csv") { |f| f.puts(Sale.to_download) }
      zipfile.get_output_stream("selfstorages.csv") { |f| f.puts(Selfstorage.to_download) }      
      zipfile.get_output_stream("stockaccepts.csv") { |f| f.puts(Stockaccept.to_download) }
      zipfile.get_output_stream("stockledgers.csv") { |f| f.puts(Stockledger.to_download) }
      zipfile.get_output_stream("stocks.csv") { |f| f.puts(Stock.to_download) }
      zipfile.get_output_stream("subexpenses.csv") { |f| f.puts(Subexpense.to_download) }
      zipfile.get_output_stream("users.csv") { |f| f.puts(User.to_download) }      
      zipfile.get_output_stream("vouchers.csv") { |f| f.puts(Voucher.to_download) }
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
        when "stocks.csv" then
          stocks_import(datafile) 
        when "subexpenses.csv" then
          subexpenses_import(datafile)
        when "users.csv" then
          users_import(datafile) 
        when "vouchers.csv" then
          vouchers_import(datafile) 
      end 
    #ファイルの削除
      file_close(datafile)
    end

    redirect_to top_pages_path
  end
  
end
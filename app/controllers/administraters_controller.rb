class AdministratersController < ApplicationController
  include AdministratersHelper
  require 'zip'
  
  def index

  end
  
  def admin_download
    zipfile_name = "#{Rails.root}/tmp/administrater/csv.zip"
  
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      zipfile.get_output_stream("accounts.csv") { |f| f.puts(Account.admin_download) }      
      zipfile.get_output_stream("allocationcosts.csv") { |f| f.puts(Allocationcost.admin_download) }
      zipfile.get_output_stream("currencies.csv") { |f| f.puts(Currency.admin_download) }
      zipfile.get_output_stream("disposals.csv") { |f| f.puts(Disposal.admin_download) }
      zipfile.get_output_stream("dummy_stocks.csv") { |f| f.puts(DummyStock.admin_download) }      
      zipfile.get_output_stream("entrypatterns.csv") { |f| f.puts(Entrypattern.admin_download) }
      zipfile.get_output_stream("exchanges.csv") { |f| f.puts(Exchange.admin_download) }
      zipfile.get_output_stream("expense_methods.csv") { |f| f.puts(ExpenseMethod.admin_download) }
      zipfile.get_output_stream("expense_relations.csv") { |f| f.puts(ExpenseRelation.admin_download) }
      zipfile.get_output_stream("expense_titles.csv") { |f| f.puts(ExpenseTitle.admin_download) }
      zipfile.get_output_stream("expenseledgers.csv") { |f| f.puts(Expenseledger.admin_download) }
      zipfile.get_output_stream("financial_statements.csv") { |f| f.puts(FinancialStatement.admin_download) }      
      zipfile.get_output_stream("generalledgers.csv") { |f| f.puts(Generalledger.admin_download) }
      zipfile.get_output_stream("journalpatterns.csv") { |f| f.puts(Journalpattern.admin_download) }
      zipfile.get_output_stream("listingreports.csv") { |f| f.puts(Listingreport.admin_download) }
      zipfile.get_output_stream("multi_channels.csv") { |f| f.puts(MultiChannel.admin_download) }
      zipfile.get_output_stream("periods.csv") { |f| f.puts(Period.admin_download) }
      zipfile.get_output_stream("pladmins.csv") { |f| f.puts(Pladmin.admin_download) }
      zipfile.get_output_stream("point_coupons.csv") { |f| f.puts(PointCoupon.admin_download) }      
      zipfile.get_output_stream("rakuten_costs.csv") { |f| f.puts(RakutenCost.admin_download) }   
      zipfile.get_output_stream("rakuten_settings.csv") { |f| f.puts(RakutenSetting.admin_download) }      
      zipfile.get_output_stream("rakutens.csv") { |f| f.puts(Rakuten.admin_download) }
      zipfile.get_output_stream("return_goods.csv") { |f| f.puts(ReturnGood.admin_download) }
      zipfile.get_output_stream("sales.csv") { |f| f.puts(Sale.admin_download) }
      zipfile.get_output_stream("selfstorages.csv") { |f| f.puts(Selfstorage.admin_download) }      
      zipfile.get_output_stream("stockaccepts.csv") { |f| f.puts(Stockaccept.admin_download) }
      zipfile.get_output_stream("stockledgers.csv") { |f| f.puts(Stockledger.admin_download) }
      zipfile.get_output_stream("stockreturns.csv") { |f| f.puts(Stockreturn.admin_download) }      
      zipfile.get_output_stream("stocks.csv") { |f| f.puts(Stock.admin_download) }
      zipfile.get_output_stream("subexpenses.csv") { |f| f.puts(Subexpense.admin_download) }
      zipfile.get_output_stream("users.csv") { |f| f.puts(User.admin_download) }      
      zipfile.get_output_stream("vouchers.csv") { |f| f.puts(Voucher.admin_download) }
      zipfile.get_output_stream("yafuokus.csv") { |f| f.puts(Yafuoku.admin_download) }      
      zipfile.get_output_stream("yahoo_shoppings.csv") { |f| f.puts(YahooShopping.admin_download) }      
    end
    
    send_file(zipfile_name, type: 'application/zip' , filename: "csv.zip")
  end
  
  def admin_upload
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

    redirect_to administraters_path
  end
end

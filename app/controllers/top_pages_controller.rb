class TopPagesController < ApplicationController
  include TopPagesHelper
  
  def index
    
  end
  
  def download_allocationcosts
    @allocationcosts = Allocationcost.all
    respond_to do |format|
      format.html
      format.csv { send_data @allocationcosts.to_download, type: 'text/csv; charset=shift_jis', filename: "allocationcosts.csv" }
    end
    #redirect_to download_currencies_top_pages_path
  end
  
  def download_currencies
    @currencies = Currency.all
    respond_to do |format|
      format.html
      format.csv { send_data @currencies.to_download, type: 'text/csv; charset=shift_jis', filename: "currencies.csv" }
    end
    #redirect_to download_entrypatterns_top_pages_path
  end

  def download_entrypatterns
    @entrypatterns = Entrypattern.all
    respond_to do |format|
      format.html
      format.csv { send_data @entrypatterns.to_download, type: 'text/csv; charset=shift_jis', filename: "entrypatterns.csv" }
    end
    #redirect_to download_exchanges_top_pages_path
  end
  
  def download_exchanges
    @exchanges = Exchange.all
    respond_to do |format|
      format.html
      format.csv { send_data @exchanges.to_download, type: 'text/csv; charset=shift_jis', filename: "exchanges.csv" }
    end
    #redirect_to download_expense_methods_top_pages_path
  end
  
  def download_expense_methods
    @expense_methods = ExpenseMethod.all
    respond_to do |format|
      format.html
      format.csv { send_data @expense_methods.to_download, type: 'text/csv; charset=shift_jis', filename: "expense_methods.csv" }
    end
    #redirect_to download_expense_relations_top_pages_path 
  end

  def download_expense_relations
    @expense_relations = ExpenseRelation.all
    respond_to do |format|
      format.html
      format.csv { send_data @expense_relations.to_download, type: 'text/csv; charset=shift_jis', filename: "expense_relations.csv" }
    end
    #redirect_to download_expense_titles_top_pages_path 
  end
  
  def download_expense_titles
    @expense_titles = ExpenseTitle.all
    respond_to do |format|
      format.html
      format.csv { send_data @expense_titles.to_download, type: 'text/csv; charset=shift_jis', filename: "expense_titles.csv" }
    end 
    #redirect_to download_expenseledgers_top_pages_path 
  end
  
  def download_expenseledgers
    @expenseledgers = Expenseledger.all
    respond_to do |format|
      format.html
      format.csv { send_data @expenseledgers.to_download, type: 'text/csv; charset=shift_jis', filename: "expenseledgers.csv" }
    end
    #redirect_to download_generalledgers_top_pages_path
  end

  def download_generalledgers
    @generalledgers = Generalledger.all
    respond_to do |format|
      format.html
      format.csv { send_data @generalledgers.to_download, type: 'text/csv; charset=shift_jis', filename: "generalledgers.csv" }
    end
    #redirect_to download_journalpatterns_top_pages_path
  end

  def download_journalpatterns
    @journalpatterns = Journalpattern.all
    respond_to do |format|
      format.html
      format.csv { send_data @journalpatterns.to_download, type: 'text/csv; charset=shift_jis', filename: "journalpatterns.csv" }
    end
    #redirect_to download_listingreports_top_pages_path
  end
  
  def download_listingreports
    @listingreports = Listingreport.all
    respond_to do |format|
      format.html
      format.csv { send_data @listingreports.to_download, type: 'text/csv; charset=shift_jis', filename: "listingreports.csv" }
    end
    #redirect_to download_multi_channels_top_pages_path
  end
  
  def download_multi_channels
    @multi_channels = MultiChannel.all
    respond_to do |format|
      format.html
      format.csv { send_data @multi_channels.to_download, type: 'text/csv; charset=shift_jis', filename: "multi_channels.csv" }
    end
    #redirect_to download_pladmins_top_pages_path
  end

  def download_pladmins
    @pladmins = Pladmin.all
    respond_to do |format|
      format.html
      format.csv { send_data @pladmins.to_download, type: 'text/csv; charset=shift_jis', filename: "pladmins.csv" }
    end
    #redirect_to download_return_goods_top_pages_path
  end

  def download_return_goods
    @return_goods = ReturnGood.all
    respond_to do |format|
      format.html
      format.csv { send_data @return_goods.to_download, type: 'text/csv; charset=shift_jis', filename: "return_goods.csv" }
    end
    #redirect_to download_sales_top_pages_path
  end

  def download_sales
    @sales = Sale.all
    respond_to do |format|
      format.html
      format.csv { send_data @sales.to_download, type: 'text/csv; charset=shift_jis', filename: "sales.csv" }
    end
    #redirect_to download_stockaccepts_top_pages_path
  end

  def download_stockaccepts
    @stockaccepts = Stockaccept.all
    respond_to do |format|
      format.html
      format.csv { send_data @stockaccepts.to_download, type: 'text/csv; charset=shift_jis', filename: "stockaccepts.csv" }
    end
    #redirect_to download_stockledgers_top_pages_path
  end

  def download_stockledgers
    @stockledgers = Stockledger.all
    respond_to do |format|
      format.html
      format.csv { send_data @stockledgers.to_download, type: 'text/csv; charset=shift_jis', filename: "stockledgers.csv" }
    end
    #redirect_to download_stocks_top_pages_path
  end    

  def download_stocks
    @stocks = Stock.all
    respond_to do |format|
      format.html
      format.csv { send_data @stocks.to_download, type: 'text/csv; charset=shift_jis', filename: "stocks.csv" }
    end
    #redirect_to download_subexpenses_top_pages_path
  end      

  def download_subexpenses
    @subexpenses = Subexpense.all
    respond_to do |format|
      format.html
      format.csv { send_data @subexpenses.to_download, type: 'text/csv; charset=shift_jis', filename: "subexpenses.csv" }
    end
    #redirect_to download_vouchers_top_pages_path
  end  

  def download_vouchers
    @vouchers = Voucher.all
    respond_to do |format|
      format.html
      format.csv { send_data @vouchers.to_download, type: 'text/csv; charset=shift_jis', filename: "vouchers.csv" }
    end
    #redirect_to top_pages_path
  end  
  
  def download
    #download_allocationcosts
    #download_currencies
    #download_entrypatterns
    #download_exchanges
    #download_expense_methods
    #download_expense_relations
    #download_expense_titles
    #download_expenseledgers
    #download_generalledgers
    #download_journalpatterns
    #download_listingreports
    #download_multi_channels
    #download_pladmins
    #download_return_goods
    #download_sales
    #download_stockaccepts
    #download_stockledgers
    #download_stocks
    #download_subexpenses
    #download_vouchers
  end
  
  def upload
    data = params[:upload]

    data[:datafile].each do |datafile|
      file_open(datafile)

    #ファイルのインポート    
      case datafile.original_filename
        when "allocationcosts.csv" then
          allocationcosts_import(datafile)
        when "currencies.csv" then
          currencies_import(datafile)      
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
        when "generalledgers.csv" then
          generalledgers_import(datafile) 
        when "journalpatterns.csv" then
          journalpatterns_import(datafile) 
        when "listingreports.csv" then
          listingreports_import(datafile) 
        when "multi_channels.csv" then
          multi_channels_import(datafile) 
        when "pladmins.csv" then
          pladmins_import(datafile)       
        when "return_goods.csv" then
          return_goods_import(datafile)       
        when "sales.csv" then
          sales_import(datafile) 
        when "stockaccepts.csv" then
          stockaccepts_import(datafile) 
        when "stockledgers.csv" then
          stockledgers_import(datafile) 
        when "stocks.csv" then
          stocks_import(datafile) 
        when "subexpenses.csv" then
          subexpenses_import(datafile) 
        when "vouchers.csv" then
          vouchers_import(datafile) 
      end 
    #ファイルの削除
      file_close(datafile)
    end

    redirect_to top_pages_path
  end
  
  def upload_
    @currencies = Currency.all
    respond_to do |format|
      format.html
      format.csv { send_data @currencies.to_download, type: 'text/csv; charset=shift_jis', filename: "currencies.csv" }
    end
    #redirect_to upload_entrypatterns_top_pages_path
  end

  def upload_entrypatterns
    @entrypatterns = Entrypattern.all
    respond_to do |format|
      format.html
      format.csv { send_data @entrypatterns.to_download, type: 'text/csv; charset=shift_jis', filename: "entrypatterns.csv" }
    end
    #redirect_to upload_exchanges_top_pages_path
  end
  
  def upload_exchanges
    @exchanges = Exchange.all
    respond_to do |format|
      format.html
      format.csv { send_data @exchanges.to_download, type: 'text/csv; charset=shift_jis', filename: "exchanges.csv" }
    end
    #redirect_to upload_expense_methods_top_pages_path
  end
  
  def upload_expense_methods
    @expense_methods = ExpenseMethod.all
    respond_to do |format|
      format.html
      format.csv { send_data @expense_methods.to_download, type: 'text/csv; charset=shift_jis', filename: "expense_methods.csv" }
    end
    #redirect_to upload_expense_relations_top_pages_path 
  end

  def upload_expense_relations
    @expense_relations = ExpenseRelation.all
    respond_to do |format|
      format.html
      format.csv { send_data @expense_relations.to_download, type: 'text/csv; charset=shift_jis', filename: "expense_relations.csv" }
    end
    #redirect_to upload_expense_titles_top_pages_path 
  end
  
  def upload_expense_titles
    @expense_titles = ExpenseTitle.all
    respond_to do |format|
      format.html
      format.csv { send_data @expense_titles.to_download, type: 'text/csv; charset=shift_jis', filename: "expense_titles.csv" }
    end 
    #redirect_to upload_expenseledgers_top_pages_path 
  end
  
  def upload_expenseledgers
    @expenseledgers = Expenseledger.all
    respond_to do |format|
      format.html
      format.csv { send_data @expenseledgers.to_download, type: 'text/csv; charset=shift_jis', filename: "expenseledgers.csv" }
    end
    #redirect_to upload_generalledgers_top_pages_path
  end

  def upload_generalledgers
    @generalledgers = Generalledger.all
    respond_to do |format|
      format.html
      format.csv { send_data @generalledgers.to_download, type: 'text/csv; charset=shift_jis', filename: "generalledgers.csv" }
    end
    #redirect_to upload_journalpatterns_top_pages_path
  end

  def upload_journalpatterns
    @journalpatterns = Journalpattern.all
    respond_to do |format|
      format.html
      format.csv { send_data @journalpatterns.to_download, type: 'text/csv; charset=shift_jis', filename: "journalpatterns.csv" }
    end
    #redirect_to upload_listingreports_top_pages_path
  end
  
  def upload_listingreports
    @listingreports = Listingreport.all
    respond_to do |format|
      format.html
      format.csv { send_data @listingreports.to_download, type: 'text/csv; charset=shift_jis', filename: "listingreports.csv" }
    end
    #redirect_to upload_multi_channels_top_pages_path
  end
  
  def upload_multi_channels
    @multi_channels = MultiChannel.all
    respond_to do |format|
      format.html
      format.csv { send_data @multi_channels.to_download, type: 'text/csv; charset=shift_jis', filename: "multi_channels.csv" }
    end
    #redirect_to upload_pladmins_top_pages_path
  end

  def upload_pladmins
    @pladmins = Pladmin.all
    respond_to do |format|
      format.html
      format.csv { send_data @pladmins.to_download, type: 'text/csv; charset=shift_jis', filename: "pladmins.csv" }
    end
    #redirect_to upload_return_goods_top_pages_path
  end

  def upload_return_goods
    @return_goods = ReturnGood.all
    respond_to do |format|
      format.html
      format.csv { send_data @return_goods.to_download, type: 'text/csv; charset=shift_jis', filename: "return_goods.csv" }
    end
    #redirect_to upload_sales_top_pages_path
  end

  def upload_sales
    @sales = Sale.all
    respond_to do |format|
      format.html
      format.csv { send_data @sales.to_download, type: 'text/csv; charset=shift_jis', filename: "sales.csv" }
    end
    #redirect_to upload_stockaccepts_top_pages_path
  end

  def upload_stockaccepts
    @stockaccepts = Stockaccept.all
    respond_to do |format|
      format.html
      format.csv { send_data @stockaccepts.to_download, type: 'text/csv; charset=shift_jis', filename: "stockaccepts.csv" }
    end
    #redirect_to upload_stockledgers_top_pages_path
  end

  def upload_stockledgers
    @stockledgers = Stockledger.all
    respond_to do |format|
      format.html
      format.csv { send_data @stockledgers.to_download, type: 'text/csv; charset=shift_jis', filename: "stockledgers.csv" }
    end
    #redirect_to upload_stocks_top_pages_path
  end    

  def upload_stocks
    @stocks = Stock.all
    respond_to do |format|
      format.html
      format.csv { send_data @stocks.to_download, type: 'text/csv; charset=shift_jis', filename: "stocks.csv" }
    end
    #redirect_to upload_subexpenses_top_pages_path
  end      

  def upload_subexpenses
    @subexpenses = Subexpense.all
    respond_to do |format|
      format.html
      format.csv { send_data @subexpenses.to_download, type: 'text/csv; charset=shift_jis', filename: "subexpenses.csv" }
    end
    #redirect_to upload_vouchers_top_pages_path
  end  

  def upload_vouchers
    @vouchers = Voucher.all
    respond_to do |format|
      format.html
      format.csv { send_data @vouchers.to_download, type: 'text/csv; charset=shift_jis', filename: "vouchers.csv" }
    end
    #redirect_to top_pages_path
  end  
end
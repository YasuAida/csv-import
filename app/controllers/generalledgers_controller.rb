class GeneralledgersController < ApplicationController
  include GeneralledgersHelper
  before_action :set_generalledger, only: [:edit, :update]
  before_action :logged_in_user

  def index
    @q = current_user.generalledgers.order(date: :desc).search(params[:q])
    @generalledgers = @q.result(distinct: true).page(params[:page]).per(100)      
      
    start_time = Time.now
    
    @journalpatterns = current_user.journalpatterns.all
    
    #「損益管理シート」から仕訳生成
     import_from_pladmins(@journalpatterns)
    
    #「仕入台帳」から仕訳生成  
     import_from_stocks(@journalpatterns)
     
    #「仕入返品台帳」から仕訳生成  
     import_from_stockreturns(@journalpatterns)     
    
    #「商品有高帳」から仕訳生成  
     import_from_stockledgers(@journalpatterns)
    
    #「付随費用」から仕訳生成
     import_from_subexpenses(@journalpatterns)
    
    #「経費帳」から仕訳生成
     import_from_expenseledgers(@journalpatterns) 
    
    #「振替台帳」から仕訳生成
     import_from_vouchers
    
    render 'show'
    
    p "処理概要 #{Time.now - start_time}s"

  end
  
  def show
    @q = current_user.generalledgers.order(date: :desc).search(params[:q])
    @generalledgers = @q.result(distinct: true).page(params[:page]).per(100)
    @all_generalledgers = current_user.generalledgers.all
    respond_to do |format|
      format.html
      format.csv { send_data @all_generalledgers.to_download, type: 'text/csv; charset=shift_jis', filename: "generalledgers.csv" } 
    end 
  end  
 
  def edit
    @q = current_user.generalledgers.search(params[:q])
    @generalledgers = @q.result(distinct: true).order(date: :desc).page(params[:page]).per(100)    
    @generalledger = @update_generalledger
  end
  
  def update
    params[:generalledger][:amount] = params[:generalledger][:amount].gsub(",","") if params[:generalledger][:amount].present?
    @update_generalledger.update(generalledger_params)
    
    redirect_to generalledgers_path
  end
  
  def destroy
    current_user.generalledgers.where(destroy_check: true).destroy_all
    redirect_to generalledgers_path
  end
  
  private
  def generalledger_params
    params.require(:generalledger).permit(:date, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode, :content, :trade_company, :amount, :destroy_check)
  end 
 
  def set_generalledger
    @update_generalledger = current_user.generalledgers.find(params[:id])
  end

end

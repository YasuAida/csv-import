class GeneralledgersController < ApplicationController
  include GeneralledgersHelper
  before_action :set_generalledger, only: [ :destroy]

  def index
    start_time = Time.now
    
    @journalpatterns = Journalpattern.all
    
    #「損益管理シート」から仕訳生成
     import_from_pladmins(@journalpatterns)
    
    #「仕入台帳」から仕訳生成  
     import_from_stocks(@journalpatterns)
    
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
  
  def destroy
    @update_generalledger.destroy
    redirect_to generalledgers_path, notice: 'データを削除しました'
  end
  
  private  
  def set_generalledger
    @update_generalledger = Generalledger.find(params[:id])
  end

end

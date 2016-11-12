class GeneralledgersController < ApplicationController
  include GeneralledgersHelper
  def index
    @journalpatterns = Journalpattern.all
    
    #「損益管理シート」から仕訳生成
    import_from_pladmins(@journalpatterns)
    
    #「仕入台帳」から仕訳生成  
    import_from_stocks(@journalpatterns)
    
    #「商品有高帳」から仕訳生成  
    import_from_stockledgers(@journalpatterns)
    
    #「付随費用」から仕訳生成
    import_from_subexpenses(@journalpatterns)
  end
end

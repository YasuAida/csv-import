class SalesController < ApplicationController
  include SalesHelper
  include ApplicationHelper #expenseledgerで為替レートを付与している

  def index
    @sales = Sale.all
    @q = Sale.search(params[:q])
    #@sales = @q.result(distinct: true).page(params[:page])
  end

  def upload
    data = params[:upload]
    #ファイルの登録
    data[:datafile].each do |datafile|
      file_open(datafile)
    #ファイルのインポート
      file_import_transaction(datafile)
    #ファイルの削除
      file_close(datafile)
    end

    redirect_to sales_path
  end
  
  def handling
    #「処理」欄を記入
    add_handling  
  end
  
  def pladmin  
    #損益管理シートへ売上・手数料の転記
      import_to_pladmin
      
      redirect_to pladmins_path      
  end

end

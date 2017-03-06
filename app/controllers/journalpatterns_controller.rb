class JournalpatternsController < ApplicationController
  before_action :set_journalpattern, only: [:edit, :update, :copy]
  before_action :logged_in_user
  
  def index
    @q = current_user.journalpatterns.search(params[:q])
    @journalpatterns = @q.result(distinct: true).page(params[:page]).per(150)
    @journalpattern = current_user.journalpatterns.build
  end

  def new
    @q = current_user.journalpatterns.search(params[:q])
    @journalpatterns = @q.result(distinct: true).page(params[:page]).per(150)
    @journalpattern = current_user.journalpatterns.build  
  end
  
  def create
    current_user.journalpatterns.create(journalpattern_params)
    redirect_to journalpatterns_path, notice: 'データを保存しました'
  end

  def edit
    @q = current_user.journalpatterns.search(params[:q])
    @journalpatterns = @q.result(distinct: true).page(params[:page]).per(150)   
    @journalpattern = @update_journalpattern
  end
  
  def update
    if @update_journalpattern.update(journalpattern_params)
      redirect_to journalpatterns_path, notice: "データを更新しました"
    else
      redirect_to journalpatterns_path, notice: "データの更新に失敗しました"
    end
  end
  
  def copy
    @copy_journalpattern = @update_journalpattern.dup
    @copy_journalpatterns = current_user.journalpatterns.where(ledger: @copy_journalpattern.ledger, debit_account: @copy_journalpattern.debit_account, debit_subaccount: @copy_journalpattern.debit_subaccount, credit_account: @copy_journalpattern.credit_account, credit_subaccount: @copy_journalpattern.credit_subaccount)
    @copy_journalpattern.pattern = @copy_journalpattern.pattern + "(" + @copy_journalpatterns.count.to_s + ")"
    if @copy_journalpattern.save
      @copy_journalpatterns = current_user.journalpatterns.where(ledger: @copy_journalpattern.ledger, debit_account: @copy_journalpattern.debit_account, debit_subaccount: @copy_journalpattern.debit_subaccount, credit_account: @copy_journalpattern.credit_account, credit_subaccount: @copy_journalpattern.credit_subaccount)
    else
      redirect_to :back 
    end  
  end

  def destroy
    current_user.journalpatterns.where(destroy_check: true).destroy_all
    redirect_to journalpatterns_path
  end
  
  private
  def journalpattern_params
    params.require(:journalpattern).permit(:taxcode, :ledger, :pattern, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode, :reference, :destroy_check)
  end
  
  def set_journalpattern
    @update_journalpattern = current_user.journalpatterns.find(params[:id])
  end
end

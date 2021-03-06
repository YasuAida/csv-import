class JournalpatternsController < ApplicationController
  before_action :set_journalpattern, only: [ :update, :destroy]   

  def index
    @journalpatterns = Journalpattern.all.order(:ledger)
    @journalpattern = Journalpattern.new
  end
  
  def create
    @journalpattern = Journalpattern.create(journalpattern_params)
    redirect_to journalpatterns_path, notice: 'データを保存しました'
  end
  
  def update
    if @update_journalpattern.update(journalpattern_params)
      redirect_to journalpatterns_path, notice: "データを更新しました"
    else
      redirect_to journalpatterns_path, notice: "データの更新に失敗しました"
    end
  end

  def destroy
    @update_journalpattern.destroy
    redirect_to journalpatterns_path  
  end
  
  private
  def journalpattern_params
    params.require(:journalpattern).permit(:taxcode, :ledger, :pattern, :debit_account, :debit_subaccount, :debit_taxcode, :credit_account, :credit_subaccount, :credit_taxcode, :reference)
  end
  
  def set_journalpattern
    @update_journalpattern = Journalpattern.find(params[:id])
  end
end

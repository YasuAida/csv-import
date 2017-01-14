class EntrypatternsController < ApplicationController
  before_action :set_entrypattern, only: [ :update, :destroy]
  before_action :logged_in_user
  
  def index
    @entrypatterns = current_user.entrypatterns.all
  end
  
  def create
    @entrypattern = current_user.entrypatterns.build(entrypattern_params)
    @entrypattern.save
    redirect_to entrypatterns_path, notice: 'データを保存しました'
  end
  
  def update
    if @update_entrypattern.update(entrypattern_params)
      redirect_to entrypatterns_path, notice: "データを更新しました"
    else
      redirect_to entrypatterns_path
    end
  end

  def destroy
    current_user.entrypatterns.where(destroy_check: true).destroy_all
    redirect_to entrypatterns_path  
  end
  
  private
  def entrypattern_params
    params.require(:entrypattern).permit(:sku, :kind_of_transaction, :kind_of_payment, :detail_of_payment, :handling)
  end
  
  def set_entrypattern
    @update_entrypattern = current_user.entrypatterns.find(params[:id])
  end
end
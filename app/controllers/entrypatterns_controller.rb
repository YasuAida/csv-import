class EntrypatternsController < ApplicationController
  before_action :set_entrypattern, only: [:edit, :update, :copy]
  before_action :logged_in_user
  
  def index
    @q = current_user.entrypatterns.search(params[:q])
    @entrypatterns = @q.result(distinct: true).page(params[:page]).per(150)
  end

  def new
    @q = current_user.entrypatterns.search(params[:q])
    @entrypatterns = @q.result(distinct: true).page(params[:page]).per(150)
    @entrypattern = current_user.entrypatterns.build  
  end
  
  def create
    @entrypattern = current_user.entrypatterns.build(entrypattern_params)
    @entrypattern.save
    redirect_to entrypatterns_path, notice: 'データを保存しました'
  end

  def edit
    @q = current_user.entrypatterns.search(params[:q])
    @entrypatterns = @q.result(distinct: true).page(params[:page]).per(150)  
    @entrypattern = @update_entrypattern
  end
  
  def update
    if @update_entrypattern.update(entrypattern_params)
      redirect_to entrypatterns_path, notice: "データを更新しました"
    else
      redirect_to entrypatterns_path
    end
  end

  def copy
    @copy_entrypattern = @update_entrypattern.dup
    @copy_entrypatterns = current_user.entrypatterns.where(sku: @copy_entrypattern.sku, kind_of_transaction: @copy_entrypattern.kind_of_transaction, kind_of_payment: @copy_entrypattern.kind_of_payment, detail_of_payment: @copy_entrypattern.detail_of_payment)
    @copy_entrypattern.handling = @copy_entrypattern.handling + "(" + @copy_entrypatterns.count.to_s + ")"
    if @copy_entrypattern.save
      @copy_entrypatterns = current_user.entrypatterns.where(sku: @copy_entrypattern.sku, kind_of_transaction: @copy_entrypattern.kind_of_transaction, kind_of_payment: @copy_entrypattern.kind_of_payment, detail_of_payment: @copy_entrypattern.detail_of_payment)
    else
      redirect_to :back 
    end  
  end

  def destroy
    current_user.entrypatterns.where(destroy_check: true).destroy_all
    redirect_to entrypatterns_path  
  end
  
  private
  def entrypattern_params
    params.require(:entrypattern).permit(:sku, :kind_of_transaction, :kind_of_payment, :detail_of_payment, :handling, :destroy_check)
  end
  
  def set_entrypattern
    @update_entrypattern = current_user.entrypatterns.find(params[:id])
  end
end
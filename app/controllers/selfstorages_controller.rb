class SelfstoragesController < ApplicationController
  include SelfstoragesHelper
  before_action :set_selfstorage, only: [ :update, :destroy] 
  before_action :logged_in_user
  
  def index
    @selfstorage = current_user.selfstorages.build
    #@selfstorages = current_user.selfstorages.all
    @q = current_user.selfstorages.search(params[:q])
    @selfstorages = @q.result(distinct: true).order(:sku).page(params[:page])
  end
  
  def create
    @selfstorage = current_user.selfstorages.build(selfstorage_params)
    
    #stock_idの付与
    attachment_of_stock_id(@selfstorage)
    
    @selfstorage.save
    redirect_to selfstorages_path , notice: '保存しました'    
  end
  
  def update
    if @selfstorage.update(selfstorage_params)
      
    #stock_idの付与
    attachment_of_stock_id(@selfstorage)
      
    redirect_to selfstorages_path , notice: '保存しました'
    end
  end
  
  def destroy
    @selfstorage.where(destroy_check: true).destroy_all
    redirect_to disposals_path, notice: 'データを削除しました'
  end
  
  private
  def selfstorage_params
    params.require(:selfstorage).permit( :sku)
  end
  
  def set_selfstorage
    @selfstorage = current_user.selfstorages.find(params[:id])
  end
end


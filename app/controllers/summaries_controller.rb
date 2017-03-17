class SummariesController < ApplicationController
  before_action :set_summary, only: [:update]
  before_action :logged_in_user
  
  def index
    @q = current_user.summaries.search(params[:q])
    @summaries = @q.result(distinct: true).order(closing_date: :desc).page(params[:page]).per(150)
    @summary = current_user.summaries.build    
  end 

  def create
    @all_sales = current_user.sales.where.not(kind_of_transaction: "Amazonに支払う額 | 出品者からの返済額")
    @all_sales.group(:closing_date).each do |totals|
      total_sales = @all_sales.where(closing_date: totals.closing_date).sum(:amount)
      current_user.summaries.create(closing_date: totals.closing_date, total_sales: total_sales)      
    end
    redirect_to summaries_path
  end
  
  def update
    if @update_summary.update(summary_params)
      redirect_to :back
    else
      redirect_to :back
    end
  end

  def destroy
    current_user.summaries.where(destroy_check: true).destroy_all
    redirect_to summaries_path
  end
  
  private
  def summary_params
    params.require(:summary).permit(:bank, :money_receipt_date, :destroy_check)
  end
  
  def set_summary
    @update_summary = current_user.summaries.find(params[:id])
  end
end

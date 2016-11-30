class PeriodsController < ApplicationController
  def index
    @periods = Period.all.order(:monthly_yearly).order(:period_start).page(params[:page])
  end
  
  def create
    @beginning = Period.new(period_params)
    if @beginning.save
      #月次の最初の期間
        @beginning.monthly_yearly = "月次"
        @beginning.period_start = @beginning.beginning_date
        @beginning.period_end = @beginning.beginning_date.end_of_month
        @beginning.save
      #期首から今日までの月数を計算
        today = Date.today
        today_months = today.year * 12 + today.month
        calculating_start_date = @beginning.beginning_date.end_of_month + 1
        calculating_months =  calculating_start_date.year * 12 + calculating_start_date.month
        months_diff = today_months - calculating_months
      #月数分だけ会計期間を作る
        count = 0
        start_date = calculating_start_date
        while count < months_diff do
          @periods = Period.new(monthly_yearly: "月次")
          @periods.period_start = start_date
          @periods.period_end = start_date.end_of_month
          @periods.save
          
          start_date = start_date.end_of_month + 1
          count = count + 1
        end
      #最後に今期の会計期間を作る  
        @periods = Period.new(monthly_yearly: "月次")
        @periods.period_start = start_date
        @periods.period_end = today
        @periods.save
        
      #年次の最初の期間
        @beginning.monthly_yearly = "年次"
        @beginning.period_start = @beginning.beginning_date
        @beginning.period_end = @beginning.beginning_date.end_of_year
        @beginning.save
      #期首から今日までの月数を計算
        today = Date.today
        today_years = today.year
        calculating_start_date = @beginning.beginning_date.end_of_year + 1
        calculating_years =  calculating_start_date.year
        years_diff = today_years - calculating_years
      #月数分だけ会計期間を作る
        count = 0
        start_date = calculating_start_date
        while count < years_diff do
          @periods = Period.new(monthly_yearly: "年次")
          @periods.period_start = start_date
          @periods.period_end = start_date.end_of_year
          @periods.save
          
          start_date = start_date.end_of_year + 1
          count = count + 1
        end
      #最後に今期の会計期間を作る  
        @periods = Period.new(monthly_yearly: "年次")
        @periods.period_start = start_date
        @periods.period_end = today
        @periods.save

      redirect_to periods_path, notice: 'データを保存しました'
    else
      redirect_to periods_path, notice: 'データの保存に失敗しました'
    end
  end
  
  private
  def period_params
    params.require(:period).permit(:beginning_date)
  end  
end

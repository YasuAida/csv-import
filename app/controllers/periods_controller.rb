class PeriodsController < ApplicationController
  def index
    @periods = Period.all.order(:monthly_yearly).order(period_start: :desc).page(params[:page]).per(100)
  end
    
  def create
    Period.destroy_all
    FinancialStatement.destroy_all
    
    @monthly_beginning = Period.new(period_params)
    if @monthly_beginning.save
      #月次の最初の期間
        @monthly_beginning.monthly_yearly = "月次"
        @monthly_beginning.period_end = @monthly_beginning.period_start.end_of_month
        @monthly_beginning.save
      #期首から今日までの月数を計算
        today = Date.today
        today_months = today.year * 12 + today.month
        calculating_start_date = @monthly_beginning.period_start.end_of_month + 1
        calculating_months =  calculating_start_date.year * 12 + calculating_start_date.month
        months_diff = today_months - calculating_months
      #月数分だけ会計期間を作る
        count = 0
        start_date = calculating_start_date
        while count < months_diff do
          @monthly_periods = Period.new(monthly_yearly: "月次")
          @monthly_periods.period_start = start_date
          @monthly_periods.period_end = start_date.end_of_month
          @monthly_periods.save
          
          start_date = start_date.end_of_month + 1
          count = count + 1
        end
      #最後に今期の会計期間を作る  
        @monthly_last = Period.new(period_start: start_date)
        @monthly_last.monthly_yearly = "月次"
        @monthly_last.period_end = today
        @monthly_last.save
        
      #年次の最初の期間
        @yearly_beginning = Period.new(period_params)
        @yearly_beginning.monthly_yearly = "年次"
        @yearly_beginning.period_end = @yearly_beginning.period_start.end_of_year
        @yearly_beginning.save
      #期首から今日までの月数を計算
        today = Date.today
        today_years = today.year
        calculating_start_date = @yearly_beginning.period_start.end_of_year + 1
        calculating_years =  calculating_start_date.year
        years_diff = today_years - calculating_years
      #月数分だけ会計期間を作る
        count = 0
        start_date = calculating_start_date
        while count < years_diff do
          @yearly_periods = Period.new(monthly_yearly: "年次")
          @yearly_periods.period_start = start_date
          @yearly_periods.period_end = start_date.end_of_year
          @yearly_periods.save
          
          start_date = start_date.end_of_year + 1
          count = count + 1
        end
      #最後に今期の会計期間を作る  
        @yearly_last = Period.new(period_start: start_date)
        @yearly_last.monthly_yearly = "年次"
        @yearly_last.period_end = today
        @yearly_last.save
        
      redirect_to periods_path, notice: 'データを保存しました'
    else
      redirect_to periods_path, notice: 'データの保存に失敗しました'
    end
  end
  
  private
  def period_params
    params.require(:period).permit(:period_start)
  end  
end

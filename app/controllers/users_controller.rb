class UsersController < ApplicationController
  before_action :correct_user, only: [ :show, :update]  
  
  def index
    @user = User.new
    render 'new'
  end

  def show 
   @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      
      CSV.foreach('./db/entrypattern.csv') do |row|
        @entrypattern = Entrypattern.new(user_id: @user.id)
        @entrypattern.save
        @entrypattern.update(:sku => row[0], :kind_of_transaction => row[1], :kind_of_payment => row[2], :detail_of_payment => row[3], :handling => row[4])      
      end
      CSV.foreach('./db/journalpattern.csv') do |row|
        @journalpattern = Journalpattern.new(user_id: @user.id)
        @journalpattern.save
        @journalpattern.update(:taxcode => row[0], :ledger => row[1], :pattern => row[2], :debit_account => row[3], :debit_subaccount => row[4], :debit_taxcode => row[5], :credit_account => row[6], :credit_subaccount => row[7], :credit_taxcode => row[8])
      end
      CSV.foreach('./db/account.csv') do |row|
        @account = Account.new(user_id: @user.id) 
        @account.save
        @account.update(:account => row[0], :debit_credit => row[1], :bs_pl => row[2], :display_position => row[3])
      end
      @currency = Currency.new(user_id: @user.id)
      @currency.save
      @currency.update(name: '円', method: '換算無し')
      
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def update
    if @user.update(user_params)
      redirect_to user_path , notice: '保存しました'
    else
      redirect_to user_path , notice: '保存に失敗しました'
    end
  end
  
  def period
    current_user.periods.destroy_all
    current_user.financial_statements.destroy_all
    
    @monthly_beginning = current_user.periods.build(period_params)
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
          @monthly_periods = current_user.periods.build(monthly_yearly: "月次")
          @monthly_periods.period_start = start_date
          @monthly_periods.period_end = start_date.end_of_month
          @monthly_periods.save
          
          start_date = start_date.end_of_month + 1
          count = count + 1
        end
      #最後に今期の会計期間を作る  
        @monthly_last = current_user.periods.build(period_start: start_date)
        @monthly_last.monthly_yearly = "月次"
        @monthly_last.period_end = today
        @monthly_last.save
        
      #年次の最初の期間
        @yearly_beginning = current_user.periods.build(period_params)
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
          @yearly_periods = current_user.periods.build(monthly_yearly: "年次")
          @yearly_periods.period_start = start_date
          @yearly_periods.period_end = start_date.end_of_year
          @yearly_periods.save
          
          start_date = start_date.end_of_year + 1
          count = count + 1
        end
      #最後に今期の会計期間を作る  
        @yearly_last = current_user.periods.build(period_start: start_date)
        @yearly_last.monthly_yearly = "年次"
        @yearly_last.period_end = today
        @yearly_last.save
        
      redirect_to periods_path, notice: 'データを保存しました'
    else
      redirect_to periods_path, notice: 'データの保存に失敗しました'
    end
  end  
  
  private
  def user_params
    params.require(:user).permit(:name, :furigana, :postal_code, :address, :telephone_number, :email, :password, :password_confirmation, :entity, :start_date, :closing_date, :consumption_tax)
  end

  def period_params
    params.require(:period).permit(:period_start)
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path if @user != current_user
  end
end

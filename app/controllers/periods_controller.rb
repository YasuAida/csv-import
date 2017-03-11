class PeriodsController < ApplicationController
  before_action :logged_in_user
  
  def index
    @periods = current_user.periods.all.order(:monthly_yearly).order(period_start: :desc).page(params[:page]).per(100)
  end
  
end

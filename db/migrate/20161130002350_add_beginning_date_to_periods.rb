class AddBeginningDateToPeriods < ActiveRecord::Migration
  def change
    add_column :periods, :beginning_date, :date
    add_column :periods, :monthly_yearly, :string
  end
end

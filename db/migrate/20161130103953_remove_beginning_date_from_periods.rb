class RemoveBeginningDateFromPeriods < ActiveRecord::Migration
  def change
    remove_column :periods, :beginning_date, :date
  end
end

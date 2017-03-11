class RenamePeriodStartColumnOfUsers < ActiveRecord::Migration
  def change
    rename_column :users, :period_start, :closing_date
  end
end

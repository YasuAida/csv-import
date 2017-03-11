class ChangeDatatypePeriodStartOfUsers < ActiveRecord::Migration
  def change
    change_column :users, :period_start, :integer
  end
end

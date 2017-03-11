class AddStartDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :start_date, :date
    add_column :users, :period_start, :date
  end
end

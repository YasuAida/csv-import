class AddClosingDateDefaultToUsers < ActiveRecord::Migration
  def change
    change_column_default :users, :closing_date, 12
  end
end

class AddClosingDateToRakutens < ActiveRecord::Migration
  def change
    add_column :rakutens, :closing_date, :date
  end
end

class AddStartDateToRakutenSettings < ActiveRecord::Migration
  def change
    add_column :rakuten_settings, :start_date, :date
  end
end
